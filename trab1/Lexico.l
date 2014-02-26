%{
#define INT	100
#define STRING	200
#define FUNC	300
#define IDENT	301
#define DECTIPO 302
#define OPMAT	601
#define OPRELAC	602
#define RESERV	700
#define COMMENT	800
#define EOL	901
#define ERROR	999999

int done = 0;
%}

%%                            
\"([^\n"\\]|\\["\\])*\" { return STRING; }

[0-9]+ {return INT;}

\(|\)|\>|\<|\>=|\<=|\<> {return OPRELAC;}

(int|string|bool|char|"["[0-9]*"]"char) {return DECTIPO;}

(;|if|else|end|while|loop|fun|return|new|true|false|and|or|not) {return RESERV;}

[a-zA-Z]+ {return IDENT;}

[+|-|*|/|=]	{return OPMAT;}

"/*"([^*]|\*+[^*/])*\*+"/" {return COMMENT;}

%[a-zA-Z]+([a-z]*[\t][a-z]*); {return FUNC;}

([ \t\n]*)	{ }

.           { return ERROR; }

%%

yywrap() {
	done = 1;
}

int main() {
	while (!done) {
		printf("%d\n", yylex());
		printf("%s\n", yytext);
	}
	return 0;
}

