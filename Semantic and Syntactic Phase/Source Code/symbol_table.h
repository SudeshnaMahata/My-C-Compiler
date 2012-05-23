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
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define t_void	1
#define t_char	2
#define t_int	3
#define t_float	4
FILE *file;
int stat = 0;
struct symrec
{
	char *name;
	int type;
	struct symrec *next;
};
typedef struct symrec symrec;
symrec *sym_table = (symrec *)0;
symrec *putsym();
symrec *getsym();

symrec *putsym(char *sym_name,int sym_type)
{
	symrec *ptr;
	ptr=(symrec *)malloc(sizeof(symrec));
	ptr->name=(char *)malloc(strlen(sym_name)+1);
	strcpy(ptr->name,sym_name);
	ptr->type=sym_type;
	ptr->next=(struct symrec *)sym_table;
	sym_table=ptr;
	return ptr;
}
symrec *getsym(char *sym_name)
{
	symrec *ptr;
	for(ptr=sym_table;ptr!=(symrec *)0;ptr=(symrec *)ptr->next)
	if(strcmp(ptr->name,sym_name)==0)
	return ptr;
	return 0;
}
struct ptree
{
	char name[100],var[100];
	int type;
	struct ptree *c1,*c2,*c3,*c4;
	};
	
typedef struct ptree tree;	
tree *addnew(char name[100],tree *t1,tree *t2,tree *t3,tree *t4,tree *t5,tree *t6,tree *t7,tree *t8,tree *t9,tree *t10,tree *t11,tree *t12);
//void printtree(tree *node);
tree *addnew(char name[100],tree *t1,tree *t2,tree *t3,tree *t4,tree *t5,tree *t6,tree *t7,tree *t8,tree *t9,tree *t10,tree *t11,tree *t12)
{
	//printf("Memory Allocating");
	tree *ptr;
	ptr = (tree*)malloc(sizeof(tree));
	///ptr->name=(char *)malloc(strlen(name)+1);
	strcpy(ptr->name,name);
	//printf("Going inside ptr name : %s\n",ptr->name);
	//if(t1!=NULL)
	ptr->c1 = t1;
	//if(t2!=NULL)
	ptr->c2 = t2;
	//if(t3!=NULL)
	ptr->c3 = t3;
	//if(t4!=NULL)
	ptr->c4 = t4;
	return ptr;
	}
printtree(tree *node)
{	if(stat==0){
	file = fopen("parsetree","w");
	stat= 1;
	}
	fprintf(file,"\n");
	if(node==NULL)
	return;
	printtree(node->c1);
	printtree(node->c2);
	printtree(node->c3);
	printtree(node->c4);
	if(node->name!=NULL)
	fprintf(file,"%s\t",node->name);
	}
