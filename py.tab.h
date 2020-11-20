/* A Bison parser, made by GNU Bison 3.3.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PY_TAB_H_INCLUDED
# define YY_YY_PY_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    FLOAT = 259,
    INTEGER = 260,
    STRING = 261,
    INDENT = 262,
    DEDENT = 263,
    IMPORT = 264,
    FROM = 265,
    AS = 266,
    CLASS = 267,
    FOR = 268,
    IN = 269,
    IF = 270,
    ELIF = 271,
    ELSE = 272,
    DEF = 273,
    INIT = 274,
    SELF = 275,
    PRINT = 276,
    LPAR = 277,
    RPAR = 278,
    COMMA = 279,
    COLON = 280,
    EQUALS = 281,
    NOTEQUALS = 282,
    LTE = 283,
    MTE = 284,
    LT = 285,
    MT = 286,
    ASSIGN = 287,
    PLUS = 288,
    MINUS = 289,
    MULTIPLICATION = 290,
    DIVISION = 291,
    DOT = 292,
    NEWLINE = 293
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 44 "py.y" /* yacc.c:1921  */

	float fval;
	char* sval;
	char  op;

#line 103 "py.tab.h" /* yacc.c:1921  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PY_TAB_H_INCLUDED  */
