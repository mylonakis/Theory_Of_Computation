%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "cgen.h"

  extern int yylex(void);
  extern int line_num;

  #define myFile "correct2.c"
  FILE *fl;

  int flag = 1;
%}

%union
{
  char* str;
}

%define parse.trace
%debug

%token <str> TK_IDENT
%token <str> TK_POSINT 
%token <str> TK_POSREAL 
%token <str> TK_STR

%token T_INT
%token T_REAL
%token T_BOOL
%token T_STRING
%token T_TRUE
%token T_FALSE
%token T_IF
%token T_THEN
%token T_ELSE
%token T_FI
%token T_WHILE
%token T_LOOP
%token T_POOL
%token T_CONST
%token T_LET
%token T_RETURN
%token TRETURN
%token T_START

%token T_readString
%token T_readInt
%token T_readReal
%token T_writeString
%token T_writeInt
%token T_writeReal

%token O_PLUS
%token O_MINUS
%token O_MUL
%token O_DIV
%token O_MOD
%token O_EQUAL
%token O_NEQ
%token O_LESS
%token O_LEQ
%token O_AND
%token O_OR
%token O_NOT
%token O_ASS

%token D_SEM
%token D_LPAR
%token D_RPAR
%token D_COM
%token D_LSB
%token D_RSB
%token D_LB
%token D_RB
%token D_COL
%token D_FUN

%type <str> Program
%type <str> mainProgram
%type <str> declSection

/*=== For DataTypes and Variables  ===*/
%type <str> dataTypes
%type <str> dataDecl
%type <str> varDecl
%type <str> constDecl
%type <str> varsSection
%type <str> varsSection1
%type <str> constSection
%type <str> constSection1

/*=== For User Functions === */
%type <str> userFunc
%type <str> paramDecl
%type <str> returnType
%type <str> funcBody
%type <str> callFunc
%type <str> inputFunc

%type <str> expr

/*=== For Commands ===*/
%type <str> Commands
%type <str> assignmentCommand
%type <str> returnCommand
%type <str> commitedFunc
%type <str> if_command
%type <str> while_command
%type <str> possible_cmd
%type <str> possible_cmd1


%left  O_LESS O_LEQ O_EQUAL O_NEQ 
%left  O_AND O_OR
%left  OPLUS OMINUS
%left  O_PLUS O_MINUS
%left  O_MUL O_DIV O_MOD

%right sPLUS
%right sMINUS
%right O_NOT

%start input

%%
/*==================== Final Program and Files  ==================== */
input: 
%empty 
{ 
  if (line_num == 1 && flag){
    printf("#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include \"teaclib.h\"\n\n");
    fl = fopen(myFile, "a");
    fprintf(fl,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include \"teaclib.h\"\n\n");
    fclose(fl);
    flag = 0;
  }
}
| input declSection
{
  if (line_num == 1 && flag){
    printf("#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include \"teaclib.h\"\n\n");
    fl = fopen(myFile, "a");
    fprintf(fl,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include \"teaclib.h\"\n\n");
    fclose(fl);
    flag = 0;
  }

  if (yyerror_count == 0){
    printf("Expression evaluates to:\n%s\n\n", $2);
    fl = fopen(myFile, "a");
    fprintf(fl,"%s\n", $2);
    fclose(fl);
  }
}
| input mainProgram
{ 
  if (line_num == 1 && flag){
    printf("#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include \"teaclib.h\"\n\n");
    fl = fopen(myFile, "a");
    fprintf(fl,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include \"teaclib.h\"\n\n");
    fclose(fl);
    flag = 0;
  }

  if (yyerror_count == 0){
    printf("Expression evaluates to:\n%s\n\n", $2);
    fl = fopen(myFile, "a");
    fprintf(fl,"%s\n", $2);
    fclose(fl);
  }
}
;

declSection:
  dataDecl { $$ = $1; }
| userFunc { $$ = $1; }
;

mainProgram: 
  T_CONST T_START O_ASS D_LPAR D_RPAR D_COL T_INT D_FUN D_LB Program D_RB { $$ = template("\n\nint main(){\n%s\n}", $10);}
;

Program:
  Commands               { $$ = $1; }
