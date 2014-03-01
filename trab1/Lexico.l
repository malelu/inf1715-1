
%{
#include "Lexico.h"

#define	NL	000
#define OP	050
#define CP	051
#define INT	101
#define CHAR	102
#define ID	111
#define DECLVAR	112
#define ATRIB	113
#define STRING	200
#define BOOL	201
#define AND	300
#define OR	301
#define NOT	302
#define TRUE	310
#define FALSE	311
#define FUNC	401
#define EXP	402
#define	RET	501
#define NEW	502
#define END	503
#define IF	511
#define ELSE	512
#define WHILE	521
#define	LOOP	522
#define OPMAT	601
#define OPRELAC	602
#define COMMENT	800
#define ERROR	999999
int linha = 1;
int done = 0;
Token* corr;
extern FILE* yyin;
extern FILE* yyout;
%}

op	"("
cp	")"
digito	[0-9]
letra	[a-z]
oprelac	\>|\<|\>=|\<=|\<>|\==
opmat	[-+*/]
tipo	(int|char|bool|string)
ID	"_"({digito}|{letra})*
exp	{expr}|("new"{b}("["{expr}"]")?{b}{tipo})
expr	({ID}|{digito}*)({b}([-+*/]|{oprelac}){b}({ID}|{digito}*))*	
b	[ \t]*
nl	[ \n]*
cmd	{cmdif}|{cmdwhile}|{cmdret}|{cmdatrib}|{chamada}
cmdatrib {ID}{b}"="{b}{exp}
cmdret	"return"({b}{expr})?
chamada	{ID}{b}"("{listexp}")"
fun	"fun"

cmdif	"if"{b}{exp}{nl}({cmd}{nl})*{cmdelse}?"end"
cmdelse	"else"{b}("if"{exp})?{nl}{b}({cmd}{nl})*
cmdwhile "while"{b}{exp}{nl}({cmd}{nl})*"loop"
params	({parametro}{b}","{b}{parametro}*)?
parametro {declvar}


listexp	({exp}{b}(","{b}{exp})*)?
declvar	{ID}{b}":"{b}("["[0-9]*"]")?{tipo}




%%
{nl}	{linha++;}
"fun"	{return FUNC;}
"return" {return RET;}
":"	{return DECLVAR;}
"if"	{return IF;}
"else"	{return ELSE;}
"end"	{return END;}
"while"	{return WHILE;}
"loop"	{return LOOP;}
"new"	{return NEW;}
"true"	{return TRUE;}
"false" {return FALSE;}
"and"	{return AND;}
"or"	{return OR;}
"not"	{return NOT;}
"("	{ return OP; }
")"	{ return CP; }
"="	{return ATRIB;}
{letra}? {return CHAR;}
{ID}	{return ID;}
{digito}* {return INT;}
{oprelac} {return OPRELAC;}
{opmat}	{return OPMAT;}


 
                            
\"([^\n"\\]|\\["\\])*\" { return STRING; }


{expr} {return EXP;}

{cmdatrib} {return ATRIB;}

{declvar} {return DECLVAR;}

"/*"([^*]|\*+[^*/])*\*+"/" {return COMMENT;}

([ \t\n]*)	{ }

.           { return ERROR; }

%%

yywrap() {
	done = 1;
}

Token* criaToken(int val,char* nome,int linha){
  Token* novo=(Token*)malloc(sizeof(Token));
  novo->valor=val;
  novo->nome=nome;
  novo->linha=linha;
  novo->prox=NULL;
  return novo;
}

Fila* criaFila(){
  Fila *n=(Fila*)malloc(sizeof(Fila));
  n->prim=NULL;
  n->quant=0;
  return n;
}

int FilaVazia(Fila* f){
  if(f->prim==NULL)
  	return 1;
  else
	return 0;
}

void insere(Fila* f,Token* t){
  if(FilaVazia(f))
  	f->prim=t;
  else{
	Token* temp=f->prim;
  	while(temp->prox!=NULL)
		temp=temp->prox;
	temp->prox=t;
  }
  f->quant++;
}

void imprime(Fila* f){
  Token* temp=f->prim;
  while(temp->prox!=NULL){
	printf("%d %s ->linha %d \n",temp->valor,temp->nome,temp->linha);
	temp=temp->prox;
  }
}

int main() {
	Token *t;
	int valort;
	Fila* f=criaFila();
	yyin=fopen("TesteExp.txt","r");
	//yyout=fopen("Saida.txt","w");
	while (!done) {
		valort=yylex();
		printf("%d\n", valort);
		t=criaToken(valort,yytext,linha);
		insere(f,t);
		/*if(ant!=NULL) Ant ja foi inicializado
			ant->prox=t;
		ant=t;
		if(isdigit(yytext))
			t->valor=(int)(atoi(yytext));
		else
			t->valor=(char*)yytext;
		t->linha=linha;	*/
		printf("%s -> linha %d \n", yytext,linha);
		printf("%d %s ->linha %d \n",t->valor,t->nome,t->linha);	
	}
	//imprime(f);
	fclose(yyin);
	fclose(yyout);
	return 0;
}

