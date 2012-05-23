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
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
#include "y.tab.h"
int cnt=1;
int line=1;
char tempid[100],myconst[100];
%}

%%
"/*"			{comment();}

"auto"			{ cnt+=yyleng;ECHO; return(AUTO); }
"break"			{ cnt+=yyleng;ECHO; return(BREAK); }
"case"			{ cnt+=yyleng;ECHO; return(CASE); }
"char"			{ cnt+=yyleng;ECHO; return(CHAR); }
"const"			{ cnt+=yyleng;ECHO; return(CONST); }
"continue"		{ cnt+=yyleng;ECHO; return(CONTINUE); }
"default"		{ cnt+=yyleng;ECHO; return(DEFAULT); }
"do"			{ cnt+=yyleng;ECHO; return(DO); }
"double"		{ cnt+=yyleng;ECHO; return(DOUBLE); }
"else"			{ cnt+=yyleng;ECHO; return(ELSE); }
"enum"			{ cnt+=yyleng;ECHO; return(ENUM); }
"extern"		{ cnt+=yyleng;ECHO; return(EXTERN); }
"float"			{ cnt+=yyleng;ECHO; return(FLOAT); }
"for"			{ cnt+=yyleng;ECHO; return(FOR); }
"goto"			{ cnt+=yyleng;ECHO; return(GOTO); }
"if"			{ cnt+=yyleng;ECHO; return(IF); }
"int"			{ cnt+=yyleng;ECHO; return(INT); }
"long"			{ cnt+=yyleng;ECHO; return(LONG); }
"register"		{ cnt+=yyleng;ECHO; return(REGISTER); }
"return"		{ cnt+=yyleng;ECHO; return(RETURN); }
"short"			{ cnt+=yyleng;ECHO; return(SHORT); }
"signed"		{ cnt+=yyleng;ECHO; return(SIGNED); }
"sizeof"		{ cnt+=yyleng;ECHO; return(SIZEOF); }
"static"		{ cnt+=yyleng;ECHO; return(STATIC); }
"struct"		{ cnt+=yyleng;ECHO; return(STRUCT); }
"switch"		{ cnt+=yyleng;ECHO; return(SWITCH); }
"typedef"		{ cnt+=yyleng;ECHO; return(TYPEDEF); }
"union"			{ cnt+=yyleng;ECHO; return(UNION); }
"unsigned"		{ cnt+=yyleng;ECHO; return(UNSIGNED); }
"void"			{ cnt+=yyleng;ECHO; return(VOID); }
"volatile"		{ cnt+=yyleng;ECHO; return(VOLATILE); }
"while"			{ cnt+=yyleng;ECHO; return(WHILE); }
(['])+({L}|{D})+(['])			{ cnt+=yyleng;ECHO; return(SINGLE); }
{L}({L}|{D})*		{ cnt+=yyleng;ECHO; strcpy(tempid,yytext);return(IDENTIFIER); }

0[xX]{H}+{IS}?		{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }
0{D}+{IS}?		{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }
{D}+{IS}?		{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }
L?'(\\.|[^\\'])+'	{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }

{D}+{E}{FS}?		{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(CONSTANT); }

L?\"(\\.|[^\\"])*\"	{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(STRING_LITERAL); }

"..."			{ cnt+=yyleng;ECHO; strcpy(myconst,yytext);return(ELLIPSIS); }
">>="			{ cnt+=yyleng;ECHO; return(RIGHT_ASSIGN); }
"<<="			{ cnt+=yyleng;ECHO; return(LEFT_ASSIGN); }
"+="			{ cnt+=yyleng;ECHO; return(ADD_ASSIGN); }
"-="			{ cnt+=yyleng;ECHO; return(SUB_ASSIGN); }
"*="			{ cnt+=yyleng;ECHO; return(MUL_ASSIGN); }
"/="			{ cnt+=yyleng;ECHO; return(DIV_ASSIGN); }
"%="			{ cnt+=yyleng;ECHO; return(MOD_ASSIGN); }
"&="			{ cnt+=yyleng;ECHO; return(AND_ASSIGN); }
"^="			{ cnt+=yyleng;ECHO; return(XOR_ASSIGN); }
"|="			{ cnt+=yyleng;ECHO; return(OR_ASSIGN); }
">>"			{ cnt+=yyleng;ECHO; return(RIGHT_OP); }
"<<"			{ cnt+=yyleng;ECHO; return(LEFT_OP); }
"++"			{ cnt+=yyleng;ECHO; return(INC_OP); }
"--"			{ cnt+=yyleng;ECHO; return(DEC_OP); }
"->"			{ cnt+=yyleng;ECHO; return(PTR_OP); }
"&&"			{ cnt+=yyleng;ECHO; return(AND_OP); }
"||"			{ cnt+=yyleng;ECHO; return(OR_OP); }
"<="			{ cnt+=yyleng;ECHO; return(LE_OP); }
">="			{ cnt+=yyleng;ECHO; return(GE_OP); }
"=="			{ cnt+=yyleng;ECHO; return(EQ_OP); }
"!="			{ cnt+=yyleng;ECHO; return(NE_OP); }
";"			{ cnt+=yyleng;ECHO; return(';'); }
("{"|"<%")		{ cnt+=yyleng;ECHO; return('{'); }
("}"|"%>")		{ cnt+=yyleng;ECHO; return('}'); }
","			{ cnt+=yyleng;ECHO; return(','); }
":"			{ cnt+=yyleng;ECHO; return(':'); }
"="			{ cnt+=yyleng;ECHO; return('='); }
"("			{ cnt+=yyleng;ECHO; return('('); }
")"			{ cnt+=yyleng;ECHO; return(')'); }
("["|"<:")		{ cnt+=yyleng;ECHO; return('['); }
("]"|":>")		{ cnt+=yyleng;ECHO; return(']'); }
"."			{ cnt+=yyleng;ECHO; return('.'); }
"&"			{ cnt+=yyleng;ECHO; return('&'); }
"!"			{ cnt+=yyleng;ECHO; return('!'); }
"~"			{ cnt+=yyleng;ECHO; return('~'); }
"-"			{ cnt+=yyleng;ECHO; return('-'); }
"+"			{ cnt+=yyleng;ECHO; return('+'); }
"*"			{ cnt+=yyleng;ECHO; return('*'); }
"/"			{ cnt+=yyleng;ECHO; return('/'); }
"%"			{ cnt+=yyleng;ECHO; return('%'); }
"<"			{ cnt+=yyleng;ECHO; return('<'); }
">"			{ cnt+=yyleng;ECHO; return('>'); }
"^"			{ cnt+=yyleng;ECHO; return('^'); }
"|"			{ cnt+=yyleng;ECHO; return('|'); }
"?"			{ cnt+=yyleng;ECHO; return('?'); }
		
[ ]			{cnt+=yyleng;ECHO;}
[\t\v\f]		{ cnt+=yyleng; }
[\n]			{line++;cnt=1;}
.			{ /* ignore bad characters */ }

%%
yywrap()
{
	return(1);
}
comment()
{
	char c, c1;
loop:
	while ((c = input()) != '*' && c != 0)
	{
		if(c=='\n')	{line++;cnt=1;} 
		else	{cnt++;}
	}
		//putchar(c); PUTCHAR only if comments need to be shown! 
	if ((c1 = input()) != '/' && c1 != 0)
	{
		unput(c1);
		goto loop;
	}
}


