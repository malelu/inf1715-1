%{
#define OP	050
#define CP	051
#define INT	101
#define IDENT	111
#define DECLVAR	112
#define ATRIB	113
#define STRING	200
#define BOOL	201
#define FUNC	300
#define EXP	400
#define	RET	501
#define NEW	502
#define END	503
#define IF	511
#define ELSE	512
#define WHILE	521
#define	LOOP	522
#define OPMAT	601
#define OPRELAC	602
#define RESERV	700
#define COMMENT	800
#define EOL	987
#define ERROR	999999
int linha = 1;
int done = 0;
extern FILE* yyin;
extern FILE* yyout;
%}

op	"("
cp	")"
digito	[0-9]
letra	[a-z]
oprelac	\>|\<|\>=|\<=|\<>|and|or|not
tipo	(int|char|bool|string)
ID	{letra}({digito}|{letra})*
exp	{expr}|("new"{b}("["{expr}"]")?{b}{tipo})
expr	({ID}|{digito}*)({b}([-+*/]|{oprelac}){b}({ID}|{digito}*))*	
b	[ \t]*
nl	[ \n]*
cmd	{cmdif}|{cmdwhile}|{cmdret}|{cmdatrib}|{chamada}
cmdatrib {ID}{b}"="{b}{exp}
cmdret	"return"({b}{expr})?
chamada	{ID}{b}"("{listexp}")"
fun	"fun"{b}{ID}"("({params})?")"{b}(":"{b}{tipo})?{nl}{b}{declvar}{nl}{cmd}{nl}"end"{nl}

cmdif	"if"{b}{exp}{nl}({cmd}{nl})*{cmdelse}?"end"
cmdelse	"else"{b}("if")?{b}{exp}{nl}({cmd}{nl})*
cmdwhile "while"{b}{exp}{nl}({cmd}{nl})*"loop"
params	({parametro}{b}","{b}{parametro}*)?
parametro {declvar}


listexp	()|{exp}{b}(","{b}{exp})*
declvar	{ID}{b}":"{b}("["[0-9]*"]")?{tipo}




%%

[\n]*	{linha++;}
{fun}	{return FUNC;}
{cmdret} {return RET;}
";"	{return EOL;}
"if"	{return IF;}
"else"	{return ELSE;}
"end"	{return END;}
"while"	{return WHILE;}
"loop"	{return LOOP;}
"new"	{return NEW;}
"true"|"false" {return BOOL;}
"("	{ return OP; }
")"	{ return CP; }
                            
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

int main() {
	//yyin=fopen("TesteExp.txt","r");
	//yyout=fopen("Saida.txt","w");
	while (!done) {
		printf("%d\n", yylex());
		printf("%s -> linha %d \n", yytext,linha);
		
	}
	fclose(yyin);
	fclose(yyout);
	return 0;
}

