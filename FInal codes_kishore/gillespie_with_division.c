#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define IM1 2147483563
#define IM2 2147483399
#define AM (1.0/IM1)
#define IMM1 (IM1-1)
#define IA1 40014
#define IA2 40692
#define IQ1 53668
#define IQ2 52774
#define IR1 12211
#define IR2 3791
#define NTAB 32
#define NDIV (1+IMM1/NTAB)
#define EPS 1.2e-7
#define RNMX (1.0-EPS)

#define TMAX 20000
#define DOUBLINGTIME 4800

float ran2(long *idum);// function declaration for random number generation
float progression(float time, int conc[],int loop, FILE *output); //function for progression. basically, you give an array input and it modifies the array over time using a set of rules
float prod_rate(float a, float b, float c, float d);//function declaration for production rate
float rate(float a, int b, int c);//for other rates to make sure that the rates arezero in case of non-positive conc.


long id = -7432483288.0;

void main()
{
	int loop=0, i, j, k , factor = (TMAX/DOUBLINGTIME)+1, temp;
	for (loop=0; loop<250; loop++){
	int conc[9]={0,21,166,754,0,0,0,0,0};
	//int data[TMAX+DOUBLINGTIME][8] = {0};
	int *data = malloc(sizeof(int) * ((TMAX+DOUBLINGTIME)*9));
    for(i=0;i<TMAX+DOUBLINGTIME;i++){
       for ( j = 0; j < 9; ++j)
       {
       		data[i*9+j]=0;
       }
    }
	for(i=1; i<8; i++)
		data[i] = conc[i-1];
	char s[sizeof("hill_10000.txt")];
	sprintf(s, "hill_%d_%d_%d.txt",loop,conc[7],conc[8]);
	FILE *output;
	output = fopen(s,"w");
	float time =0;
	progression(time,conc,loop,output);


	
	/*FILE *input, *final;
	sprintf(s,"hill_%d_l.txt",loop);
	final = fopen(s,"w");
	char c[sizeof("hill_0_100.txt")];
	for (i=0; i<factor; i++)
	{
		
		sprintf(c,"hill_%d_%d.txt",loop,i);
		input = fopen(c,"r");
		for(j=i*DOUBLINGTIME+1; j<=factor*DOUBLINGTIME; j++)
		{
			fscanf(input, "%d", &data[8*j]);
			for(k=1; k<8; k++){
				fscanf(input, "%d", &temp);
				data[j*8+k] += temp;
			}
		}
		fclose(input);

	}
	for (i=0; i<factor*DOUBLINGTIME; i++){
		fprintf(final, "%d", data[i*8]);
		for(j=1; j<8; j++)
			fprintf(final, " %d",data[i*8+j]);
		fprintf(final, "\n");
	}
	fclose(final);*/
	}
}

