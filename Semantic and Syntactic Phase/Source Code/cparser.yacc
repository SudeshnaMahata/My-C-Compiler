/*
My-C-Compiler
Compiler Project for CSE Students by NITK Students
Copyright (C) "2012" "Harsh Mathur"
Credits:	World Wide Web:		ANSI C Grammar
			Niloy Gupta:		Semantic and Syntax Analysis Phase
			Sunil Rao:			For the great help, without him this work could never be possible
			Harsh Mathur:		Parse Tree and Intermediate Code Generation for expressions and for-loop
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Also add information on how to contact you by electronic and paper mail.
If the program does terminal interaction, make it output a short notice like this when it starts in an interactive mode:

"My-C-Compiler" Copyright (C) "2012" "Harsh Mathur"
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type `show c' for details.
 */
%{
#include <stdio.h>
#include <string.h>
#include "symbol_table.h"
extern FILE *yyin;
extern FILE *yyout;
extern int column;
extern int line;
extern int cnt;
extern char *yytext,tempid[100],myconst[100];
int temp,err,err1=0;

install()
{ 
	symrec *s;
	s = getsym (tempid);
	if (s == 0)
	s = putsym (tempid,temp);
	else 
	{
		printf(" VOID=1 ");
	 printf(" CHAR=2 ");
	 printf(" INT=3 ");
	 printf(" FLOAT=4 ");
	 printf(" DOUBLE=4 ");
		printf( "\n\nThere is a Semantic error at Pos : %d : %d : %s is already defined as %d\n\n",line,cnt,s->name,s->type );
		exit(0);	
	}
	err1=1;
}
void context_check()
{ 
	symrec *s;
	s = getsym(tempid);	
	if (s == 0 )
	{printf( "\n\nThere is a Semantic error at Pos : %d : %d : %s is an undeclared identifier\n\n",line,cnt,tempid);exit(0);}
	else
	return;
	err1=1;
	
}
type_err(struct ptree *t1,struct ptree *t2)
{
	if(t1==t2)
	{
	 printf(" VOID=1 ");
	 printf(" CHAR=2 ");
	 printf(" INT=3 ");
	 printf(" FLOAT=4 ");
	 printf(" DOUBLE=4 ");	
	printf( "\n\nThere is a Semantic error at Pos : %d : %d : Type mismatch for %s \n\n",line,cnt,tempid);
	err1=1;
	exit(0);	
	}	
}

%}

%union
{
	struct ptree *nptr;
	}


%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME SINGLE

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type <nptr> struct_declaration_list
%type <nptr> enum_specifier
%type <nptr> struct_or_union_specifier
%type <nptr> initializer
%type <nptr> init_declarator
%type <nptr> type_qualifier
%type <nptr> type_specifier
%type <nptr> storage_class_specifier
%type <nptr> init_declarator_list
%type <nptr> declaration_specifiers
%type <nptr> declaration
%type <nptr> constant_expression
%type <nptr> assignment_operator
%type <nptr> conditional_expression
%type <nptr> logical_or_expression
%type <nptr> logical_and_expression
%type <nptr> inclusive_or_expression
%type <nptr> exclusive_or_expression
%type <nptr> and_expression
%type <nptr> equality_expression
%type <nptr> relational_expression
%type <nptr> shift_expression
%type <nptr> additive_expression
%type <nptr> multiplicative_expression
%type <nptr> type_name
%type <nptr> cast_expression
%type <nptr> unary_operator
%type <nptr> unary_expression
%type <nptr> assignment_expression
%type <nptr> argument_expression_list
%type <nptr> postfix_expression
%type <nptr> expression
%type <nptr> primary_expression
%type <nptr> translation_unit
%type <nptr> struct_or_union
%type <nptr> struct_declaration
%type <nptr> specifier_qualifier_list
%type <nptr> struct_declarator_list
%type <nptr> struct_declarator
%type <nptr> declarator
%type <nptr> enumerator_list
%type <nptr> enumerator
%type <nptr> pointer
%type <nptr> direct_declarator
%type <nptr> parameter_type_list
%type <nptr> identifier_list
%type <nptr> type_qualifier_list
%type <nptr> parameter_list
%type <nptr> parameter_declaration
%type <nptr> abstract_declarator
%type <nptr> direct_abstract_declarator
%type <nptr> initializer_list
%type <nptr> statement
%type <nptr> labeled_statement
%type <nptr> compound_statement
%type <nptr> selection_statement
%type <nptr> iteration_statement
%type <nptr> jump_statement
%type <nptr> statement_list
%type <nptr> declaration_list
%type <nptr> expression_statement
%type <nptr> external_declaration
%type <nptr> function_definition