| Commands Program       { $$ = template("%s\n%s", $1, $2); }
| dataDecl               { $$ = $1; }
| dataDecl Program       { $$ = template("%s\n%s", $1, $2); }
| callFunc D_SEM         { $$ = template("%s;", $1);}
| callFunc D_SEM Program { $$ = template("%s\n%s", $1, $3); }
;

/*==================== Data Types and Variables  ==================== */
dataDecl:
  varDecl D_SEM   { $$ = $1; }
| constDecl D_SEM { $$ = $1; }
;

varDecl: 
  T_LET varsSection D_COL dataTypes             { $$ = template("%s %s;", $4, $2);}
| T_LET varsSection D_COL D_LSB D_RSB dataTypes { $$ = template("%s* %s;", $6, $2);}
| T_LET varsSection1 D_COL T_STRING             { $$ = template("char %s;", $2);}
;

varsSection:
  TK_IDENT                                                      { $$ = $1; }
| TK_IDENT D_COM varsSection                                    { $$ = template("%s, %s", $1, $3); }
| TK_IDENT O_ASS expr                                           { $$ = template("%s = %s", $1, $3); }
| TK_IDENT O_ASS expr D_COM varsSection                         { $$ = template("%s = %s, %s", $1, $3, $5); }
| TK_IDENT D_LSB TK_POSINT D_RSB                                { $$ = template("%s[%s]", $1, $3); }
| TK_IDENT D_LSB TK_POSINT D_RSB D_COM varsSection              { $$ = template("%s[%s], %s", $1, $3, $6); }
;

varsSection1:
  TK_IDENT D_LSB TK_POSINT D_RSB O_ASS TK_STR                    { $$ = template("%s[%s] = %s", $1, $3, $6); }
| TK_IDENT D_LSB TK_POSINT D_RSB O_ASS TK_STR D_COM varsSection1 { $$ = template("%s[%s] = %s, %s", $1, $3, $6, $8); }

dataTypes:
  T_INT    { $$ = template("int"); }
| T_REAL   { $$ = template("double"); }
| T_BOOL   { $$ = template("int"); }
| T_STRING { $$ = template("char"); }
;

constDecl: 
  T_CONST constSection D_COL dataTypes  { $$ = template("const %s %s;", $4, $2); }
| T_CONST constSection1 D_COL T_STRING  { $$ = template("const char %s;", $2); }
;

constSection:
  TK_IDENT O_ASS expr                    { $$ = template("%s = %s", $1, $3); }
| TK_IDENT O_ASS expr D_COM constSection { $$ = template("%s = %s, %s", $1, $3, $5); }

constSection1:
  TK_IDENT D_LSB TK_POSINT D_RSB O_ASS TK_STR                     { $$ = template("%s[%s] = %s", $1, $3, $6); }
| TK_IDENT D_LSB TK_POSINT D_RSB O_ASS TK_STR D_COM constSection1 { $$ = template("%s[%s] = %s, %s", $1, $3, $6, $8); }

/*==================== User Functions ==================== */
userFunc:
T_CONST TK_IDENT O_ASS D_LPAR paramDecl D_RPAR returnType D_FUN D_LB funcBody D_RB D_SEM                       
{ $$ = template("\n\n%s %s(%s){\n%s\n}", $7, $2, $5, $10); }
;

paramDecl:
%empty                                     { $$ = template("");}
| TK_IDENT D_COL dataTypes                 { $$ = template("%s %s", $3, $1);}
| TK_IDENT D_COL dataTypes D_COM paramDecl { $$ = template("%s %s, %s", $3, $1, $5);}
;

returnType:
%empty                       { $$ = template("void");}
|D_COL dataTypes             { $$ = $2;}
|D_COL D_LSB D_RSB dataTypes { $$ = template("%s*", $4);}
;

funcBody:  
  Commands          { $$ = $1; }
| Commands funcBody { $$ = template("%s\n%s", $1, $2); }
| dataDecl          { $$ = $1; }
| dataDecl funcBody { $$ = template("%s\n%s", $1, $2); }
;

callFunc: TK_IDENT D_LPAR inputFunc D_RPAR { $$ = template("%s(%s);", $1, $3); }
;

