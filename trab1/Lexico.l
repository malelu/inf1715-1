
%{
#include "Lexico.h"

#define OP	101
#define CP	102
#define PONT	103
#define ID	111
#define DECLVAR	112
#define ATRIB	113
#define STRING	200
#define LITNUM	201
#define CHAR	202
#define DECINT	211
#define DECCHAR	212
#define DECSTRING 213
#define DECBOOL	214
#define AND	300
#define OR	301
#define NOT	302
#define TRUE	310
#define FALSE	311
#define FUNC	401
#define EXP	402
#define	RET	501
#define NEW	502
#define IF	511
#define ELSE	512
#define END	513
#define WHILE	521
#define	LOOP	522
#define OPMAT	600
#define	ADI	601
#define SUB	602
#define	MULT	603
#define	DIV	604
#define OPRELAC	610
#define	EQ	611
#define	DIF	612
#define	L	613
#define LE	614
#define	G	615
#define	GE	616
#define COMMENT	800
#define	NL	987
#define ERROR	999999
int linha = 1;
int done = 0;
extern FILE* yyin;
FILE* yyout;
%}

op	"("
cp	")"
digito	[0-9]
letra	[a-z]
ID	("_"|{letra})({digito}|{letra})*	
b	[ \t\n\r\v\f]+
nl	\n
fun	"fun"
vetor	("["[0-9]*"]")




%%
{nl}	{linha++;}
([ \v\t\n]*)	{ }
","	{return PONT;}
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
"+"	{return ADI;}
"-"	{return SUB;}
"*"	{return MULT;}
"/"	{return DIV;}
"="	{return EQ;}
"<>"	{return DIF;}
"<"	{return L;}
"<="	{return LE;}
">"	{return G;}
">="	{return GE;}
{letra}? {return CHAR;}
{vetor}?"int" {return DECINT;}
(({vetor}"char")|"string") {return DECSTRING;}
"char" 	{return DECCHAR;}
{vetor}?"bool" {return DECBOOL;}	
{ID}	{return ID;}
{digito}* {return LITNUM;}


 
                            
\"(\\.|[^"])*\" { return STRING; }

"/*"([^*]|\*+[^*/])*\*+"/" {return COMMENT;}


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
	printf("Valor: %d Tipo: %s ->linha %d \n",temp->valor,temp->nome,temp->linha);
	temp=temp->prox;
  }
}

int main(int argc,char* argv[]) {
	Token *t;
	int valort,i;
	Fila* f=criaFila();
	yyout=fopen("Saida.txt","w");
	if(!yyout){
		printf("Erro ao abrir o arquivo de escrita\n");
		exit(1);
	}
	if(argc>1)
		for(i=1;i<argc;i++){
			fprintf(yyout,"-----------TESTE: %s ---------------\n",argv[i]);
			yyin=fopen(argv[i],"r");
			if(!yyin){
				printf("Erro ao abrir o arquivo de leitura\n");
				exit(1);
			}
			while (!done) {
				valort=yylex();
				fprintf(yyout,"%d\n", valort);
				t=criaToken(valort,yytext,linha);
				insere(f,t);
				//printf("%s -> linha %d \n", yytext,linha);
				fprintf(yyout,"%d %s ->linha %d \n",t->valor,t->nome,t->linha);	
			}
		}
	fclose(yyin);
	fclose(yyout);
	return 0;
}