%start translation_unit
%%

primary_expression
	: IDENTIFIER	{context_check();$$ = addnew(myconst,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}//$$ = addnew("IDENTIFIER PRIMARY Expression",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| CONSTANT	{$$ = addnew(myconst,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| STRING_LITERAL	{$$ = addnew(myconst,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '(' expression ')' {$$= $2;}//$$ = addnew("PRIMARY Expression",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

postfix_expression
	: primary_expression	{$$=$1;}//$$ = addnew("POSTFIX Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression '[' expression ']'	{$$ = addnew("POSTFIX Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression '(' ')'	{$$ = addnew("POSTFIX Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression '(' argument_expression_list ')'	{$$ = addnew("POSTFIX Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression '.' IDENTIFIER	{$$ = addnew("POSTFIX Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression PTR_OP IDENTIFIER	{$$ = addnew("POSTFIX Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression INC_OP	{$$ = addnew("POSTFIX Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| postfix_expression DEC_OP	{$$ = addnew("POSTFIX Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

argument_expression_list
	: assignment_expression	{$$ = addnew("ARGUMENT Expression List",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| argument_expression_list ',' assignment_expression	{$$ = addnew("ARGUMENT Expression List",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

unary_expression
	: postfix_expression	{$$=$1;}//$$ = addnew("UNARY Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| INC_OP unary_expression	{$$ = addnew("INC_OP UNARY Expression",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| DEC_OP unary_expression	{$$ = addnew("DEC_OP UNARY Expression",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| unary_operator cast_expression	{$$ = addnew("UNARY Expression",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| SIZEOF unary_expression	{$$ = addnew("SIZEOF UNARY Expression",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| SIZEOF '(' type_name ')'	{$$ = addnew("SIZEOF UNARY Expression",$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

unary_operator
	: '&'	{$$ = addnew("& UNARY Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '*'	{$$ = addnew("* UNARY Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '+'	{$$ = addnew("+ UNARY Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '-'	{$$ = addnew("- UNARY Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '~'	{$$ = addnew("~ UNARY Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '!'	{$$ = addnew("! UNARY Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

cast_expression
	: unary_expression	{$$=$1;}//$$ = addnew("CAST Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '(' type_name ')' cast_expression	{$$ = addnew("CAST Expression",$2,$4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

multiplicative_expression
	: cast_expression	{$$=$1;}//$$ = addnew("MULTIPLICATIVE Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| multiplicative_expression '*' cast_expression	{$$ = addnew("* MULTIPLICATIVE Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| multiplicative_expression '/' cast_expression	{$$ = addnew("/ MULTIPLICATIVE Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| multiplicative_expression '%' cast_expression	{$$ = addnew("% MULTIPLICATIVE Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

additive_expression
	: multiplicative_expression	{$$=$1;}//$$ = addnew("ADDITIVE Epression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| additive_expression '+' multiplicative_expression	{$$ = addnew("+ ADDITIVE Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| additive_expression '-' multiplicative_expression	{$$ = addnew("- ADDITIVE Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

shift_expression
	: additive_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| shift_expression LEFT_OP additive_expression	{$$ = addnew("LEFT SHIFT Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| shift_expression RIGHT_OP additive_expression	{$$ = addnew("RIGHT SHIFT Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

relational_expression
	: shift_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| relational_expression '<' shift_expression	{$$ = addnew("< RELATIONAL Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| relational_expression '>' shift_expression	{$$ = addnew("> RELATIONAL Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| relational_expression LE_OP shift_expression	{$$ = addnew("LE_OP RELATIONAL Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| relational_expression GE_OP shift_expression	{$$ = addnew("GE_OP RELATIONAL Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

equality_expression
	: relational_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| equality_expression EQ_OP relational_expression	{$$ = addnew("EQ_OP EQUALITY Exprssion",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| equality_expression NE_OP relational_expression	{$$ = addnew("NE_OP EQUALITY Exprssion",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

and_expression
	: equality_expression	{$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| and_expression '&' equality_expression	{$$ = addnew("AND EXPRESSION",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

exclusive_or_expression
	: and_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| exclusive_or_expression '^' and_expression	{$$ = addnew("EXCLUSIVE OR Operation",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

inclusive_or_expression	
	: exclusive_or_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| inclusive_or_expression '|' exclusive_or_expression	{$$ = addnew("INCLUSIVE OR Operation",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

logical_and_expression
	: inclusive_or_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| logical_and_expression AND_OP inclusive_or_expression	{$$ = addnew("LOGICAL AND Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

logical_or_expression
	: logical_and_expression	{$$=$1;}//$$ = addnew("LOGICAL OR Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| logical_or_expression OR_OP logical_and_expression	{$$ = addnew("LOGICAL OR Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

conditional_expression
	: logical_or_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| logical_or_expression '?' expression ':' conditional_expression	{$$ = addnew("CONDITIONAL Expression",$1,$3,$5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

assignment_expression
	: conditional_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| unary_expression assignment_operator assignment_expression	{if($1!=$3){type_err($1,$3);}$$ = addnew("ASSIGNMENT Expression",$1,$2,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

assignment_operator
	: '='	{$$ = addnew("ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| MUL_ASSIGN	{$$ = addnew("MUL ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| DIV_ASSIGN	{$$ = addnew("DIV ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| MOD_ASSIGN	{$$ = addnew("MOD ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| ADD_ASSIGN	{$$ = addnew("ADD ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| SUB_ASSIGN	{$$ = addnew("SUB ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| LEFT_ASSIGN	{$$ = addnew("LEFT ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| RIGHT_ASSIGN	{$$ = addnew("RIGHT ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| AND_ASSIGN	{$$ = addnew("AND ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| XOR_ASSIGN	{$$ = addnew("XOR ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| OR_ASSIGN	{$$ = addnew("OR ASSIGNMENT Operator",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

expression
	: assignment_expression	{$$=$1;}//$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| expression ',' assignment_expression	{$$ = addnew("Expression",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

constant_expression
	: conditional_expression	{$$ = addnew("CONSTANT Expression",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

declaration
	: declaration_specifiers ';'	{$$ = addnew("DECLARATION",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declaration_specifiers init_declarator_list ';'	{$$ = addnew("DECLARATION",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

declaration_specifiers
	: storage_class_specifier	{$$ = addnew("DECLARATION SPECIFIERS",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| storage_class_specifier declaration_specifiers	{$$ = addnew("DECLARATION SPECIFIERS",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_specifier	{$$ = addnew("DECLARATION SPECIFIERS",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_specifier declaration_specifiers	{$$ = addnew("DECLARATION SPECIFIERS",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_qualifier	{$$ = addnew("DECLARATION SPECIFIERS",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_qualifier declaration_specifiers	{$$ = addnew("DECLARATION SPECIFIERS",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

init_declarator_list
	: init_declarator	{$$ = addnew("INIT DECLARATOR LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| init_declarator_list ',' init_declarator	{$$ = addnew("INIT DECLARATOR LIST",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

init_declarator
	: declarator	{$$ = addnew("INIT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declarator '=' initializer	{$$ = addnew("INIT DECLARATOR",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

storage_class_specifier
	: TYPEDEF	{$$ = addnew("TYPEDEF STORAGE CLASS SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| EXTERN	{$$ = addnew("EXTERN STORAGE CLASS SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| STATIC	{$$ = addnew("STATIC STORAGE CLASS SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| AUTO	{$$ = addnew("AUTO STORAGE CLASS SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| REGISTER	{$$ = addnew("REGISTER STORAGE CLASS SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

type_specifier
	: VOID	{temp=1;$$ = addnew("VOID TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| CHAR	{temp=2;$$ = addnew("CHAR TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| SHORT	{temp=3;$$ = addnew("SHORT TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| INT	{temp=3;$$ = addnew("INT TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| LONG	{temp=3;$$ = addnew("LONG TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| FLOAT	{temp=4;$$ = addnew("FLOAT TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| DOUBLE	{temp=4;$$ = addnew("DOUBLE TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| SIGNED	{$$ = addnew("SIGNED TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| UNSIGNED	{$$ = addnew("UNSIGNED TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| struct_or_union_specifier	{$$ = addnew("STRUCT OR UNION TYPE SPECIFIER",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| enum_specifier	{$$ = addnew("ENUM SPECIFIER",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| TYPE_NAME	{$$ = addnew("TYPE_NAME TYPE SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'	{install();$$ = addnew("STRUCT OR UNION SPECIFIER",$1,$4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| struct_or_union '{' struct_declaration_list '}'	{$$ = addnew("STRUCT OR UNION SPECIFIER",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| struct_or_union IDENTIFIER	{install();$$ = addnew("STRUCT OR UNION SPECIFIER",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

struct_or_union
	: STRUCT	{$$ = addnew("STRUCT",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| UNION	{$$ = addnew("UNION",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

struct_declaration_list
	: struct_declaration	{$$ = addnew("STRUCT DECLARATION LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| struct_declaration_list struct_declaration	{$$ = addnew("STRUCT DECLARATION LIST",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'	{$$ = addnew("STRUCT DECLARATION",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list	{$$ = addnew("SPECIFIER QUALIFIER LIST",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_specifier	{$$ = addnew("SPECIFIER QUALIFIER LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_qualifier specifier_qualifier_list	{$$ = addnew("SPECIFIER QUALIFIER LIST",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_qualifier	{$$ = addnew("SPECIFIER QUALIFIER LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

struct_declarator_list
	: struct_declarator	{$$ = addnew("STRUCT DECLARATOR LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| struct_declarator_list ',' struct_declarator	{$$ = addnew("STRUCT DECLARATOR LIST",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

struct_declarator
	: declarator	{$$ = addnew("STRUCT DECLARATOR LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| ':' constant_expression	{$$ = addnew("STRUCT DECLARATOR LIST",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declarator ':' constant_expression	{$$ = addnew("STRUCT DECLARATOR LIST",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

enum_specifier
	: ENUM '{' enumerator_list '}'	{$$ = addnew("ENUM SPECIFIER",$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| ENUM IDENTIFIER '{' enumerator_list '}'	{$$ = addnew("ENUM SPECIFIER",$4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| ENUM IDENTIFIER	{$$ = addnew("ENUM SPECIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

enumerator_list
	: enumerator	{$$ = addnew("ENUMERATOR LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| enumerator_list ',' enumerator	{$$ = addnew("ENUMERATOR LIST",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

enumerator
	: IDENTIFIER	{context_check();$$ = addnew("ENUMERATOR",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| IDENTIFIER '=' constant_expression	{$$ = addnew("ENUMERATOR",$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}//{context_check();}
	;

type_qualifier
	: CONST	{$$ = addnew("CONST TYPE_QUALIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| VOLATILE	{$$ = addnew("VOLATILE TYPE QUALIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

declarator
	: pointer direct_declarator	{$$ = addnew("DECLARATOR",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_declarator	{$$ = addnew("DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

direct_declarator
	: IDENTIFIER	{install();$$ = addnew("DIRECT DECLARATOR",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '(' declarator ')'	{$$ = addnew("DIRECT DECLARATOR",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_declarator '[' constant_expression ']'	{$$ = addnew("DIRECT DECLARATOR",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_declarator '[' ']'	{$$ = addnew("DIRECT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_declarator '(' parameter_type_list ')'	{$$ = addnew("DIRECT DECLARATOR",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_declarator '(' identifier_list ')'	{$$ = addnew("DIRECT DECLARATOR",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_declarator '(' ')'	{$$ = addnew("DIRECT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

pointer
	: '*'	{$$ = addnew("POINTER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '*' type_qualifier_list	{$$ = addnew("POINTER",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '*' pointer	{$$ = addnew("POINTER",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '*' type_qualifier_list pointer	{$$ = addnew("POINTER",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

type_qualifier_list
	: type_qualifier	{$$ = addnew("TYPE QUALIFIER LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| type_qualifier_list type_qualifier	{$$ = addnew("TYPE QUALIFIER LIST",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;


parameter_type_list
	: parameter_list	{$$ = addnew("PARAMETER TYPE LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| parameter_list ',' ELLIPSIS	{$$ = addnew("PARAMETER TYPE LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

parameter_list
	: parameter_declaration	{$$ = addnew("PARAMETER LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| parameter_list ',' parameter_declaration	{$$ = addnew("PARAMETER LIST",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

parameter_declaration
	: declaration_specifiers declarator	{$$ = addnew("PARAMETER DECLARATION",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declaration_specifiers abstract_declarator	{$$ = addnew("PARAMETER DECLARATION",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declaration_specifiers	{$$ = addnew("PARAMETER DECLARATION",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

identifier_list
	: IDENTIFIER	{install();$$ = addnew("IDENTIFIER",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| identifier_list ',' IDENTIFIER	{$$ = addnew("IDENTIFIER",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);install();}
	;

type_name
	: specifier_qualifier_list	{$$ = addnew("TYPE NAME",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| specifier_qualifier_list abstract_declarator	{$$ = addnew("TYPE NAME",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

abstract_declarator
	: pointer	{$$ = addnew("ABSTRACT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_abstract_declarator	{$$ = addnew("ABSTRACT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| pointer direct_abstract_declarator	{$$ = addnew("ABSTRACT DECLARATOR",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '[' ']'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '[' constant_expression ']'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_abstract_declarator '[' ']'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_abstract_declarator '[' constant_expression ']'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '(' ')'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '(' parameter_type_list ')'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_abstract_declarator '(' ')'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| direct_abstract_declarator '(' parameter_type_list ')'	{$$ = addnew("DIRECT ABSTRACT DECLARATOR",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

initializer
	: assignment_expression	{$$=$1;}//	{$$ = addnew("external Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '{' initializer_list '}'	{$$ = addnew("INITIALIZER",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '{' initializer_list ',' '}'	{$$ = addnew("INITIALIZER",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

initializer_list
	: initializer	{$$ = addnew("INITIALIZER LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| initializer_list ',' initializer	{$$ = addnew("INITIALIZER LIST",$1,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

statement
	: labeled_statement	{$$ = addnew("LABELED STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| compound_statement	{$$ = addnew("COMPOUND STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| expression_statement	{$$ = addnew("EXPRESSION STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| selection_statement	{$$ = addnew("SELECTION STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| iteration_statement	{$$ = addnew("ITERATION STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| jump_statement	{$$ = addnew("JUMP STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

labeled_statement
	: IDENTIFIER ':' statement	{$$ = addnew("LABELED STATEMENT",$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}//{context_check();}	
	| CASE constant_expression ':' statement	{$$ = addnew("LABELED STATEMENT",$2,$4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| DEFAULT ':' statement	{$$ = addnew("LABELED STATEMENT",$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

compound_statement
	: '{' '}'	{$$ = addnew("COMPOUND STATEMENT",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '{' statement_list '}'	{$$ = addnew("COMPOUND STATEMENT",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '{' declaration_list '}'	{$$ = addnew("COMPOUND STATEMENT",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| '{' declaration_list statement_list '}'	{$$ = addnew("COMPOUND STATEMENT",$2,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

declaration_list
	: declaration	{$$ = addnew("DECLARATION LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declaration_list declaration	{$$ = addnew("DECLARATION LIST",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

statement_list
	: statement	{$$ = addnew("STATEMENT LIST",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| statement_list statement	{$$ = addnew("STATEMENT LIST",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

expression_statement
	: ';'	{$$ = addnew("EXPRESSION STATEMENT",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| expression ';'	{$$ = addnew("EXPRESSION STATEMENT",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

selection_statement
	: IF '(' expression ')' statement {$$ = addnew("IF SELECTION STATEMENT",$3,$5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);} %prec LOWER_THAN_ELSE ;

	| IF '(' expression ')' statement ELSE statement	{$$ = addnew("IF ELSE SELECTION STATEMENT",$3,$5,$7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| SWITCH '(' expression ')' statement	{$$ = addnew("SWITCH EXPRESSION",$3,$5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

iteration_statement
	: WHILE '(' expression ')' statement	{$$ = addnew("WHILE ITERATION STATEMENT",$3,$5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| DO statement WHILE '(' expression ')' ';'	{$$ = addnew("DO WHILE ITERATION STATEMENT",$2,$5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| FOR '(' expression_statement expression_statement ')' statement	{$$ = addnew("FOR ITERATION STATEMENT",$3,$4,$6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| FOR '(' expression_statement expression_statement expression ')' statement	{$$ = addnew("FOR ITRATION STATEMENT",$3,$4,$5,$7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

jump_statement
	: GOTO IDENTIFIER ';'	{$$ = addnew("GOTO Jump Statement",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}//{context_check();}
	| CONTINUE ';'	{$$ = addnew("CONTINUE Jump Statement",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| BREAK ';'	{$$ = addnew("BREAK Jump Statement",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| RETURN ';'	{$$ = addnew("RETURN Jump Statement",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| RETURN expression ';'	{$$ = addnew("RETURN Jump Statement",$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

translation_unit
	: external_declaration	{$$ = addnew("Translation Unit",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);printtree($1);}
	| translation_unit external_declaration	{$$ = addnew("Translation Unit",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

external_declaration
	:function_definition	{$$ = addnew("External Declaration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declaration	{$$ = addnew("External Dec:laration",$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement	{$$ = addnew("FUNCTION DEFINITION",$1,$2,$3,$4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declaration_specifiers declarator compound_statement	{$$ = addnew("FUNCTION DEFINITION",$1,$2,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declarator declaration_list compound_statement	{$$ = addnew("FUNCTION DEFINITION",$1,$2,$3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	| declarator compound_statement	{$$ = addnew("FUNCTION DEFINITION",$1,$2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);}
	;
%%
yyerror(s)
char *s;
{
	fflush(stdout);err=1;
	printf("Syntax error at Pos : %d : %d\n",line,cnt);
	yyparse();
	//printf("\n%*s\n%*s\n", column, "^", column, s);
}
main(argc,argv)
int argc;
char **argv;
{
	
	char *fname;	
	++argv,--argc;/*skip program name*/
	if(argc>0)
	{
		yyin=fopen(argv[0],"r");
		fname=argv[0];
		strcat(fname,"_output");
		yyout=fopen(fname,"w");
	}
	else
	{
		printf("Please give the c filename as an argument.\n");
	}
	yyparse();
	if(err==0)
	printf("No Syntax errors found!\n");
	fname=argv[0];strcat(fname,"_symbol-table");
	FILE *sym_tab=fopen(fname,"w");
	fprintf(sym_tab,"Type\tSymbol\n");
	symrec *ptr;	
	for(ptr=sym_table;ptr!=(symrec *)0;ptr=(symrec *)ptr->next)
	{
		fprintf(sym_tab,"%d\t%s\n",ptr->type,ptr->name);
	}
	fclose(sym_tab);	
	
}	

