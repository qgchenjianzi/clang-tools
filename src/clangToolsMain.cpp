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
    if((dPrj=opendir(prjDir))==NULL)
    {
        cout << "error cannot open dir: "<< prjDir << endl;
        return -1;
    }
    //if(access(toolsDir,F_OK)!=0)
    if((dTools = opendir(toolsDir))==NULL)
    {
        cout << "error cannot open dir: "<<toolsDir << endl;
        return -1;
    }
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

            cout << "the cmd is " << callTools << endl;
            cout << "file name: " << file->d_name << endl;
            system(callTools.c_str());  
        }
    }
    closedir(dPrj);
    return 0;
}
void initStr()
{

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
        cout << "Error opening file!" << endl;
    }
    while(!readFile.eof())
        readFile.getline(dir,size); 
    return isFolderAccess(dir);
}

int main(int argc , char *argv[])
{
    char prjDir[100];
    char toolsDir[100];

    
    cout << "The tools dir is :" << endl; 
    if(getDir(toolsDir,sizeof(toolsDir),file_tools_dir)!=0)
    {
        system("clear");
        cout << prjDir << " The project dir cannot open!" << endl;
        cout << "Please input the rigit project dir!" << endl;
        return 0;
    }

    cout << "The tools dir is :" << endl; 
    if(getDir(toolsDir,sizeof(toolsDir),file_tools_dir)!=0)
    {
        system("clear");
        cout << toolsDir << " The clang tools dir cannot open!" << endl;
        cout << "Please input the rigit clang tools dir!" << endl;
        return 0;
    }



    string strPrjDir(prjDir);
    size_t iPos = strPrjDir.rfind('/');
    string prjName = strPrjDir.substr(iPos+1,strPrjDir.length()-1);

    if(strPrjDir.back() == '/')
    dir_main_src = strPrjDir + prjName;
    else
    dir_main_src = strPrjDir + "/" + prjName;


    string strToolDir(toolsDir);
    if(strToolDir.back() == '/')
    dir_tool = strToolDir + dir_tool;
    else 
    dir_tool = strToolDir + "/" + dir_tool;

    traversePrj(dir_main_src.c_str(),dir_tool.c_str());
}
