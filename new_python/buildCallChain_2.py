#!/usr/bin/python
__author__ = "currychen"

import sys
import init

def LastIndexOf(l, v):
    for i in range(len(l) - 1, -1, -1):
        if l[i] == v:
            return i

    return None
 
cursor = init.db.cursor()
sql_get_tid_list = "select distinct TID from " + init.case_table_name
sql_get_case_list = "select distinct CASE_ID from " + init.case_table_name


cursor.execute("DROP TABLE IF EXISTS "+init.chain_table_name)
sql_create_case_chain = r"create table "+init.chain_table_name+" (CASE_ID VARCHAR(1024),CHAIN VARCHAR(4096));"
cursor.execute(sql_create_case_chain)

#sql_create_classify_table = r"create table "+init.classify_table_name+" (FUNC_NAME VARCHAR(255),FUNC_CALLED_CHAIN VARCHAR(4096),CASE_ID VARCHAR(1024))"
#cursor.execute(sql_create_classify_table)


def get_func_cases(func,case_id,kind_num_dict):
    sql_get_func_chains = r"select CHAIN from " + init.chain_table_name + r" where CASE_ID = '" + case_id + "' AND CHAIN like binary '%" + func + "%';"
    cursor.execute(sql_get_func_chains)
    func_chain_list = cursor.fetchall()
    func_called_set = set()
    for chain in func_chain_list:
        index = chain[0].find(func) + len(func)-1
        called_chain = chain[0][:index+1] 
        func_called_set.add(called_chain)        
    kind_num_dict[case_id] = range(1,len(func_called_set)+1) 
    return kind_num_dict

def get_all_func_cases(func_name,case_list):
    kind_num_dict = dict()
    for case in case_list:
        kind_num_dict = get_func_cases(func_name,case,kind_num_dict)
    print "[Func_name chain_kind]:",func_name,"->",kind_num_dict
    return kind_num_dict

def build_chain_db():
    cursor.execute(sql_get_tid_list)
    tid_list = cursor.fetchall()

    cursor.execute(sql_get_case_list)
    case_list = cursor.fetchall()

    for case in case_list:

        call_chains = set()
        for tid in tid_list:
            level = 0 
            current_stack = []

            sql_get_stack_list = r"select FUNC_NAME , STATUS ,TIME_STAMP from "+init.case_table_name + r" where TID = '" + str(tid[0]) + r"' and CASE_ID = '" + str(case[0]) +"' ORDER BY TIME_STAMP;"
            cursor.execute(sql_get_stack_list)
            stack_list = cursor.fetchall()

            for line in stack_list: 
                name = line[0]
                op = line[1]
                time_stamp = line[2]
                if op == "in":
                    level += 1
                    current_stack.append(name)
                elif op == "return" and level > 0:
                    idx = LastIndexOf(current_stack, name)
                    if idx != None:
                        if idx != len(current_stack) - 1:
                            sys.exit("[FATAL]invalid return: {0}, time_stamp {1}".format(name, time_stamp))
                        del current_stack[idx]
                elif level > 0:
                    sys.exit("[FATAL]invalid op:[{0}][{1}][{2}]".format(op,name,time_stamp))
                else:
                    continue
                chain = '->'.join(current_stack)
                call_chains.add(chain)

        prev_chain = ""

        for chain in sorted(call_chains):
            if prev_chain != chain[:len(prev_chain)]:
                sql_insert = r"insert into "+init.chain_table_name+r" values(%s,%s);" 
                params = (case[0],prev_chain)
                cursor.execute(sql_insert,params)
            prev_chain = chain

        sql_insert = "insert into "+init.chain_table_name+" values(%s,%s);"
        params = (case[0],prev_chain)
        cursor.execute(sql_insert,params)
