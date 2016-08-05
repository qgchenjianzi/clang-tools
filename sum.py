
if __name__ == "__main__":
    import sys
    return_num = 0
    in_num = 0
    for line in open(sys.argv[1],"r").readlines():
        func_mes = line.split("!#!")
        if func_mes:
            func_name = func_mes[1]
            status = func_mes[3].strip().lstrip()
        if status == "return":
            return_num = return_num+1
        if status == "in":
            in_num = in_num+1
    print "return_num",return_num
    print "in_num",in_num

