data mydata1;
input id gender$ income job$;
datalines;
1 Female 20000 teacher
2 Male 18000 cashier
;
run;
/*A procedure to import data*/
/*It is usually the excel file*/
proc import datafile= "\\tsclient\C\Users\Pooja Singhal\Documents\Study\SAS\Product.xlsx"
out=product_data /*Name of the output*/
DBMS=xlsx /*type of dataset you are importing*/
replace; /*overwrite on an existing dataset*/
getnames=yes; /*name of the attributes*/
run;

/*the third method is importing data using infile */
data Unemployment;
infile "\\tsclient\C\Users\Pooja Singhal\Documents\Study\SAS\Unemployment.csv"
delimiter=","
missover dsd /*allowing for missing if you have 10,,20 it reads as 10 . 20 */
/*obs=100*/
firstobs=2;
input id item$ price;
run;

/*data in work library are deletd once you end your session with closing SASA
you need to create a library to store your SAS data */

/*creating library */
libname workshop "\\tsclient\C\Users\Pooja Singhal\Documents\Study\SAS";
/*saving in the library*/
data workshop.product_data; /*the name of the library comes before the name */
set product_data;
run;

/*make sure you have created your own libary
you have saved your product data there */

/*sorting our data*/
proc sort data=product_data;
by item;
run;

/*sorting by multiple variables*/
proc sort data=product_data;
by item descending price;
run;

/*printing some observations*/
proc print data=product_data;
/* or proc print data=product_data ( firstobs=3 obs=10);*/
Var price item;
where price>60;
/*options firstobs=3 obs=10; */
run;

/*Exercise ***/
/*Exercise 1: Import dataset salary, print our the employees that get the 5 top salary
guidelines: you need to sort data and use proc print */
/*answers*/
proc import datafile= "\\tsclient\C\Users\Pooja Singhal\Documents\Study\SAS\Salary.xlsx"
out=Salary
DBMS=xlsx /*type of dataset you are importing*/
replace; /*overwrite on an existing dataset*/
getnames=yes; /*name of the attributes*/
run;

proc sort data=Salary;
by descending Salary;
run;

data workshop.Salary; /*the name of the library comes before the name */
set Salary;
run;

proc print data=Salary (firstobs=1 obs=5);
/* or proc print data=product_data ( firstobs=3 obs=10);*/
Var Name Salary;
run;

/*reading data, adding a new variable*/
data salary2; /*output*/
set Salary; /*input*/
Dept_new=substr(Dept, 1,2); /*name of the string variable, the starting point, the length*/
run;

/*operation on variables*/
data salary3;
set salary2;
income=salary+bounes;
annual_income=12*salary+12*bounes;
run;

data salary4;
set salary;
log_exp=log(Experience);
run;

/*adding variables: Imagine you need a binary variable instead of a categorical variable*/
data salary5;
set salary2;
Female=0;
if gender="F" then female=1;
run;

/*each variable has a label and a name*/
/*you should use*/

/*changing the name at the time of input*/

data mynew;
set product_data (rename=(item=p));
run;

/*change the name at the time of output*/
data mynew(rename=(item=newitem));
  set product_data;
  k=substr(item,2); /*during data procedure u can use the original name*/
run;

/*combining*/

data newproducts;
input id item$ price;
datalines;
21 bag 70
22 shirt 80
;
run;

/*combining newproducts with product_data1 */
data new;
 set newproducts product_data;
run;


/*merging 2 datasets,
The datasets that are going to be merged should be sorted*/

data otherinfo;
input id inventory;
datalines;
1 12
2 17
9 19

;
run;

proc sort data=otherinfo;
by id;
run;

proc sort data=product_data;
by id;
run;

data complete;
merge product_data otherinfo;
by id;
run;


/*********************Descriptive Statistics************/
/*descriptive statistic of a variable*/
/*proc means*/
/*proc freq*/
/*proc plot*/
/*proc univariate*/
/*proc tabulate*/

proc means data=salary;
run;

