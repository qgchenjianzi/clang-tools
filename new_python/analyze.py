# -*- coding: utf-8 -*-
__author__ = 'currychen'
import re
from pybloom import BloomFilter
import json
import init
import buildCallChain_2
import mm_utils

format_case_file = ".log"

MAX_CAPACITY = 200000
ERROR_RATE = 0.01

# use cursor()
cursor = init.db.cursor()
cursor.execute("DROP TABLE IF EXISTS CASE_VERSION") 
DROP_FUNC_STACK_TABLE = "DROP TABLE IF EXISTS "+init.case_table_name
cursor.execute(DROP_FUNC_STACK_TABLE) 

CREATE_CASE_VERSION = """CREATE TABLE CASE_VERSION
                        (CASE_ID VARCHAR(50),
                        PATH VARCHAR(255),
                        VERSION VARCHAR(255),
                        BLOOMFILTER VARCHAR(255));"""
CREATE_CASE_FUNC_STACK = r"CREATE TABLE "+ init.case_table_name +r" (CASE_ID VARCHAR(255),FUNC_NAME VARCHAR(255),TID VARCHAR(255),STATUS VARCHAR(12),TIME_STAMP BIGINT);"
cursor.execute(CREATE_CASE_VERSION)
cursor.execute(CREATE_CASE_FUNC_STACK)


def create_dir(path):
    import os
    import shutil
    path = path.strip()
    path = path.rstrip("\\")
    isExist = os.path.exists(path)
    if isExist:
        shutil.rmtree(path)
    os.makedirs(path)

def get_bf_filename(case_file):
    bf_filename = init.dir_bf_files + "br_" + case_file
    return bf_filename

def build_one_case(case_file):
    bf = BloomFilter(capacity=MAX_CAPACITY,error_rate=0.01)
    case_file_path = init.dir_case_files + case_file + format_case_file
    for line in open(case_file_path,"r").readlines():
        ls = line.strip().split(r'!#!')
        if len(ls) < 5:
            print "case_file: ",case_file_path," dump line: ",line
        func_name = ls[1]
        tid = ls[2]
        status = ls[3]
        time_stamp = ls[4]
        hash_code = ls[0]
        insert_func_stack = "insert into "+init.case_table_name+" values(%s,%s,%s,%s,%s)"
        param_func_stack = (case_file,func_name,tid,status,time_stamp)
        cursor.execute(insert_func_stack,param_func_stack)
        bf.add(hash_code)
    print case_file," bf_set size: ",len(bf)
    bf_filename = get_bf_filename(case_file)
    bf.tofile(open(bf_filename,"wb"))
    sql = "insert into CASE_VERSION VALUES(%s,%s,%s,%s)" 
    case_file_path = init.dir_case_files + case_file + format_case_file
    param = (case_file,case_file_path," ",bf_filename)
    cursor.execute(sql,param)
    return bf_filename

def get_bf_by_case(case_file_path):
    sql = "select BLOOMFILTER from CASE_VERSION where PATH=" + case_file_path   
    cursor.execute(sql)
    bf_filename = cursor.fetchone()
    return BloomFilter.fromfile(open(bf_filename,"rb"))

# Get case list from file
def get_case_list():
    import os
    file_list = os.listdir(init.dir_case_files)
    case_list = [] 
    for file in file_list:
        index = file.find(format_case_file)
        if index >= 0:
            case_list.append(file[:index]) 
    return case_list

def build_all_case_files():
    for case_file in get_case_list():
        build_one_case(case_file)

# Separating the clang-log from the global log
def read_log_lines(file):
    result = list()
    f = open(file,'r')
    exp = r'(?<=\bMMRewriter@).*'
    pattern = re.compile(exp) 
    for line in f.readlines():
        line = line.strip()
        if not len(line):
            continue
        match = re.search(pattern,line)
        if match:
            match_text = match.group()
            result.append(match_text)
            index = [l.strip() for l in match_text.split("@")]
            if index:
                status = index[0]
                thread_id = index[1]
                line_num = index[2]
                file_dir = index[3]
                func_name = index[4]
                hash_code = mm_utils.BKDRHash(func_name)
                time_stamp = index[5]
                case = index[6]
                case_file_path = init.dir_case_files + case + format_case_file 
                fp = open(case_file_path,'a')
                write_buf = str(hash_code) + "!#!" + func_name + "!#!" + thread_id+ "!#!" + status + "!#!" + time_stamp + "\n"
                fp.write(write_buf)
    return result;

