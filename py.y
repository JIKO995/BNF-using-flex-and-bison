%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();

extern int yylineno;

extern FILE* yyin;
extern FILE* yyout;

extern int indent_stack[20];
extern int curr_level;
extern int global_level;

void yyerror(const char* s);

void evaluate(float a, char b, float c) {
	switch(b) {
		case '+':
			fprintf(yyout, "Expression at line %d evaluates to: %f\n", yylineno, a + c);
			break;
		case '-':
			fprintf(yyout, "Expression at line %d evaluates to: %f\n", yylineno, a - c);
			break;
		case '*':
			fprintf(yyout, "Expression at line %d evaluates to: %f\n", yylineno, a * c);
			break;
		case '/':
			if (c != 0.0) {
				fprintf(yyout, "Expression at line %d evaluates to: %f\n", yylineno, a + c);
			}  fprintf(yyout, "Expression at line %d: Divide by zero\n", yylineno);
			break;
		default:
			break;
	}
}

%}

%union {
	float fval;
	char* sval;
	char  op;
}

%token IDENTIFIER;
%token<fval> FLOAT;
%token<fval> INTEGER;
%token<sval> STRING;

%token INDENT;
%token DEDENT;

%token IMPORT;
%token FROM;
%token AS;

%token CLASS;

%token FOR;
%token IN;

%token IF;
%token ELIF;
%token ELSE;

%token DEF;
%token INIT;
%token SELF;

%token PRINT;

%token LPAR;
%token RPAR;

%token COMMA;
%token COLON;

%token EQUALS;
%token NOTEQUALS;
%token LTE;
%token MTE;
%token LT;
%token MT;

%token ASSIGN;

%token PLUS;
%token MINUS;
%token MULTIPLICATION;
%token DIVISION;

%token DOT;

%token NEWLINE;

%type<fval> number;
%type<op>   operator;

%%

parsing: class			{ fprintf(yyout, "Okay\n"); }
	   | import class   { fprintf(yyout, "Okay\n"); }
;

import: import IMPORT module NEWLINE
	  | import IMPORT module AS IDENTIFIER NEWLINE
	  | import FROM module IMPORT IDENTIFIER NEWLINE
	  | import FROM module IMPORT MULTIPLICATION NEWLINE
	  | IMPORT module NEWLINE
	  | IMPORT module AS IDENTIFIER NEWLINE
	  | FROM module IMPORT IDENTIFIER NEWLINE
	  | FROM module IMPORT MULTIPLICATION NEWLINE
	{}
;

module: IDENTIFIER DOT module
	  | IDENTIFIER 
	{}
;

class: CLASS IDENTIFIER COLON NEWLINE INDENT constructor code DEDENT
	 | CLASS IDENTIFIER COLON NEWLINE INDENT constructor DEDENT
	 | CLASS IDENTIFIER COLON NEWLINE INDENT code DEDENT
	{}
;

constructor: DEF INIT LPAR SELF RPAR COLON NEWLINE INDENT code DEDENT
		   | DEF INIT LPAR SELF COMMA parameters RPAR COLON NEWLINE INDENT code DEDENT
	{}
;

identifier: SELF DOT IDENTIFIER
		  | IDENTIFIER
	{}
;

code: code assignment
	| code for
	| code if
	| code def
	| code call
	| code print
	| assignment
	| for
	| if
	| def
	| call
	| print
	{}
;

assignment: identifier ASSIGN expression NEWLINE
		  | identifier ASSIGN call
		  | identifier operator ASSIGN expression NEWLINE
		  | identifier ASSIGN STRING NEWLINE
;

expression: number operator expression
		  | identifier operator expression
		  | number operator number { evaluate($1, $2, $3); }
		  | number
		  | identifier
	{}
;

number: INTEGER { $<fval>$ = $1; }
	  | FLOAT { $<fval>$ = $1; }
	{}
;

operator: PLUS { $<op>$ = '+'; }
	    | MINUS { $<op>$ = '-'; }
		| MULTIPLICATION { $<op>$ = '*'; }
		| DIVISION { $<op>$ = '/'; }
	{}
;

for: FOR identifier IN identifier COLON NEWLINE INDENT code DEDENT
	{}
;

if: IF condition COLON NEWLINE INDENT code DEDENT elifs ELSE COLON NEWLINE INDENT code DEDENT
  | IF condition COLON NEWLINE INDENT code DEDENT ELSE COLON NEWLINE INDENT code DEDENT
  | IF condition COLON NEWLINE INDENT code DEDENT
	{}
;

elifs: elifs ELIF condition COLON NEWLINE INDENT code DEDENT
     | ELIF condition COLON NEWLINE INDENT code DEDENT
	{}
;

condition: expression compare expression
	{}
;

compare: EQUALS
	   | NOTEQUALS
	   | LTE
	   | MTE
	   | LT
	   | MT
	{}
;

def: DEF identifier LPAR parameters RPAR COLON NEWLINE INDENT code DEDENT
	{}
;

parameters: identifier COMMA parameters
		  | identifier
		  |
	{}
;

call: identifier LPAR parameters RPAR NEWLINE
	{}
;

print: PRINT LPAR STRING RPAR NEWLINE 
	{ char *str = $3;
	  str[strlen($3) - 2] = '\0';
	  fprintf(yyout, "Printing: %s\n", str); 
	}
;

%%

int main(int argc, char** argv) {
	//extern int yydebug;
	//yydebug = 1;

	++argv; 
	--argc;
	if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
      else
        yyin = stdin;

	yyparse();

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Line %d: %s\n", yylineno, s);
	exit(1);
}
