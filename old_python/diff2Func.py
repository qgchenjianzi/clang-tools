# -*- coding: utf-8 -*-

import json
import MySQLdb

db_server = "localhost"
db_user = "root"
db_psw = "chenjianzi"
db_name = "MMREWRITER"

# open the connect of MySQLdb
db = MySQLdb.connect(db_server,db_user,db_psw,db_name)
db.autocommit(True)
cursor = db.cursor()

def findFunc(content):
    decodejson = json.loads(content) 
    for key in decodejson:
        for line in decodejson[key]:
            SELECT_FIND_HASH_CODE = """SELECT HASH_CODE,FUNC_NAME FROM NODE WHERE FUNC_START_LINE<="""+str(line)+""" AND """+str(line)+"""<=FUNC_END_LINE AND FILE_DIR LIKE '%"""+key+"""';"""
            cursor.execute(SELECT_FIND_HASH_CODE)
            results = cursor.fetchall()
            if results:
                for result in results:
                    hash_code = result[0]
                    SELECT_FIND_CASE = """SELECT DISTINCT CASE_LIST FROM FUNC_CASE_LIST WHERE HASH_CODE = """+str(hash_code)+""";""" 
                    cursor.execute(SELECT_FIND_CASE)
                    case_list = cursor.fetchall()
                    if case_list:
                        print result[1], case_list

# load the gitdiff.json
if "__main__" == __name__:
    import sys
    if len(sys.argv) == 2:
        content = open(sys.argv[1]).read()
        findFunc(content)