/*selecting some variables*/
proc means data=salary;
var salary;
run;

/*proc means, advanced*/
proc means data=salary /*sum*/;
var salary bounes;
where dept='IT';
run;


proc means data=salary;
class dept gender;
var salary bounes;
run;

proc means data=salary;
class gender dept;
var salary bounes;
run;

/*reporting descriptive statistic in tables*/
/*frequency*/
proc freq data=salary;
table gender;
run;

/*having separate tables*/
proc freq data=salary;
table gender dept;
run;

/*as a more informative table*/
proc freq data=salary;
table gender*dept ; /*University*/
run;

proc freq data=salary;
table gender*dept*University ;
run;

/*now we can just show the percentages*/
proc freq data=salary;
table gender* dept/nocol norow nofreq;
run;

proc freq data=salary;
table gender*dept;
where salary>5000;
run;

/*use proc univariate to get a more detail descriptive statistic*/
proc univariate data=salary;
var salary;
run;

/*proc tabulate : more nice table for reporting*/
proc tabulate data = salary; 
class gender;
var salary bounes;
table gender*salary gender*bounes;
run;

proc tabulate data=salary;
class gender;
var salary bounes;
table gender*(salary bounes), MAX;
run;

proc tabulate data = salary;
class gender;
var salary bounes;
table gender, (salary bounes)*sum;
run;

proc tabulate data = salary;
class gender dept;
var salary bounes;
table gender*dept, (salary bounes)*sum;
run;

proc tabulate data = salary;
class gender dept;
var salary bounes;
table (bounes salary)*sum, dept*gender;
run;


/*if you want to create another dataset in which you save the sum of a variable*/
proc summary data=salary;
class gender;
var Experience;
output out=my1 /*mean*/;
run;

proc summary data=salary;
class gender;
var Experience;
output out=my1 mean= /**/;
run;




proc plot data =salary;
plot salary*experience;
run;

/*changing symbols*/
proc plot data =salary;
plot salary*experience='*';
run;

/*two separtae plots*/
proc sort data =salary;
by gender;
run;


/*exercise */
/*In Dataset salary, what is the descriptive statistic of the variable experience*/

proc means data=salary;
var experience;
run;


/*What is the decsriptive statistic of the variable income for employees whose GPA is greater than 3.5?*/
proc freq data=salary;
table salary*bounes;
where GPA>3.5;
run;

proc means data=salary;
var bounes;
where GPA>3.5;
run;

/*what is the average of experience of females in dept HR?*/

proc means data=salary mean;
var experience;
where gender='F' and dept='HR';
run;

/*Report a table using proc tabulate in which you can indentify the mean of income and Experience
for males and females from different universities*/

proc tabulate data = salary3; 
class university gender;
var income experience;
table (income experience)* mean, university*gender;
run;



proc univariate data=salary;
var salary;
histogram/normal kernel;
RUN;

/*using the class variable to get more information*/
proc univariate data=salary;
class gender;
VAR salary;
RUN;

proc plot data=salary;
plot salary*experience;
run;

proc plot data=salary;
plot salary*experience='*';
run;


/****************Regression***************/
/*open the library where dataset elemapi is stored**/
/*copy and save the dataset into the work library*/

libname workshop "\\tsclient\C\Users\Pooja Singhal\Documents\Study\SAS";

/*before starting regression, you need to take a look at the descriptive study*/
proc means data=elemapi;
var api00 acs_k3 meals full;
run;

proc means data=elemapi n nmiss;
var api00 acs_k3 meals full;
run;

proc univariate data=elemapi;
var acs _k3;
histogram / cfill=gray normal kernel midpoints=100 to 1500 by 100;
run;


/*******************Correlation******************/

proc corr data=elemapi;
var api00 meals;
run;

/*try to get a sense of the correlation among these variables before regression*/
proc corr data=elemapi;
var api00 acs_k3 meals full;
run;

proc reg data=elemapi;
model api00 = acs_k3 meals full;
run;

proc logistic data=binary descending;
model admit=gre gpa rank;
run;