inputFunc:
%empty                 { $$ = template("");}
| expr                 { $$ =  $1; }
| expr D_COM inputFunc { $$ = template("%s, %s", $1, $3);}
;

/*==================== TeaC Expressions  ==================== */
expr:
  TK_IDENT             { $$ = $1; }
| TK_POSINT            { $$ = $1; }
| TK_POSREAL           { $$ = $1; }
| T_TRUE               { $$ = template("%d", 1); }
| T_FALSE              { $$ = template("%d", 0); }
| D_LPAR expr D_RPAR   { $$ = template("(%s)", $2); }
| O_PLUS expr %prec sPLUS   { $$ = template("+(%s)", $2);  }
| O_MINUS expr %prec sMINUS  { $$ = template("-(%s)", $2);  }
| expr O_PLUS  expr %prec OPLUS   { $$ = template("%s + %s", $1, $3);  }
| expr O_MINUS expr %prec OMINUS  { $$ = template("%s - %s", $1, $3);  }
| expr O_MUL   expr    { $$ = template("%s * %s", $1, $3);  }
| expr O_DIV   expr    { $$ = template("%s / %s", $1, $3);  }
| expr O_MOD   expr    { $$ = template("%s %% %s", $1, $3); }
| expr O_EQUAL expr    { $$ = template("%s == %s", $1, $3); }
| expr O_NEQ   expr    { $$ = template("%s != %s", $1, $3); }
| expr O_LESS  expr    { $$ = template("%s < %s", $1, $3);  }
| expr O_LEQ   expr    { $$ = template("%s <= %s", $1, $3); }
| expr O_AND   expr    { $$ = template("%s && %s", $1, $3);}
| expr O_OR    expr    { $$ = template("%s || %s", $1, $3); }
|      O_NOT   expr    { $$ = template("!(%s)", $2);       }
| TK_IDENT D_LPAR inputFunc D_RPAR { $$ = template("%s(%s)", $1, $3); }
;

/*==================== Commands  ==================== */

Commands:
  assignmentCommand    D_SEM { $$ = template("%s;",$1); }
| returnCommand        D_SEM { $$ = template("%s;",$1); } 
| commitedFunc         D_SEM { $$ = template("%s;",$1); }
| if_command                 { $$ = template("%s\n}", $1); }
| while_command              { $$ = template("%s\n}", $1); }
;

assignmentCommand: 
  TK_IDENT O_ASS expr                       { $$ = template("%s = %s", $1, $3); }
| TK_IDENT O_ASS TK_STR                     { $$ = template("%s = %s", $1, $3); }
| TK_IDENT D_LSB TK_POSINT D_RSB O_ASS expr { $$ = template("%s[%s] = %s", $1, $3, $6); }
;

returnCommand:
  T_RETURN expr   { $$ = template("return %s", $2); }
| T_RETURN TK_STR { $$ = template("return %s", $2); }
;

commitedFunc:
  TK_IDENT O_ASS T_readString D_LPAR D_RPAR { $$ = template("%s = fgets()", $1); }
| TK_IDENT O_ASS T_readInt D_LPAR D_RPAR    { $$ = template("%s = atoi(readString())",$1); }
| TK_IDENT O_ASS T_readReal D_LPAR D_RPAR   { $$ = template("%s = atof(readString())", $1); }
| T_writeString D_LPAR TK_IDENT D_RPAR      { $$ = template("printf(\"%%s\", %s)", $3); }
| T_writeString D_LPAR TK_STR D_RPAR        { $$ = template("printf(%s)", $3); }
| T_writeInt D_LPAR TK_IDENT D_RPAR         { $$ = template("printf(\"%%d\", %s)", $3); }
| T_writeReal D_LPAR TK_IDENT D_RPAR        { $$ = template("printf(\"%%g\", %s)", $3); }
;

if_command: T_IF expr T_THEN possible_cmd T_FI D_SEM { $$ = template( "if(%s)\n{\n%s", $2, $4); }
;

while_command: T_WHILE expr T_LOOP possible_cmd T_POOL D_SEM { $$ = template( "while(%s)\n{\n%s", $2, $4); }
;

