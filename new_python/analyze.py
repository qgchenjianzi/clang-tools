# -*- coding: utf-8 -*-
__author__ = 'currychen'
import MySQLdb
import re
from pybloom import BloomFilter
import json
 
db_server = "localhost"
db_user = "root"
db_psw = "chenjianzi"
db_name = "MMREWRITER"

dir_clang_tools = r"/Users/currychen/clang-tools"
dir_analyze_files = dir_clang_tools + r"/analyze_files/"
dir_src = "dir_clang_tools" + "/src/"
dir_case_files = dir_analyze_files + r"case_files/"
dir_bf_files = dir_analyze_files + r"bf_files/"
dir_node_file = dir_src + "node.txt"
dir_git_json = dir_clang_tools + "/new_python/"+"gitdiff.json"

format_case_file = ".log"

MAX_CAPACITY = 200000
ERROR_RATE = 0.01

# open the connect of MySQLdb
db = MySQLdb.connect(db_server,db_user,db_psw,db_name)
db.autocommit(True)
# use cursor()
cursor = db.cursor()
cursor.execute("DROP TABLE IF EXISTS FUNC_CASE_LIST")
cursor.execute("DROP TABLE IF EXISTS CASE_VERSION") 

CREATE_FUNC_CASE_LIST = """CREATE TABLE FUNC_CASE_LIST
                        (STATUS VARCHAR(10),
                         THREAD_ID VARCHAR(255),
                         LINE_NUM INT,
                         FILE_DIR VARCHAR(2048),
                         FUNC_NAME VARCHAR(255),
                         HASH_CODE long,
                         TIME_STAMP BIGINT(255),
                         CASE_LIST VARCHAR(1024));"""
CREATE_CASE_VERSION = """CREATE TABLE CASE_VERSION
                        (CASE_ID VARCHAR(50),
                        PATH VARCHAR(255),
                        VERSION VARCHAR(255),
                        BLOOMFILTER VARCHAR(255));"""
cursor.execute(CREATE_FUNC_CASE_LIST)
cursor.execute(CREATE_CASE_VERSION)

def BKDRHash(string):
    seed = 131
    hash = 0
    for ch in string:
        hash = hash * seed + ord(ch)
    return hash & 0x7FFFFFFF

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
    bf_filename = dir_bf_files + "br_" + case_file
    return bf_filename

def build_one_case(case_file):
    bf = BloomFilter(capacity=MAX_CAPACITY,error_rate=0.01)
    case_file_path = dir_case_files + case_file + format_case_file
    for line in open(case_file_path):
        ls = line.strip().split(r'!#!')
        if len(ls) != 3:
            print "case_file: ",case_file_path," dump line: ",line
        hash_code = ls[0]
        bf.add(hash_code)
    print "trace len: ",len(bf)
    bf_filename = get_bf_filename(case_file)
    bf.tofile(open(bf_filename,"wb"))
    sql = "insert into CASE_VERSION VALUES(%s,%s,%s,%s)" 
    case_file_path = dir_case_files + case_file + format_case_file
    param = (case_file,case_file_path," ",bf_filename)
    cursor.execute(sql,param)
    return bf_filename

def get_bf_by_case(case_file_path):
    sql = "select BLOOMFILTER from CASE_VERSION where PATH=" + case_file_path   
    cursor.execute(sql)
    bf_filename = cursor.fetchone()
    return BloomFilter.fromfile(open(bf_filename,"rb"))

def find_case(hash_code,case_file_path):
    import os
    sql = "select CASE_ID,PATH,BLOOMFILTER from CASE_VERSION where PATH=" + case_file_path   
    cursor.execute(sql)
    rows = cursor.fetchall()
    ret = dict()
    for row in rows:
        case_id = row[0] 
        bloom_filename = row[2]
        if os.path.exists(bloom_filename):
            bf = BloomFilter.fromfile(open(bloom_filename,"rb"))            
            if hash_code in bf:
                detail = dict()
                detail["path"] = row[1]
                detail["bf"] = bloom_filename
                ret[case_id] = detail
        else:
            print "check this bloom_file: ",bloom_filename
    return ret

def get_case_list():
    import os
    file_list = os.listdir(dir_case_files)
    case_list = [] 
    for file in file_list:
        index = file.find(format_case_file)
        if index >= 0:
            case_list.append(file[:index]) 
    return case_list

def build_all_case_files():
    for case_file in get_case_list():
        build_one_case(case_file)

# Separating the clang-log in global log
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
                hash_code = BKDRHash(func_name)
                time_stamp = index[5]
                case = index[6]
                case_file_path = dir_case_files + case + format_case_file 
                fp = open(case_file_path,'a')
                write_buf = str(hash_code) + "!#!" + func_name + "!#!" + thread_id+"\n"
                fp.write(write_buf)
    return result;


accurate_case_list = list()
def get_accurate_case(hash_code):
    import os
    sql = "select CASE_ID,BLOOMFILTER from CASE_VERSION" 
    cursor.execute(sql)
    rows = cursor.fetchall()
    for row in rows:
        case_id = row[0]
        BloomFilter_file = row[1]
        if os.path.exists(BloomFilter_file): 
            bf = BloomFilter.fromfile(open(BloomFilter_file,"rb"))            
            if hash_code in bf:
                accurate_case_list.append(case_id)

def get_change_func():
    import os
    if not os.path.exists(dir_git_json): 
        print "git diff json not exist: ",dir_git_json
    content = open(dir_git_json,"r").read()
    decodejson = json.loads(content)
    for key in decodejson:
        for line in decodejson[key]:
            SELECT_FIND_HASH_CODE = """SELECT HASH_CODE,FUNC_NAME FROM NODE WHERE FUNC_START_LINE<="""+str(line)+""" AND """+str(line)+"""<=FUNC_END_LINE AND FILE_DIR LIKE '%"""+key+"""';"""
            cursor.execute(SELECT_FIND_HASH_CODE)
            result = cursor.fetchone()
            if result:
                hash_code = result[0]
                get_accurate_case(hash_code)
    accurate_case_set = set(accurate_case_list) 
    return accurate_case_set

if "__main__" == __name__:
    import sys
    if len(sys.argv) == 2:
       create_dir(dir_case_files)
       create_dir(dir_bf_files)
       read_log_lines(sys.argv[1])
       build_all_case_files()
       accurate_case_set = get_change_func()
       if accurate_case_set:
          print "accurate case :"
          for case in accurate_case_set:
              print case," "
       else:
           print "No case get!!"