//this is the function for division
float progression(float time, int conc[],int loop, FILE *output)	
{
	int i,j,k, count, dummy[9], z, temp;// define integer variables: conc[] for concentrations, i,j and k loop variables
	float prod[8], degrade[7], inter[6], rates[17], prob[17], sum_prob[17],  x, gal, fact, total_rate, hill[3],t, divider;//define float variables: parameters, rates and probabilities
	x=1.0;
	gal=x/100;
	FILE *parameters;
	parameters = fopen ("vent_para_div.txt", "r"); //open the parmeters file with read permissions
	for (i=0; i<8; i++)
		{fscanf (parameters, "%f", &prod[i]);}
	for (i=0; i<7; i++) //results change when this is set as 4
		{fscanf (parameters, "%f", &degrade[i]);}
	for(i=0; i<6; i++)
		{fscanf (parameters, "%f", &inter[i]);}
	fscanf(parameters, "%f", &fact);
	for (i=0; i<3; i++)
	{
		fscanf(parameters, "%f", &hill[i]);
	}
	fclose(parameters);
	id += loop;
	t=0;
	count = 1;// time recording variable
	while (t <=DOUBLINGTIME)
	{
		for (i = 0; i < 17; i++)
		{
			sum_prob[i] = 0;
		}
		float choice = ran2(&id);
		float t_inc = ran2(&id);
		//--------------------------defining the rates-------------------------
		//---------------------------------------------------------------------
		//production rates
		rates[0] = prod_rate(prod[0], prod[1], conc[2], hill[0])+ gal*fact;// gal1
		rates[1] = prod_rate(prod[2], prod[3], conc[2], hill[1]) + gal;// gal3
		rates[2] = prod[6];//gal 4
		rates[3] = prod[7]+ prod_rate(prod[4], prod[5], conc[2], hill[2]);// gal80
		//degradation rates
		for (i=4; i<11; i++)
			{rates [i] = rate(degrade[i-4],conc[i-4],1);}

		//protein reaction rates
		rates[11] = rate(inter[0],conc[0],conc[3]); //gal1 + gal80
		rates[12] = rate(inter[1],conc[4],1);
		rates[13] = rate(inter[2],conc[1],conc[3]);// gal3 + gal80
		rates[14] = rate(inter[3],conc[5],1);
		rates[15] = rate(inter[4],conc[2],conc[3]);// gal4 +gal80
		rates[16] = rate(inter[5],conc[6],1);
		//--------------------------------------------------------------------------

		//total rate

		total_rate = 0;
		for (i=0; i<17; i++)
			{total_rate += rates[i]; }
		
		//--------------------------------------------------------------------------

		//probabilities
		for (i = 0; i < 17; ++i)
		{
			prob[i] = rates[i]/total_rate;
		}
		
		for (i=0; i<17; i++)
		{
			for (j =0; j<=i; j++)
			{
				sum_prob[i] += prob[j];
			}
			
		}
			if (choice<= sum_prob[0])
				{conc[0] +=1;}
				
			else if (choice<=sum_prob[1])
				{conc[1] += 1;}
				
			else if (choice<=sum_prob[2])
				{conc[2] += 1;}
				
			else if (choice<=sum_prob[3])
				{conc[3] += 1;}
		//-----------------------------------------------------------------------------

		//degradation------------------------------------------------------------------		
			else if (choice<=sum_prob[4])
				{conc[0] -= 1;}
				
			else if (choice<=sum_prob[5])
				{conc[1] -= 1;}
				
			else if (choice<=sum_prob[6])
				{conc[2] -= 1;}
				
			else if (choice<=sum_prob[7])
				{conc[3] -=1;}
			else if (choice<=sum_prob[8])
				{conc[4] -= 1;}
				
			else if (choice<=sum_prob[9])
				{conc[5] -= 1;}
				
			else if (choice<=sum_prob[10])
				{conc[6] -= 1;}
				
		//--------------------------------------------------------------------------------

		//gal80 reaction------------------------------------------------------------------
			else if (choice<=sum_prob[11])
				{conc[0] -= 1;
				conc[3] -= 1;
				conc[4] += 1;}
				
			else if (choice<=sum_prob[12])
				{conc[0] += 1;
				conc[3] += 1;
				conc[4] -= 1;}
				
			else if (choice<=sum_prob[13])
				{conc[1] -= 1;
				conc[3] -= 1;
				conc[5] += 1;}
				
			else if (choice<=sum_prob[14])
				{conc[1] += 1;
				conc[3] += 1;
				conc[5] -= 1;}
				
			else if (choice<=sum_prob[15])
				{conc[2] -= 1;
				conc[3] -= 1;
				conc[6] += 1;}
				
			else
				{conc[2] += 1;
				conc[3] += 1;
				conc[6] -= 1;}

		//time += -1.0*log(t_inc)/total_rate;
		t += -1.0*log(t_inc)/total_rate;
		z = (int)(t);
		if (z >= count)
		{ 
			fprintf(output, "%d %d %d %d %d %d %d %d\n", (int)(time+t), conc[0], conc[1], conc[2], conc[3], conc[4], conc[5], conc[6]);
			count += 1;
		}
		
	}
	time +=t;
	for(i=0; i<7; i++)
	{
		divider = ran2(&id);
		temp = (int)(divider*conc[i]);
		dummy[i] = conc[i] -temp;
		conc[i] = temp;
	}
	dummy[7] = (int)(time/4800);
	dummy[8] = conc[7];
	char s[sizeof("hill_10000_100.txt")];
	sprintf(s, "hill_%d_%d_%d.txt",loop,dummy[7],dummy[8]);
	FILE *conc_file;
	conc_file = fopen(s,"w");
	for(i=0; i<9; i++)
		fprintf(conc_file, "%d ", dummy[i]);
	fclose(conc_file);
	//printf("%f\n", t);
	if(time<TMAX) progression (time, conc, loop,output);
	fclose(output);
	conc_file = fopen(s,"r");
	for(i=0; i<9; i++)
		fscanf(conc_file, "%d", &conc[i]);
	fclose(conc_file);
	output = fopen(s,"w");
	if(time<TMAX) progression (time, conc, loop,output);
}


float prod_rate(float a, float b, float c, float d)
{
	float rate, power;
	power = pow(c,b);
	rate = a * (power/(pow(d,b) + power));
	if (c >0)
	{return rate;}
	else
	{return 0;}
}

float rate(float a, int b, int c)
{
	float r = a*b*c;
	if (b<=0 || c <=0)
		{return 0;}
	else
		{return r;}
}



float ran2(long *idum)
{
	int j;
	long k;
	static long idum2=123456789;
	static long iy=0;
	static long iv[NTAB];
	float temp;

	if (*idum <= 0) {
		if (-(*idum) < 1) *idum=1;
		else *idum = -(*idum);
		idum2=(*idum);
		for (j=NTAB+7;j>=0;j--) {
			k=(*idum)/IQ1;
			*idum=IA1*(*idum-k*IQ1)-k*IR1;
			if (*idum < 0) *idum += IM1;
			if (j < NTAB) iv[j] = *idum;
		}
		iy=iv[0];
	}
	k=(*idum)/IQ1;
	*idum=IA1*(*idum-k*IQ1)-k*IR1;
	if (*idum < 0) *idum += IM1;
	k=idum2/IQ2;
	idum2=IA2*(idum2-k*IQ2)-k*IR2;
	if (idum2 < 0) idum2 += IM2;
	j=iy/NDIV;
	iy=iv[j]-idum2;
	iv[j] = *idum;
	if (iy < 1) iy += IMM1;
	if ((temp=AM*iy) > RNMX) return RNMX;
	else return temp;
}
#undef IM1
#undef IM2
#undef AM
#undef IMM1
#undef IA1
#undef IA2
#undef IQ1
#undef IQ2
#undef IR1
#undef IR2
#undef NTAB
#undef NDIV
#undef EPS
#undef RNMX

