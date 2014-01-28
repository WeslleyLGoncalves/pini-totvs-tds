#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

User Function Fatc01d()        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_APOSARQ,_NVEZ,_PAR01,_PAR02,MV_PAR01,MV_PAR02")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: FATC01D   �Autor: Mauricio Mendes        �Data:    13/11/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Chamada para o pedido de Vendas                            � ��
������������������������������������������������������������������������Ĵ ��
���Uso          : Especifico PINI Editora Ltda.                          � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_aPosArq   := { {Alias(),0,0}, {"SC5",0,0}, {"SC6",0,0}, {"SA1",0,0}, {"SC9",0,0}, {"SE1",0,0} }
For _nVez := 1 to Len(_aPosArq)
	dbSelectArea( _aPosArq[_nVez,1] )
	_aPosArq[_nVez,2] := IndexOrd()
	_aPosArq[_nVez,3] := Recno()
Next

_PAR01 := MV_PAR01
_PAR02 := MV_PAR02

MATA410()


For _nVez := 2 to Len(_aPosArq)
    dbSelectArea(_aPosArq[_nVez,1])
    dbSetOrder(_aPosArq[_nVez,2])
    dbGoTo(_aPosArq[_nVez,3])
Next
dbSelectArea(_aPosArq[1,1])
dbSetOrder(_aPosArq[1,2])
dbGoTo(_aPosArq[1,3])

MV_PAR01 := _PAR01
MV_PAR02 := _PAR02

Return

