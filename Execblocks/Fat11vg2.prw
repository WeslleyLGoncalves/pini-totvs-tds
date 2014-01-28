#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: FAT11VG2  �Autor: Roger Cangianeli       � Data:   07/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Validacao da Get Dados na Manutencao do SZS                � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Valida no ExecBlock RFATA11, VALIDACAO GERAL DA GET DADOS  � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fat11vg2()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

SetPrvt("_CALIAS,_NINDEX,_NREG,_LRET,_CMSG,")

_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()
_lRet   := .T.

/*/
If Len(aCols) #_nTotParc .and. nOpcx == 3
    _lRet   := .F.
    If Len(aCols) < _nTotParc
        _cMsg   := "Nao Foram Incluidas Todas as Parcelas ! Verifique."
    Else
        _cMsg   := "Foram incluidas MAIS parcelas que o Total de Parcelas digitado ! As demais serao DESCONSIDERADAS."
    EndIf
    #IFDEF WINDOWS
        MsgBox(_cMsg, " Atencao ", "STOP")
    #ELSE
        Alert(_cMsg)
    #ENDIF
EndIf
/*/

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return(_lRet)