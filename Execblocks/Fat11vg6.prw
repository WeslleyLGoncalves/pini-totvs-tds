#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa:  FAT11VG6 �Autor: Roger Cangianeli       � Data:   07/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Validacao da Get Dados na Manutencao do SZS                � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Valida no ExecBlock RFATA11, Campo EDICAO                  � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fat11vg6()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

SetPrvt("_CALIAS,_NINDEX,_NREG,_LRET,_NPOSDTC,_NPOSDTL")
SetPrvt("_NPOSREV,_CCODREV,_CMSG,ACOLS,M->ZS_EDICAO,")

_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()
_lRet   := .T.
_nPosDTC:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZS_DTCIRC"})
_nPosDTL:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZS_LIBPROG"})
_nPosRev:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZS_CODREV"})

_cCodRev:= aCols[n,_nPosRev]

If !(AllTrim(_cCodRev) == "0320" .or. AllTrim(_cCodRev) == "0321" .or. AllTrim(_cCodRev) == "0322")
    _cCodRev:= IIf( Subs(_cCodRev, 1, 2) == "03", "01"+Subs(_cCodRev, 3, 2), _cCodRev )
Endif

dbSelectArea("SZJ")
dbSetOrder(1)
If !dbSeek(xFilial("SZJ")+_cCodRev+Str(M->ZS_EDICAO,4), .F.) .and. M->ZS_EDICAO #0
    _cMsg := "Edicao Nao Encontrada no Cronograma ! Verifique."
    aCols[n,_nPosDTC] := stod("")
    aCols[n,_nPosDTL] := stod("")
    M->ZS_EDICAO := 0
	_lRet := .F.

ElseIf !dbSeek(xFilial("SZJ")+_cCodRev+Str(M->ZS_EDICAO,4), .F.) .and. M->ZS_EDICAO == 0
    aCols[n,_nPosDTC] := stod("")
    aCols[n,_nPosDTL] := stod("")
    M->ZS_EDICAO := 0

Else
    aCols[n,_nPosDTC] := SZJ->ZJ_DTCIRC
    aCols[n,_nPosDTL] := SZJ->ZJ_DTCIRC

EndIf

If !_lRet
	MsgStop(_cMsg, " Atencao ")
EndIf

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return(_lRet)