#INCLUDE "RWMAKE.CH"

User Function Edicao()

IF SUBS(M->C6_PRODUTO,1,2)#'10'.AND.;
   SUBS(M->C6_PRODUTO,1,2)#'17'.AND.;
   SUBS(M->C6_PRODUTO,1,4)#'1105'
   _cEDINIC:=9999
ELSE
   _cEDINIC:=0
ENDIF
RETURN(_cEDINIC)