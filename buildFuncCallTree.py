# -*- coding: utf-8 -*-
__author__ = 'currychen'

# Build the function call tree and create a new table to save it

import MySQLdb

db_server = "localhost"
db_user = "root"
db_psw = "chenjianzi"
db_name = "MMREWRITER"

# open the connect of MySQLdb
db = MySQLdb.connect(db_server,db_user,db_psw,db_name)
db.autocommit(True)
cursor = db.cursor()

cursor.execute("""DROP TABLE IF EXISTS FUNC_CALL""")
SELECT_FUNC = """SELECT FUNC_NAME,STATUS,THREAD_ID FROM FUNC_CASE_LIST ORDER BY THREAD_ID,TIME_STAMP;"""

CREATE_FUNC_CALL_LIST="""CREATE TABLE FUNC_CALL
                        (FUNC_NAME VARCHAR(255),
                        FUNC_CALL_LIST VARCHAR(4096));"""
cursor.execute(CREATE_FUNC_CALL_LIST)

func_call_dict = dict()
str_func_call = ""

level_list = 0
str_func_call_list = []
str_func_list = []

# save the call tree in MySQL
def list_all_dict(dict_a):
    global level_list , str_func_call , str_func_list
    level_list = level_list - 1
    if isinstance(dict_a,dict) and dict_a:
        for x in range(len(dict_a)):
            temp_key = dict_a.keys()[x]
            temp_value = dict_a[temp_key]
            list_all_dict(temp_value)
            str_func_list.append(temp_key)
            level_list = level_list + 1
            if level_list == -1:
                str_func_call = temp_key + str_func_call
                str_func_call_list.append(str_func_call)
                print str_func_call
                for __func_name in str_func_list:
                    print __func_name
                    INSERT_FUNC_CALL_LIST = """INSERT INTO FUNC_CALL VALUES(%s,%s)"""
                    param = (__func_name,str_func_call)
                    cursor.execute(INSERT_FUNC_CALL_LIST,param)
                str_func_call = ""
                str_func_list = []
            else:
                str_func_call = "," + temp_key + str_func_call


def initial_dict(dict_a,level,value):
    level = level - 1 
    if level == 0 :
        dict_a[value] = dict()
    else:
        if len(dict_a):
            # everything that insert is appended at the end
            temp_key = dict_a.keys()[len(dict_a)-1] 
            temp_value = dict_a[temp_key]
            initial_dict(temp_value,level,value)

# initial the func_call dict
level_num = 0
cursor.execute(SELECT_FUNC)
results = cursor.fetchall()
for func in results:
    if func:
        func_name = func[0]
        status = func[1]
        thread_id = func[2]
        if cmp(status,"in")==0:
            level_num = level_num+1
            initial_dict(func_call_dict,level_num,func_name)
        elif cmp(status,"return")==0 and level_num > 0 :
            level_num = level_num-1

list_all_dict(func_call_dict)

