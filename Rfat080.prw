#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Rfat080()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CARQ,MPEDIDO")
SetPrvt("MTIPOREV,MCODPROD,")

//���������������������������������������������������������������������������Ŀ
//�                                                                           �
//�����������������������������������������������������������������������������
cSavTela   := SaveScreen( 0, 0,24,80)
cSavCursor := SetCursor()
cSavCor    := SetColor()
cSavAlias  := Select()

//������������������������������������������Ŀ
//� Recupera o desenho padrao de atualizacoes�
//��������������������������������������������
ScreenDraw("SMT050", 3, 0, 0, 0)
SetCursor(1)
SetColor("B/BG")

DrawAdvWin("CSP2743" , 8, 0, 12, 75 )
@ 10, 5 Say " A G U A R D E "

cArq:='CSP2743.DBF'
dbUseArea( .T.,, cArq,"CSP2743", if(.F. .OR. .F., !.F., NIL), .F. )
DBSELECTAREA('CSP2743')
DBGOTOP()


DO WHILE .NOT. EOF()
    @ 11, 5 say 'lendo registro ' +str(recno(),6)
    MPEDIDO:=PEDIDO+ITEM
    DBSELECTAREA("SC6")
    DBSETORDER(1)
    DBSEEK(XFILIAL()+MPEDIDO)
    IF FOUND()
       MTIPOREV:=C6_TIPOREV
       MCODPROD:=C6_PRODUTO
    ELSE
       MTIPOREV:=' '
       MCODPROD:=' '
    ENDIF
    dbselectarea("CSP2743")
    RECLOCK("CSP2743",.F.)
     CSP2743->PRODUTO := MCODPROD
     CSP2743->TIPOREV := MTIPOREV
    CSP2743->(MSUNLOCK())
    DBSELECTAREA("CSP2743")
    DBSKIP()
ENDDO

RETURN



