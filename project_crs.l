%{
/*Including required header files*/
#include<stdio.h>

/*Including file verbatim created after yacc/bison command*/
#include "y.tab.h"

/*Variable to hold attribute values of generated tokens*/
extern int yylval;
int yylineno = 1;

%}

/*RULES*/

listItem_close  ^[<][/][lL][iI][>]
ordered_close  ^[<][/][oO][lL][>]
unordered_close ^[<][/][uU][lL][>]
listItem_open  ^[<][lL][iI][>]
unordered_open ^[<][uU][lL][>]
ordered_open  ^[<][oO][lL][>]

/*LEXEMES are categorized into :- */
/*1.  ordered_open - <ol> or <OL> or <Ol> or <oL> */
/*2.  ordered_close - </ol> or </OL> or </Ol> or </oL> */
/*3.  unordered_open - <ul> or <UL> or <Ul> or <uL> */
/*4.  unordered_close - </ul> or </UL> or </Ul> or </uL> */
/*5.  listItem_open - <li> or <LI> or <Li> or <lI> */
/*6.  listItem_close - </li> or </LI> or </Li> or </lI> */


/*Anything except the above mentioned, is treated as an -item.*/

%%

{unordered_close} {printf("\nIdentified token - </ul>\n"); return unordered_closeTag;}
{ordered_close} {printf("\nIdentified token - </ol>\n"); return ordered_closeTag;}
{listItem_close} {printf("\nIdentified token - </li>\n"); return list_closeTag;}
{listItem_open} {printf("\nIdentified token - <li>\n"); return list_openTag;}
{unordered_open} {printf("\nIdentified token - <ul>\n"); return unordered_openTag;}
{ordered_open} {printf("\nIdentified token - <ol>\n"); return ordered_openTag;}

.* {yylval = 1; printf("\nIdentified item - %s\n", yytext); return item;}
\n {++yylineno;}

%%

/*AUXILLIARY FUNCTION*/

int yywrap(){return 1;}

/*main() function in .y file*/