possible_cmd:
  assignmentCommand D_SEM possible_cmd         { $$ = template("%s;\n%s", $1, $3); }
| assignmentCommand D_SEM                      { $$ = template("%s;", $1); }
| returnCommand     D_SEM possible_cmd         { $$ = template("%s;\n%s", $1, $3); }
| returnCommand     D_SEM                      { $$ = template("%s;", $1); }
| commitedFunc      D_SEM possible_cmd         { $$ = template("%s;\n%s", $1, $3); }
| commitedFunc      D_SEM                      { $$ = template("%s;", $1); }
| if_command              possible_cmd         { $$ = template("%s\n}\n%s", $1, $2); }
| if_command                                   { $$ = template("%s\n}", $1); }
| T_ELSE if_command                            { $$ = template("}\nelse %s", $2); }
| while_command           possible_cmd         { $$ = template("%s\n}\n%s", $1, $2); }
| while_command                                { $$ = template("%s\n}", $1); }
| dataDecl possible_cmd                        { $$ = template("%s\n%s", $1, $2); }
| dataDecl                                     { $$ = template("%s", $1); }
| callFunc D_SEM                               { $$ = template("%s;", $1); }
| callFunc D_SEM possible_cmd                  { $$ = template("%s;\n%s", $1, $3); }
| T_ELSE assignmentCommand D_SEM               { $$ = template("}\nelse\n{\n%s;", $2); }
| T_ELSE assignmentCommand D_SEM possible_cmd1 { $$ = template("}\nelse\n{\n%s;\n%s", $2, $4); }
| T_ELSE returnCommand     D_SEM               { $$ = template("}\nelse\n{\n%s;", $2); }
| T_ELSE returnCommand     D_SEM possible_cmd1 { $$ = template("}\nelse\n{\n%s;\n%s", $2, $4); }
| T_ELSE commitedFunc      D_SEM               { $$ = template("}\nelse\n{\n%s;", $2); }
| T_ELSE commitedFunc      D_SEM possible_cmd1 { $$ = template("}\nelse\n{\n%s;\n%s", $2, $4); }
| T_ELSE while_command     D_SEM               { $$ = template("}\nelse\n{\n%s;", $2); }
| T_ELSE while_command     D_SEM possible_cmd1 { $$ = template("}\nelse\n{\n%s;\n%s", $2, $4); }
| T_ELSE dataDecl          D_SEM               { $$ = template("}\nelse\n{\n%s;", $2); }
| T_ELSE dataDecl          D_SEM possible_cmd1 { $$ = template("}\nelse\n{\n%s;\n%s", $2, $4); }
| T_ELSE callFunc          D_SEM               { $$ = template("}\nelse\n{\n%s;", $2); }
| T_ELSE callFunc          D_SEM possible_cmd1 { $$ = template("}\nelse\n{\n%s;\n%s", $2, $4); }
;

possible_cmd1:
  assignmentCommand D_SEM possible_cmd1        { $$ = template("%s;\n%s", $1, $3); }
| assignmentCommand D_SEM                      { $$ = template("%s;", $1); }
| returnCommand     D_SEM possible_cmd1        { $$ = template("%s;\n%s", $1, $3); }
| returnCommand     D_SEM                      { $$ = template("%s;", $1); }
| commitedFunc      D_SEM possible_cmd1        { $$ = template("%s;\n%s", $1, $3); }
| commitedFunc      D_SEM                      { $$ = template("%s;", $1); }
| if_command              possible_cmd1        { $$ = template("%s\n}\n%s", $1, $2); }
| if_command                                   { $$ = template("%s\n}", $1); }
| while_command           possible_cmd1        { $$ = template("%s\n}\n%s", $1, $2); }
| while_command                                { $$ = template("%s\n}", $1); }
| dataDecl possible_cmd1                       { $$ = template("%s\n%s", $1, $2); }
| dataDecl                                     { $$ = template("%s", $1); }
| callFunc D_SEM                               { $$ = template("%s;", $1); }
| callFunc D_SEM possible_cmd1                 { $$ = template("%s;\n%s", $1, $3); }

%%
int main () {
  if ( yyparse() == 0 )
    printf("Accepted!\n");
  else
    printf("Rejected!\n");
}