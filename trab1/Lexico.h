#include <stdlib.h>

typedef struct token{
  int valor;
  char* nome;
  int linha;
  struct token *prox;
}Token;

typedef struct fila{
  Token* prim;
  int quant;
}Fila;

Token* criaToken(int val,char* nome,int linha);

Fila* criaFila();

int FilaVazia(Fila* l);

void insere(Fila* f,Token* t);

void imprime(Fila* f);