def split_wechat_floder(file_path):
    return file_path.split("wechat/")[-1]

report_list = list()
# Get the coder_name through git blame
def analyze_git_blame(file_path,func_name,blame_line):
    import os
    file_path = split_wechat_floder(file_path)
    sh_cd_wechat_prj = "cd " + init.dir_wechat_prj + "\n"
    sh_git_blame = "git blame -L " + str(blame_line) + ",+1 " + file_path
    sh_all = sh_cd_wechat_prj + sh_git_blame 
    r = os.popen(sh_all)
    blame_text = r.read()
    r.close()
    split_space = blame_text.split(" ")
    if split_space: 
        coder_name = split_space[1].split("(")[-1].strip().lstrip()
        report = "coder_name:"+ coder_name + " func_name:"+func_name + " file_path:"+file_path+" blame_line:"+blame_line
        print report 
        func_coder_dict[func_name] = coder_name
        report_list.append(report)

# Global list variable to save the case found
global_accurate_case_list = list()
func_coder_dict = dict()
func_change_list = list()
func_cases_kind = dict()

# Check the case whether in the BloomFilter
def get_accurate_case(sql_result,blame_line,func_case_list):
    import os
    hash_code = sql_result[0]
    func_name = sql_result[1]
    file_path = sql_result[2]
    func_start_line = sql_result[3]
    func_end_line = sql_result[4]
    sql = "select CASE_ID,BLOOMFILTER from CASE_VERSION" 
    cursor.execute(sql)
    rows = cursor.fetchall()
    for row in rows:
        case_id = row[0]
        BloomFilter_file = row[1]
        if os.path.exists(BloomFilter_file): 
            bf = BloomFilter.fromfile(open(BloomFilter_file,"rb"))            
            if hash_code in bf:
                global_accurate_case_list.append(case_id)
                analyze_git_blame(file_path,func_name,blame_line)
                func_case_list.append(case_id)
    return func_case_list

# Get the change function from gitdiff.json
def get_change_func():
    import os
    if not os.path.exists(init.dir_git_json): 
        print "git diff json not exist: ",init.dir_git_json
    content = open(init.dir_git_json,"r").read()
    decodejson = json.loads(content)
    # The json key is the filename
    for key in decodejson:
        temp_case_list = list()
        pre_func_name = ""
        for line in decodejson[key]:
            SELECT_FIND_HASH_CODE = """SELECT HASH_CODE,FUNC_NAME,FILE_DIR,FUNC_START_LINE,FUNC_END_LINE FROM NODE WHERE FUNC_START_LINE<="""+str(line)+""" AND """+str(line)+"""<=FUNC_END_LINE AND FILE_DIR LIKE '%"""+key+"""';"""
            cursor.execute(SELECT_FIND_HASH_CODE)
            result = cursor.fetchone()
            if result:
                func_name = result[1]
                if func_name != pre_func_name:
                    func_change_list.append(func_name)
                    temp_case_list = get_accurate_case(result,str(line),temp_case_list)
                    if op == op_func_cases: 
                       case_kind_num_dict = buildCallChain_2.get_all_func_cases(func_name,temp_case_list)
                       func_cases_kind[func_name] = case_kind_num_dict
                pre_func_name = func_name

    if op == op_global_cases:                 
        accurate_case_set = set(global_accurate_case_list) 
        return accurate_case_set
    return func_cases_kind 
    
def get_func_accurate_info(func_name,case_kind_num_dict):
    case_dict = case_kind_num_dict[func_name]
    for case_kind in case_dict:
        print "[Function Name Accurate Cases]{0}".format(case_kind)


op = ""
op_global_cases = "global_cases"
op_func_cases = "func_cases"
if "__main__" == __name__:
    import sys
    if len(sys.argv) >= 2:
       create_dir(init.dir_case_files)
       create_dir(init.dir_bf_files)
       read_log_lines(sys.argv[1])
       build_all_case_files()
    if len(sys.argv) == 3:
       op = sys.argv[2]
       if op == "global_cases":
           accurate_case_set = get_change_func()
           if accurate_case_set:
              print "accurate case :"
              for case in accurate_case_set:
                  print case," "
           else:
               print "No case get!!"
       elif op == "func_cases":
           buildCallChain_2.build_chain_db()
           case_kind_num_dict = get_change_func()
           get_func_accurate_info(r"-[WeixinContactInfoAssist initFooterBtnArea]",case_kind_num_dict)
