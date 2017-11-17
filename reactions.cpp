#include <iostream>
#include <cstdlib>
#include <string>

using namespace std;

class Reactant 
{
	int number;
public:
	Reactant();
	Reactant(int init) : number(init){}
	friend class Reaction;
};

class Reaction 
{
	Reactant r[3];
	char type;
	int coefficients[3];

public:
	Reaction(){}
	Reaction(Reactant r)
};