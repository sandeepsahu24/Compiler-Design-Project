
%{
/*Including required header files*/
#include<stdio.h>

/*Global variables used to indicate validity of the input HTML file*/
int flag=0;

/*Function declarations for functions of lex and yacc used in the file*/
void yyerror(char const *msg);
int yyparse();
int yylex();

/*Variable to keep tally of line no.*/
extern int yylineno;

/*LIST OF TOKENS :-
		1. unordered_openTag = <ul>
		2. ordered_openTag = <ol>
		3. unordered_closeTag = </ul>
		4. ordered_closeTag = </ol>
		5. list_openTag = <li>
		6. list_closeTag = </li>
		7. item - any other remaining token except the valid html list tags
*/
%}

//%define parse.error verbose
%error-verbose

%token unordered_openTag ordered_openTag unordered_closeTag ordered_closeTag list_openTag list_closeTag item

%left unordered_openTag unordered_closeTag ordered_openTag ordered_closeTag
%left list_openTag list_closeTag
%left item

%%


/*S - starting NON-TERMINAL*/

S:
/*Rule to accept an HTML list*/
S LIST {printf("\nS -> S LIST\n");} | 

/*Rule to accept an item or a list item*/
S ITEM_LIST {printf("\nS -> S ITEM_LIST\n");} | 

/*Rule to accept an empty file (epsilon)*/
EMPTY {printf("\nS -> EMPTY\n");}
;

LIST :
/*Rule to accept an un-ordered list*/
UNORDERED_LIST {printf("\nLIST -> UNORDERED_LIST\n");} | 

/*Rule to accept an ordered list*/
ORDERED_LIST {printf("\nLIST -> ORDERED_LIST\n");}
;

UNORDERED_LIST:
/*Rule to accept input of the form - <ul> S </ul>*/
unordered_openTag S unordered_closeTag 
{printf("\nUNORDERED_LIST -> <ul> S </ul>\n");}
;

ORDERED_LIST:
/*Rule to accept input of the form - <ol> S </ol>*/
ordered_openTag S ordered_closeTag
{printf("\nORDERED_LIST -> <ol> S </ol>\n");} 
;

ITEM_LIST:
/*Rule to accept an item / list item*/
ITEM {printf("\nITEM_LIST -> ITEM\n");} | 

/*Rule to accept multiple combinations of items, list items, lists*/
ITEM ITEM_LIST {printf("\nITEM_LIST -> ITEM ITEM_LIST\n");}
;

ITEM :
/*Rule to accept a list item*/
list_openTag S CLOSE_LIST {printf("\nITEM -> <li> S CLOSE_LIST\n");} | 

/*Rule to accept an item that is neither an ordered or un-ordered list nor a list item*/
item {printf("\nITEM -> item\n");}
;

CLOSE_LIST :
/*Rule to decide whether <li> tag will be closed or open*/

/*Rule to accept - <li> S </li>*/
list_closeTag {printf("\nCLOSE_LIST -> </li>\n");} |

/*Rule to accept - <li> S*/
{printf("\nCLOSE_LIST -> epsilon\n");}
;

EMPTY:
/*Rule to accept epsilon*/
{printf("\nEMPTY -> epsilon\n");}
;


%%

int main(){
	/*auxilliary main function to parse the html file*/

	extern FILE *yyin;

	/*opening the html text file to be parsed*/
    yyin = fopen("html.txt","r");

	/*calling yyparse() function to parse the entered file*/
	yyparse();

	/*if flag global variable after parsing = 0, means no error, html file VALID*/
	if(flag==0){
		printf("\nThe Entered HTML Code is VALID.\n");
	}
	return 0;
}

void yyerror(char const *msg){
	/*yyerror() function - called in case an error is encountered while parsing the html file*/

	printf("\nERROR ENCOUNTERED WHILE PARSING! Line no. - %d , error - %s\n", yylineno, msg);
	printf("\nThe Entered HTML code is INVALID.\n");

	/*set the global variable flag = 1 to indicate error in parsing of html file*/
	flag=1;
}