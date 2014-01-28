#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATA09V  �Autor: Roger Cangianeli       � Data:   26/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Validacao da Get Dados na Manutencao do SZV                � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Valida no ExecBlock RFATA09                                � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fat9vg03()
Local aArea := GetArea()
SetPrvt("_CALIAS,_NINDEX,_NREG,_LRET,_NPOSPAR,_CSTR")
SetPrvt("_NVEZES,_CMSG,")



_lRet   := .T.

_nPosPar:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZV_NPARC"})
_cStr   := M->ZV_NPARC

For _nVezes := 1 to Len(aCols)
    If aCols[_nVezes,_nPosPar] == _cStr .and. _nVezes #n
        _cMsg   := "Item / Insercao ja digitados na linha "+ Str(_nVezes)+ " !"
        _lRet   := .F.
        MsgStop(_cMsg, " Atencao ")
        Exit
    EndIf
Next

RestArea(aArea)

Return(_lRet)