#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: FAT9VC01  �Autor: Roger Cangianeli       � Data:   26/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Validacao do Campo Cliente na Manutencao do SZV            � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Valida no ExecBlock RFATA09                                � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fat9vc01()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

SetPrvt("_LRET,M->_CLOJA,M->_CNOMCLI,")

_lRet    := .T.

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+_cCliente, .F.)
	M->_cLoja   := SA1->A1_LOJA
	M->_cNomCli := IIf( !Empty(SA1->A1_NREDUZ), SA1->A1_NREDUZ, Subs( SA1->A1_NOME, 1, 20 ) )
Else
	_lRet := .F.
EndIf

Return(_lRet)