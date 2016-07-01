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


using namespace std;

string file_format_m = ".m";
string file_format_mm = ".mm";

string file_prj_dir = ".prjDir";
string file_tools_dir = ".toolsDir";

string dir_main_src ;
string dir_tool = "build/";
string tool_name = "rewritersample";


// 判断文件后缀
int isCodeFile(string fileName)
{
    size_t iPos = fileName.find_last_of(".");
    if(iPos <= 0)
        return 0;
    string fileType = fileName.substr(iPos,fileName.length()-1);
    if(strcmp(fileType.c_str(),file_format_m.c_str())==0 || strcmp(fileType.c_str(),file_format_mm.c_str())==0)
    {
        return 1;
    }
    return 0;
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
    //if(access(prjDir,F_OK)!=0)
    cout << "prjDir open" << endl;
    if((dPrj=opendir(prjDir))==NULL)
    {
        cout << "error cannot open dir: "<< prjDir << endl;
        return -1;
    }

    cout << "toolsDir open" << endl;
    //if(access(toolsDir,F_OK)!=0)
    if((dTools = opendir(toolsDir))==NULL)
    {
        cout << "error cannot open dir: "<<toolsDir << endl;
        return -1;
    }

    cout << "traversePrj" << endl;
    while((file = readdir(dPrj))!=NULL)
    {
        if(strcmp(file->d_name,".")==0 || strcmp(file->d_name,"..")==0 )
            continue;
        //else if (stat(file->d_name,&sb)==0 && S_ISREG(sb.st_mode) && isCodeFile(file->d_name)==1 ) 
        if(stat(file->d_name,&sb)>=0 && S_ISDIR(sb.st_mode)) 
        {
            cout << "scan folder name: " << file->d_name << endl;
            traversePrj(file->d_name,toolsDir);
        }
        else if(isCodeFile(file->d_name))
        {
            string strToolsDir = toolsDir + tool_name;
            string handleFile = strPrjDir+"/"+file->d_name;
            string callTools = strToolsDir + " " + handleFile;

            cout << "the shell is " << endl;
            cout << callTools << endl;

            cout << "\nfile name: " << file->d_name << endl;
            system(callTools.c_str());  
        }
    }
    closedir(dPrj);
    return 0;
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

int main(int argc , char *argv[])
{
    char prjDir[1024];
    char toolsDir[1024];

    readFileByLine(file_prj_dir,prjDir,sizeof(prjDir)); 
    readFileByLine(file_tools_dir,toolsDir,sizeof(toolsDir)); 

    if(getDir(toolsDir,sizeof(toolsDir),file_tools_dir)!=0)
    {
        //system("clear");
        cout << toolsDir << " The clang tools dir cannot open!" << endl;
        cout << "Please input the rigit clang tools dir!" << endl;
        return 0;
    }
    
       string strPrjDir(prjDir);
    /*   size_t iPos = strPrjDir.rfind('/');
       string prjName = strPrjDir.substr(iPos+1,strPrjDir.length()-1);

       if(strPrjDir.back() == '/')
       dir_main_src = strPrjDir + prjName;
       else
       dir_main_src = strPrjDir + "/" + prjName;
    */
    string strToolDir(toolsDir);
    if(strToolDir.back() == '/')
        dir_tool = strToolDir + dir_tool;
    else 
        dir_tool = strToolDir + "/" + dir_tool;

    traversePrj(strPrjDir.c_str(),dir_tool.c_str());
    //traversePrj(prjDir,dir_tool.c_str());
}
