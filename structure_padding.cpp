#pragma pack(2)


#include <iostream>
#include <cstdlib>
#include <cstdio>

using namespace std;


struct ccc
{
	char a;	char b;	char c;	
};

struct ccs
{
	char a; char b; short int c;
};

struct csc
{
	char a; short int b; char c;
};

struct scc
{
	short int a; char b; char c;
};

struct cscc
{
	char a; short int b; char c; char d;
};

struct ccsc
{
	char a; char b; short int c; char d;
};

struct csi
{
	char a; short int b; int c;
};

struct ccccc
{
	char a; char b; char c; int d; char e;
};
int main()
{
	cout<< sizeof(ccc)<<endl;
	cout<< sizeof(ccs)<<endl;
	cout<< sizeof(csc)<<endl;
	cout<< sizeof(scc)<<endl;
	cout<< sizeof(cscc)<<endl;
	cout<< sizeof(ccsc)<<endl;
	cout<< sizeof(csi)<<endl;
	cout<< sizeof(ccccc)<<endl;

	
	return 0;
}