#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function M460IREN()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NREG,_NREGSB1,_NINDSB1,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: M460IREN  �Autor: Desconhecido           � Data:   02/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Ponto de Entrada retornando valor do IRRF na N.F.          � ��
������������������������������������������������������������������������Ĵ ��
���Release  : Roger Cangianeli - padroniza��o.                           � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()

dbSelectArea("SB1")
_nRegSB1 := Recno()
_nIndSB1 := IndexOrd()
dbSetOrder(1)
If dbSeek( xFilial("SB1")+SD2->D2_COD, .F.)
	dbSelectArea("SE1")
	If RecLock("SE1", .F.)
		SE1->E1_GRPROD :=  SB1->B1_GRUPO
		msUnlock()
	EndIf
EndIf

dbSelectArea("SB1")
dbSetOrder(_nIndSB1)
dbGoTo(_nRegSB1)

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return
