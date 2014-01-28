#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr27()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CPERG,NLASTKEY")
SetPrvt("CSAVTELA1,_MVAL,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR27   �Autor: Rosane Rodrigues       � Data:   23/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: TOTALIZADOR DO FATURAMENTO - PUBLICIDADE                   � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
cSavTela   := SaveScreen( 0, 0,23,80)
cSavCursor := SetCursor()
cSavCor    := SetColor()
cSavAlias  := Select()
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   MV_PAR01  = Do Numero                   �
//�   MV_PAR02  = At� o Numero                �
//���������������������������������������������

cPerg    := "MTR160"
If !Pergunte(CPERG)
   Return
EndIf
nLastKey := 0
// �����������������������������������������������Ŀ
// �Chama Relatorio                                �
// �������������������������������������������������
#IFDEF WINDOWS
   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    RptStatus({|| Execute(RptDetail) })
#ELSE
   RptDetail()
#ENDIF
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do corpo do relatorio                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

DbSelectArea("SE1")
DbSetOrder(01)

*COLOQUEI UNI ATE ACERTAR OS PROGRAMAS

DbSeek(Xfilial("SE1")+'UNI'+MV_PAR01,.T.)

Set Devi to Screen
cSavCursor := SetCursor()
cSavCor    := SetColor()
cSavAlias  := Select()
cSavtela1:=Savescreen(3,0,24,79)
set color to B/BG
DrawAdvWin("** TOTAL DE FATURAMENTO - PUBLICIDADE **" , 10, 7, 17, 71 )
_mVal := 0

While SE1->E1_NUM <= MV_PAR02
    If SE1->E1_DIVVEN == 'PUBL' .OR. 'P' $(SE1->E1_PEDIDO)
       _mVal := _mVal + SE1->E1_VALOR
       @ 13,24 SAY "Total Faturado : "
       @ 13,44 SAY _mVal picture "@e 999,999.99"
    Endif
    DbSkip()
End
@ 16,23 SAY "Fim ... Pressione qualquer tecla"
inkey(0)
Restscreen(3,2,23,79,cSavtela1)
Return



