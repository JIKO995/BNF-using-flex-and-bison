%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "py.tab.h"

int curr_level = 0;
int global_level = 0;
int dent = 0;

int counter = 0;

static int token = 0;

%}

%option noyywrap
%option yylineno

comment      [#][^\n]*
comment_line ^[#][^\n]*\n
comment_ind  ^[ \t]*[#]
empty        ^\s*\n 
in_tab       ^[\t]*
in_spc       ^[ ]{4}*
identifier   [a-zA-Z_][a-zA-Z0-9_]* 
float        [0-9]+"."[0-9]+         
integer      [0-9]+  
string1      [\'][^\'\n]*[\']
string2      [\"][^\"\n]*[\"]

%%
    if (dent) {
        //printf("\n\nDENT\n");
        dent--;
        global_level--;
        return DEDENT;
    }

{in_tab}                { curr_level = yyleng;
                          //printf("\n\nCURR %d | GLOBAL %d\n", curr_level, global_level);
                          if (curr_level == global_level + 1) {
                              global_level++;
                              //printf("GLOBAL %d\n", global_level);
                              return INDENT;        
                          }
                          if (curr_level < global_level) {
                              global_level--;
                              dent = global_level - curr_level;
                              //printf("\n\nDEDENT %d", dent);
                              return DEDENT;
                          }
                        };
{in_spc}                { curr_level = yyleng / 4;
                          //printf("\n\nCURR %d | GLOBAL %d\n", curr_level, global_level);
                          if (curr_level > global_level) {
                              global_level++;
                              //printf("GLOBAL %d\n", global_level);
                              return INDENT;        
                          }
                          if (curr_level < global_level) {
                              global_level--;
                              dent = global_level - curr_level;
                              //printf("\n\nDEDENT %d", dent);
                              return DEDENT;
                          }
                        };

{comment_ind}           {};
{comment_line}          {};
{comment}               {}; /* Ignore comments */
{empty}                 {}; /* Ignore empty lines and lines with whitespace */
"\\\n"                  {}; /* Concat Lines with '\' */
"import"                { return IMPORT; };
"from"                  { return FROM; };
"as"                    { return AS; };
"class"                 { return CLASS; };
"for"                   { return FOR; };
"in"                    { return IN; };
"if"                    { return IF; };
"elif"                  { return ELIF; };
"else"                  { return ELSE; };
"def"                   { return DEF; };
"__init__"              { return INIT; };
"self"                  { return SELF; };
"print"                 { return PRINT; };
"("                     { return LPAR; };
")"                     { return RPAR; };   
","                     { return COMMA; };
":"                     { return COLON; };
"=="                    { return EQUALS; };
"!="                    { return NOTEQUALS; };
"<="                    { return LTE; };
">="                    { return MTE; };
"<"                     { return LT; };
">"                     { return MT; }; 
"="                     { return ASSIGN; };
"+"                     { return PLUS; };
"-"                     { return MINUS; };
"*"                     { return MULTIPLICATION; };
"/"                     { return DIVISION; };
"."                     { return DOT; };
"\n"                    { curr_level = 0; return NEWLINE; };

{identifier}            { return IDENTIFIER; };
{float}                 { yylval.fval = atof(yytext); return FLOAT; };
{integer}               { yylval.fval = atof(yytext); return INTEGER; };
{string1}               { yylval.sval = yytext; return STRING; };
{string2}               { yylval.sval = yytext; return STRING; };


<<EOF>>                 { //printf("\n\nEOF\n");
                          if (global_level) {
                              global_level--;
                              dent = global_level;
                              //printf("EOFDENT %d", dent);
                              return DEDENT;
                          } else {
                              //printf("\n\nTRUE EOF\n");
                              return EOF;
                          }
                        };
                        
%%