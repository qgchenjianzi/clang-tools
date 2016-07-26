/**
 * File : clangToolsMain.cpp
 * author: currychen
 * email: qgchenjianzi@foxmail.com
 */
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <dirent.h>
#include <time.h>
#include <vector>

using namespace std;

string file_format_m = ".m";
string file_format_mm = ".mm";

string file_prj_dir = ".prjDir";
string file_tools_dir = ".toolsDir";
string file_ignore_dir = ".ignore";

string dir_main_src ;
string dir_tool = "build/";
string tool_name = "rewritersample";

string nodeFile = "./node.txt";

time_t t_start,t_end;

int ignoreSize = 0;
vector<string> ignoreVec;

// 判断文件后缀
int isCodeFile(string fileName)
{
    size_t iPos = fileName.find_last_of(".");

    if(iPos == string::npos || iPos >= fileName.length())
        return 0;
    string fileType = fileName.substr(iPos,fileName.length()-1);
    if(strcmp(fileType.c_str(),file_format_m.c_str())==0 || strcmp(fileType.c_str(),file_format_mm.c_str())==0)
    {
        return 1;
    }
    return 0;
}

/**
 *  判断是否为文件夹
 *
 */
int is_dir(char *path)
{
    struct stat st;
    stat(path,&st);
    if(S_ISDIR(st.st_mode))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

bool isIgnoreFile(string strPrjDir,vector<string> &igVec)
{
    if(igVec.size() == ignoreSize)
    {
        return false;
    }
    else if(strPrjDir.empty())
        return true;
    for(int i = 0 ; i < igVec.size() ; i++)
    {
        //string prjDir = *iter;
        string prjDir = igVec[i];
        if(strPrjDir.compare(prjDir) == 0)
        {
            ignoreSize++;
            cout << "Ignore file :" << prjDir << endl;
            return true;
        }
    }
    return false;

}

//遍历项目文件夹
int traversePrj(const char *prjDir,const char *toolsDir)
{
    if(prjDir == NULL || toolsDir == NULL)
    {
        cout << "traversePrj error : The dir cannot be null" << endl;
        return -1;
    }
    string strPrjDir(prjDir);

    DIR *dPrj,*dTools;
    struct dirent *file;
    struct stat sb;
    if((dPrj=opendir(prjDir))==NULL)
    {
        cout << "The dir should not be scanned: "<< prjDir << endl;
        return -1;
    }

    if((dTools = opendir(toolsDir))==NULL)
    {
        cout << "error cannot open dir:"<<toolsDir << endl;
        return -1;
    }

    while((file = readdir(dPrj))!=NULL)
    {
        if(strcmp(file->d_name,".")==0 || strcmp(file->d_name,"..")==0)
            continue;
        char path[2048] = {0} ;
        strcat(path,prjDir);
        strcat(path,"/");
        strcat(path,file->d_name);

        cout << "======== Scan file ==========" << endl;
        cout << path << endl;
        if(isIgnoreFile(strPrjDir,ignoreVec))
        {
            break;
        }
        else if(is_dir(path))
        {
            traversePrj(path,toolsDir);
        }
        else if(isCodeFile(path))
        {
            string strToolsDir = toolsDir + tool_name;
            string handleFile = strPrjDir+"/"+file->d_name;
            string callTools = strToolsDir + " " + handleFile+" " + nodeFile;

            cout << "The shell is ===========>" << endl;
            cout << callTools << endl;
            cout << "======================================" << endl;

            cout << "\nfile name: " << file->d_name << endl;
            system(callTools.c_str());  
        }
        else
        {
            cout << "It is not a dir or OCfile" << endl;
            continue;
        }
        cout << "=============================" << endl;
    }
    closedir(dPrj);
    return 0;
}

void initVecDir(vector<string> &vec,string fileName)
{
    ifstream fin(fileName);
    string path;
    while(getline(fin,path))
    {
        if(path.back() == '/')
            path.erase(path.length()-1,1);
        vec.push_back(path);
    }
}

void readFileByLine(string fileName, char * dir,int size) 
{
    fstream outFile;
    outFile.open(fileName,ios::in);
    //配置文件遍历一行
    if(!outFile.eof())
    {
        outFile.getline(dir,size,'\n');
        cout << "dir = " << dir << endl;
    }
    outFile.close();
}
/**
 * 检查文件是否可以打开
 */
int isFolderAccess(char *dir)
{
    if(access(dir,F_OK)==0)
        return 0;
    return -1;
}

/**
 * 以命令行的形式读入项目路径和工具路径
 */
int getDir(char *dir,int size)
{
    cin.getline(dir,size);  
    return isFolderAccess(dir);
}

/**
 * 以文件配置的形式读入项目路径和工具路径
 */
int getDir(char *dir,int size,string fileName)
{
    ifstream readFile(fileName);
    if(!readFile.is_open())
    {
        cout << "No such file found,please create " << fileName << endl;
    }
    return isFolderAccess(dir);
}
/**
 * 多目录配置遍历 
 *
 */
void traverseAllPath(vector<string> &vec,string dir_tool)
{
    vector<string>::iterator iter;
    for(iter = vec.begin(); iter!=vec.end();++iter)
    {
        string prjDir = *iter;
        cout << "prjDir " << prjDir << endl;
        if(isIgnoreFile(prjDir,ignoreVec))
            continue;
        if(!prjDir.empty())
        {
            traversePrj(prjDir.c_str(),dir_tool.c_str());
        }
    }
}

void init()
{
    ofstream ofile;
    ofile.open(nodeFile,ios::out|ios::trunc);
    ofile.close();
}

int main(int argc , char *argv[])
{
    init();
    char toolsDir[2048];

    vector<string> prjVector;
    t_start = time(NULL);
    //readFileByLine(file_prj_dir,prjDir,sizeof(prjDir)); 
    initVecDir(prjVector,file_prj_dir);
    initVecDir(ignoreVec,file_ignore_dir);

    readFileByLine(file_tools_dir,toolsDir,sizeof(toolsDir)); 

    if(getDir(toolsDir,sizeof(toolsDir),file_tools_dir)!=0)
    {
        //system("clear");
        cout << toolsDir << " The clang tools dir cannot open!" << endl;
        cout << "Please input the rigit clang tools dir!" << endl;
        return 0;
    }

    // 对tool path进行处理 
    string strToolDir(toolsDir);
    if(strToolDir.back() == '/')
        dir_tool = strToolDir + dir_tool;
    else 
        dir_tool = strToolDir + "/" + dir_tool;
    ////////////////////////////////////////// 

    cout << "toolsDir = " << dir_tool << endl;
    traverseAllPath(prjVector,dir_tool);

    t_end = time(NULL);
    cout << "======================================================" << endl;
    cout << "Scan time is " << difftime(t_end,t_start) << "s" << endl;
    cout << "======================================================" << endl;
    return 0;
}
