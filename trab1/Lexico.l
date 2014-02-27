%{
#define OP	050
#define CP	051
#define INT	101
#define IDENT	111
#define DECTIPO 112
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
#define WHITESPACES 123
int linha = 1;
int done = 0;
%}

digito	[0-9]
letra	[a-z]
var	{letra}({digito}|{letra})*
expr	({var}|{digito}*)[-+*/]({var}|{digito}*)



%%

[\n]*	{linha++;}

[ \t]*	{return WHITESPACES;}

"("	{ return OP; }
")"	{ return CP; }
                            
\"([^\n"\\]|\\["\\])*\" { return STRING; }

{var} {return IDENT;}

{expr} {return EXP;}

";"	{return EOL;}
"if"	{return IF;}
"else"	{return ELSE;}
"end"	{return END;}
"while"	{return WHILE;}
"loop"	{return LOOP;}
"return" {return RET;}
"new"	{return NEW;}
(true|false) {return BOOL;}

\>|\<|\>=|\<=|\<>|and|or|not {return OPRELAC;}

"/*"([^*]|\*+[^*/])*\*+"/" {return COMMENT;}

([ \t\n]*)	{ }

.           { return ERROR; }

%%

yywrap() {
	done = 1;
}

int main() {
	while (!done) {
		printf("%d\n", yylex());
		printf("%s -> linha %d \n", yytext,linha);
		
	}
	return 0;
}

