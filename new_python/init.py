import MySQLdb
import time

db_server = "localhost"
db_user = "root"
db_psw = "chenjianzi"
db_name = "MMREWRITER"

db = MySQLdb.connect(db_server,db_user,db_psw,db_name)
db.autocommit(True)

date_time = time.strftime("%Y%m%d",time.localtime())
case_table_name = "case_"+date_time 
chain_table_name = "chain_"+date_time
classify_table_name = "classify_"+date_time

dir_wechat_prj = r"/Users/currychen/Documents/git_prj/wechat_diff/br_trunk_dump/"
dir_clang_tools = r"/Users/currychen/clang-tools"
dir_analyze_files = dir_clang_tools + r"/analyze_files/"
dir_src = "dir_clang_tools" + "/src/"
dir_classify_files = dir_analyze_files + r"classify_files/"
dir_case_files = dir_analyze_files + r"case_files/"
dir_bf_files = dir_analyze_files + r"bf_files/"
dir_node_file = dir_src + "node.txt"
dir_git_json = dir_clang_tools + "/new_python/"+"gitdiff.json"

def create_dir(path):
    import os
    import shutil
    path = path.strip()
    path = path.rstrip("\\")
    isExist = os.path.exists(path)
    if isExist:
        shutil.rmtree(path)
    os.makedirs(path)

create_folder_list = list()
create_folder_list.append(dir_classify_files)
create_folder_list.append(dir_case_files)
create_folder_list.append(dir_bf_files)

for path in create_folder_list:
    create_dir(path)
