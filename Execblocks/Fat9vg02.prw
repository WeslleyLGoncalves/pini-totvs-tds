#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: FAT9VG02  �Autor: Roger Cangianeli       � Data:   26/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Validacao da Get Dados na Manutencao do SZV                � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Valida no ExecBlock RFATA09, VALIDACAO GERAL DA GET DADOS  � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fat9vg02() 
Local aArea := GetArea()

SetPrvt("_CALIAS,_NINDEX,_NREG,_LRET,_CMSG,ACOLS")


_lRet   := .T.

If Len(aCols) #_nTotParc .and. nOpcx == 3
	If Len(aCols) < _nTotParc
		_cMsg   := "Nao Foram Incluidas Todas as Parcelas ! Verifique."
        _lRet   := .F.
	Else
		_cMsg   := "Foram incluidas MAIS parcelas que o Total de Parcelas digitado ! As demais serao DESCONSIDERADAS."
        aCols[n,Len(aHeader)+1] := .T.
	EndIf
	MsgBox(_cMsg, " Atencao ", "STOP")
EndIf

RestArea(aArea)

Return(_lRet)