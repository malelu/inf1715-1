#include <stdlib.h>

typedef struct token{
  void* valor;
  int linha;
  struct token *prox;
}Token;

Token* criaToken(void* val,int linha){
  Token* novo=(Token*)malloc(sizeof(Token))
  novo->valor=val;
  novo->linha=linha;
  novo->prox=NULL;
  return novo;
}
