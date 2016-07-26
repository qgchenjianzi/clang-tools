# -*- coding: utf-8 -*-
__author__ = 'currychen'
import MySQLdb
import re
 
db_server = "localhost"
db_user = "root"
db_psw = "chenjianzi"
db_name = "MMREWRITER"

# open the connect of MySQLdb
db = MySQLdb.connect(db_server,db_user,db_psw,db_name)
db.autocommit(True)
# use cursor()
cursor = db.cursor()
cursor.execute("DROP TABLE IF EXISTS FUNC_CASE_LIST")

CREATE_FUNC_CASE_LIST = """CREATE TABLE FUNC_CASE_LIST
                        (STATUS VARCHAR(10),
                         THREAD_ID VARCHAR(255),
                         LINE_NUM INT,
                         FILE_DIR VARCHAR(2048),
                         FUNC_NAME VARCHAR(255),
                         HASH_CODE long,
                         TIME_STAMP BIGINT(255),
                         CASE_LIST VARCHAR(1024));"""
cursor.execute(CREATE_FUNC_CASE_LIST)

def BKDRHash(string):
    seed = 131
    hash = 0
    for ch in string:
        hash = hash * seed + ord(ch)
    return hash & 0x7FFFFFFF

# Separating the clang-log in global log
def read_log_lines(file):
    result = list()
    f = open(file,'r')
    exp = '(?<=\\bMMRewriter@).*'
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
                INSERT_FUNC_CASE = """INSERT INTO FUNC_CASE_LIST VALUES(%s,%s,%s,%s,%s,%s,%s,%s)"""
                params = (status,thread_id,line_num,file_dir,func_name,hash_code,time_stamp,case) 
                cursor.execute(INSERT_FUNC_CASE,params)

    return result;

if "__main__" == __name__:
    import sys
    if len(sys.argv) == 2:
       read_log_lines(sys.argv[1])
