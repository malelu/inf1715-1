%{
#define OP	050
#define CP	051
#define INT	100
#define STRING	200
#define FUNC	300
#define EXP	400
#define IDENT	301
#define DECTIPO 302
#define OPMAT	601
#define OPRELAC	602
#define RESERV	700
#define COMMENT	800
#define COMMENT2	850
#define EOL	901
#define ERROR	999999
#define WHITESPACES 8888888
int linha = 0;
int done = 0;
%}

%%

[\n]*	{linha++;}

[ \t]*	{return WHITESPACES;}

"("	{ return OP; }
")"	{ return CP; }
                            
\"([^\n"\\]|\\["\\])*\" { return STRING; }

[0-9]+ {return INT;}

\>|\<|\>=|\<=|\<>|and|or|not {return OPRELAC;}

[a-zA-Z]+ {return IDENT;}

[[INT|IDENT](WHITESPACES)(OPMAT)(INT)] {return EXP;} 

"["[0-9]*"]"(int|string|bool|char|char) {return DECTIPO;}

(fun)(^.)[a-zA-Z]+([a-z]*[\t][a-z]*); {return FUNC;}

(;|if|else|end|while|loop|return|new|true|false) {return RESERV;}

[+|-|*|/|=]	{return OPMAT;}

"/*"([^*]|\*+[^*/])*\*+"/" {return COMMENT;}



([ \t\n]*)	{ }

.           { return ERROR; }

%%

yywrap() {
	done = 1;
}

int main() {
	while (!done) {
		printf("%s -> linha %d \n ", yytext,linha);
		printf("%d\n", yylex());		
	}
	return 0;
}

