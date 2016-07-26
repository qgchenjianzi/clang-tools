#!/usr/bin/python2.7
# -*- coding: UTF-8 -*-
import MySQLdb
import sys

db_server = "localhost"
db_user = "root"
db_psw = "chenjianzi"
db_name = "MMREWRITER"

# open the connect of MySQLdb
db = MySQLdb.connect(db_server,db_user,db_psw,db_name)
db.autocommit(True)
# use cursor()
cursor = db.cursor()

cursor.execute("DROP TABLE IF EXISTS NODE")

CREATE_NODE_TABLE = """CREATE TABLE NODE(
HASH_CODE long,
FILE_DIR varchar(255),
FUNC_NAME varchar(255),
FUNC_ARGS varchar(255),
FUNC_START_LINE int,
FUNC_END_LINE int
);"""
cursor.execute(CREATE_NODE_TABLE)

CREATE_INDEX_FUNC_S = """CREATE INDEX FUNC_START_LINE ON NODE(FUNC_START_LINE);"""
cursor.execute(CREATE_INDEX_FUNC_S)

CREATE_INDEX_FUNC_E = """CREATE INDEX FUNC_END_LINE ON NODE(FUNC_END_LINE);"""
cursor.execute(CREATE_INDEX_FUNC_E)

def analyze_content(content):
    lines = [l.strip() for l in content.split("\n")]
    for line in lines:
        index = [l.strip() for l in line.split("@")]
        if line.strip():     
            hashCode = index[0]
            fileDir = index[1]
            funcName = index[2]
            funcArgs = index[3]
            funcStartLine = index[4]
            funcEndLine = index[5]
            INSERT_BLOCK = "INSERT INTO NODE (HASH_CODE,FILE_DIR,FUNC_NAME,FUNC_ARGS,FUNC_START_LINE,FUNC_END_LINE) VALUES(%s,%s,%s,%s,%s,%s);"
            param = (hashCode,fileDir,funcName,funcArgs,funcStartLine,funcEndLine)
            cursor.execute(INSERT_BLOCK,param)

if "__main__" == __name__:
    if len(sys.argv) == 2:
        content = open(sys.argv[1]).read()
        analyze_content(content)
