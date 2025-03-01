%{
	#include <stdio.h>
	#include <string.h>
	#include <math.h>
	#include "myanalyzer.tab.h"
	#include "cgen.h"
	int line_num = 1;
%}

IDENTIFIERS		 [a-zA-Z_][0-9a-zA-Z_]*
POSITIVE_INTEGER 0|([1-9][0-9]*)
POSITIVE_REAL    (({POSITIVE_INTEGER})?"."[0-9]*)([eE][+-]?{POSITIVE_INTEGER})?
_STRING_  		 \"(\\.|[^"\\])*\"

%x comment


%%

int	        {printf("Line %d: Found token INT: %s\n",line_num, yytext); return T_INT;}
real	    {printf("Line %d: Found token REAL: %s\n",line_num, yytext); return T_REAL;}
bool	    {printf("Line %d: Found token BOOL: %s\n",line_num, yytext); return T_BOOL;}
string	    {printf("Line %d: Found token STRING: %s\n",line_num, yytext); return T_STRING;}
true	    {printf("Line %d: Found token TRUE: %s\n",line_num, yytext); return T_TRUE;}
false	    {printf("Line %d: Found token FALSE: %s\n",line_num, yytext); return T_FALSE;}
if	    	{printf("Line %d: Found token IF: %s\n",line_num, yytext); return T_IF;}
then    	{printf("Line %d: Found token THEN: %s\n",line_num, yytext); return T_THEN;}
else    	{printf("Line %d: Found token ELSE: %s\n",line_num, yytext); return T_ELSE;}
fi    	    {printf("Line %d: Found token FI: %s\n",line_num, yytext); return T_FI;}
while  	    {printf("Line %d: Found token WHILE: %s\n",line_num, yytext); return T_WHILE;}
loop  	    {printf("Line %d: Found token LOOP: %s\n",line_num, yytext); return T_LOOP;}
pool  	    {printf("Line %d: Found token POOL: %s\n",line_num, yytext); return T_POOL;}
const  	    {printf("Line %d: Found token CONST: %s\n",line_num, yytext); return T_CONST;}
let         {printf("Line %d: Found token LET: %s\n",line_num, yytext); return T_LET;}
return 	    {printf("Line %d: Found token RETURN: %s\n",line_num, yytext); return T_RETURN;}
start  	    {printf("Line %d: Found token START: %s\n",line_num, yytext); return T_START;}

readString  {printf("Line %d: Found token readString: %s\n",line_num, yytext); return T_readString;}
readInt  	{printf("Line %d: Found token readInt: %s\n",line_num, yytext); return T_readInt;}
readReal  	{printf("Line %d: Found token readReal: %s\n",line_num, yytext); return T_readReal;}
writeString {printf("Line %d: Found token writeString: %s\n",line_num, yytext); return T_writeString;}
writeInt    {printf("Line %d: Found token writeInt: %s\n",line_num, yytext); return T_writeInt;}
writeReal   {printf("Line %d: Found token writeReal: %s\n",line_num, yytext); return T_writeReal;}


"+"	    {printf("Line %d: Found token arithmetic operator PLUS: %s\n",line_num, yytext); return O_PLUS;}
"-"	    {printf("Line %d: Found token arithmetic operator MINUS: %s\n",line_num, yytext); return O_MINUS;}
"*"	    {printf("Line %d: Found token arithmetic operator MUL: %s\n",line_num, yytext); return O_MUL;}
"/"	    {printf("Line %d: Found token arithmetic operator DIV: %s\n",line_num, yytext); return O_DIV;}
"%"	    {printf("Line %d: Found token arithmetic operator MOD: %s\n",line_num, yytext); return O_MOD;}

"="	    {printf("Line %d: Found token relative operator EQUAL: %s\n",line_num, yytext); return O_EQUAL;}
"!="    {printf("Line %d: Found token relative operator NOT_EQUAL: %s\n",line_num, yytext); return O_NEQ;}
"<"	    {printf("Line %d: Found token relative operator LESS: %s\n",line_num, yytext); return O_LESS;}
"<="    {printf("Line %d: Found token relative operator LESS_EQUAL: %s\n",line_num, yytext); return O_LEQ;}

and     {printf("Line %d: Found token logical operator AND: %s\n",line_num, yytext); return O_AND;}
or    	{printf("Line %d: Found token logical operator OR: %s\n",line_num, yytext); return O_OR;}
not     {printf("Line %d: Found token logical operator NOT: %s\n",line_num, yytext); return O_NOT;}

"<-"    {printf("Line %d: Found token operator ASSIGNMENT: %s\n",line_num, yytext); return O_ASS;}

";"	    {printf("Line %d: Found token delimiter SEMICOLON: %s\n",line_num, yytext); return D_SEM;} 
"("	    {printf("Line %d: Found token delimiter LEFT PARANTHESES: %s\n",line_num, yytext); return D_LPAR;} 
")"	    {printf("Line %d: Found token delimiter RIGHT PARANTHESES: %s\n",line_num, yytext); return D_RPAR;} 
","	    {printf("Line %d: Found token delimiter COMMA: %s\n",line_num, yytext); return D_COM;} 
"["	    {printf("Line %d: Found token delimiter LEFT SQUARE BRACKET: %s\n",line_num, yytext); return D_LSB;} 
"]"	    {printf("Line %d: Found token delimiter RIGHT SQUARE BRACKET: %s\n",line_num, yytext); return D_RSB;} 
"{"	    {printf("Line %d: Found token delimiter LEFT BRACKET: %s\n",line_num, yytext); return D_LB;} 
"}"	    {printf("Line %d: Found token delimiter RIGHT BRACKET: %s\n",line_num, yytext); return D_RB;} 
":"	    {printf("Line %d: Found token delimiter COLON: %s\n",line_num, yytext); return D_COL;}
"=>"    {printf("Line %d: Found token relative operator FUNCTION_DELIMITER: %s\n",line_num, yytext); return D_FUN;}

{IDENTIFIERS}         {printf("Line %d: Found IDENTIFIERS: %s\n",line_num, yytext); yylval.str = strdup(yytext); return TK_IDENT;  }
{POSITIVE_INTEGER}    {printf("Line %d: Found POSITIVE_INTEGER: %s\n",line_num, yytext); yylval.str = strdup(yytext); return TK_POSINT; }
{POSITIVE_REAL}       {printf("Line %d: Found POSITIVE_REAL: %s\n",line_num, yytext); yylval.str = strdup(yytext); return TK_POSREAL; }
{_STRING_}            {printf("Line %d: Found STRING: %s\n",line_num, yytext); yylval.str = strdup(yytext); return TK_STR; }

"--"[^\n]*  		    printf("Line %d: Line comment: %s\n", line_num, yytext);/* eat line comments */

"(*"                    { BEGIN(comment); printf("Comment started at Line: %d\n", line_num); }

<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*)\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+")"        { BEGIN(INITIAL); printf("Comment ended at line: %d\n", line_num); }

[ \r\t]		/* skip whitespace */

\n          ++line_num;
<<EOF>>		return EOF;
.			{ printf("Line %d Lexical Error: Unrecognized literal %s\n", line_num, yytext); }
