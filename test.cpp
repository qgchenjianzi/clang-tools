#include <iostream>
#include <regex>
#include <string>
#include <iterator>

using namespace std;
int main()
{
    string s = "AAAAA; return a+b; return c;";
    regex reg("return(\\s+([^;]+))?;");
    //cout << regex_replace(s,reg,"{ $0 }") << endl;
    string str(regex_replace(s,reg,"{$0}"));
    cout << str << endl;
    return 0;
}
