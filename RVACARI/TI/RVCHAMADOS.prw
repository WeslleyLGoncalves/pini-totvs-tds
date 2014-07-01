#INCLUDE "rwmake.ch"

/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���  Chamados de TI                                                           ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/


/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Programa   � NK_ChamaTI� Autor � Cesar A. O. Arneiro    � Data � 15/08/06 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o  � Tela de Chamados de TI.                                      ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Parametros �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Obs        �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Retorno    �                                                              ���
���            �                                                              ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function RVCHAMADOS()

/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Declaracao de Variaveis                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
/*/
Private cCadastro := "Chamados de TI"
Private aRotina   := {	{"Pesquisar" , "AxPesqui"   , 0, 1},;
						{"Visualizar", "AxVisual"   , 0, 2},;
						{"Incluir"   , "AxInclui" , 0, 3},;
						{"Alterar"   , "U_TIAltera" , 0, 4},;
						{"Encerrar"  , "U_TIEncerra", 0, 4},;
						{"Cancelar"  , "U_TICancela", 0, 4},;
						{"Legenda"   , "U_TILegenda", 0, 2}  }

Private cDelFunc := ".T."	// Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cAlias   := "ZX1"

aCores := {{"ZX1->ZX1_STATUS == '1'", "BR_VERDE"}, {"ZX1->ZX1_STATUS == '2'", "BR_VERMELHO"}, {"ZX1->ZX1_STATUS == '3'", "BR_AMARELO"}}

ZX1->(dbSetOrder(1))

mBrowse(6, 1, 22, 105, cAlias, , , , , 2, aCores)

Return


/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Programa   � TIAltera  � Autor � Cesar A. O. Arneiro    � Data � 15/08/06 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o  � Altera o chamado de TI.                                      ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Parametros �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Obs        �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Retorno    �                                                              ���
���            �                                                              ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function TIAltera(cAlias, nReg, nOpc)

Local _MEMO    := " "
Local aArea    := GetArea()
Local aAreaSZ4 := ZX1->(GetArea())

If ZX1->ZX1_STATUS != "1"
	MsgStop("O chamado n�o est� pendente, portanto n�o � poss�vel alter�-lo!", "Opera��o N�o Permitida")
	Return
EndIf

nOpca := 0
nOpca := AxAltera(cAlias, nReg, nOpc, , , , , ".T.")

RestArea(aAreaSZ4)
RestArea(aArea)

Return


/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Programa   � TICancela � Autor � Cesar A. O. Arneiro    � Data � 15/08/06 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o  � Cancela o chamado de TI.                                     ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Parametros �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Obs        �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Retorno    �                                                              ���
���            �                                                              ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function TICancela()

Local lResp

If ZX1->ZX1_STATUS != "1"
	Alert("O chamado n�o est� pendente!")
	Return
EndIf

lResp := MsgYesNo("Confirma Cancelamento do Chamado?")

If lResp
	RecLock("SZ4", .F.)
		ZX1->ZX1_DTENC  := dDataBase
		ZX1->ZX1_HRENC  := SubStr(Time(), 1, 5)                                                                                                              
		ZX1->ZX1_STATUS := "3"	// Cancelado
	MsUnlock()
EndIf

Return


/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Programa   � TIEncerra � Autor � Cesar A. O. Arneiro    � Data � 15/08/06 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o  � Encerra o chamado de TI.                                     ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Parametros �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Obs        �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Retorno    �                                                              ���
���            �                                                              ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function TIEncerra()

Local dEncTI  := dDataBase
Local cHoraTI := SubStr(Time(), 1, 5)
Local lResp   := .F.
Local oDlgEnc, oSay1, oGetData, oSay3, oGetHora, oGrp5, oSBtn7, oBtnCancel

If ZX1->ZX1_STATUS != "1"
	Alert("O chamado n�o est� pendente!")
	Return
EndIf

oDlgEnc           := MsDialog():Create()
oDlgEnc:cName     := "oDlgEnc"
oDlgEnc:cCaption  := "Encerramento"
oDlgEnc:nLeft     := 0
oDlgEnc:nTop      := 0
oDlgEnc:nWidth    := 194
oDlgEnc:nHeight   := 176
oDlgEnc:lShowHint := .F.
oDlgEnc:lCentered := .T.

oSay1                 := TSay():Create(oDlgEnc)
oSay1:cName           := "oSay1"
oSay1:cCaption        := "Data:"
oSay1:nLeft           := 26
oSay1:nTop            := 35
oSay1:nWidth          := 37
oSay1:nHeight         := 17
oSay1:lShowHint       := .F.
oSay1:lReadOnly       := .F.
oSay1:Align           := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap       := .F.
oSay1:lTransparent    := .F.

oGetData                 := TGet():Create(oDlgEnc)
oGetData:cName           := "oGetData"
oGetData:nLeft           := 64
oGetData:nTop            := 32
oGetData:nWidth          := 80
oGetData:nHeight         := 21
oGetData:lShowHint       := .F.
oGetData:lReadOnly       := .F.
oGetData:Align           := 0
oGetData:cVariable       := "dEncTI"
oGetData:bSetGet         := {|u| If(PCount() > 0, dEncTI := u, dEncTI)}
oGetData:lVisibleControl := .T.
oGetData:lPassword       := .F.
oGetData:Picture         := "@D"
oGetData:lHasButton      := .T.

oSay3                 := TSay():Create(oDlgEnc)
oSay3:cName           := "oSay3"
oSay3:cCaption        := "Hora:"
oSay3:nLeft           := 26
oSay3:nTop            := 65
oSay3:nWidth          := 37
oSay3:nHeight         := 17
oSay3:lShowHint       := .F.
oSay3:lReadOnly       := .F.
oSay3:Align           := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap       := .F.
oSay3:lTransparent    := .F.

oGetHora                 := TGet():Create(oDlgEnc)
oGetHora:cName           := "oGetHora"
oGetHora:nLeft           := 64
oGetHora:nTop            := 62
oGetHora:nWidth          := 80
oGetHora:nHeight         := 21
oGetHora:lShowHint       := .F.
oGetHora:lReadOnly       := .F.
oGetHora:Align           := 0
oGetHora:cVariable       := "cHoraTI"
oGetHora:bSetGet         := {|u| If(PCount() > 0, cHoraTI := u, cHoraTI)}
oGetHora:lVisibleControl := .T.
oGetHora:lPassword       := .F.
oGetHora:Picture         := "99:99"
oGetHora:lHasButton      := .F.

oGrp5                 := TGroup():Create(oDlgEnc)
oGrp5:cName           := "oGrp5"
oGrp5:nLeft           := 14
oGrp5:nTop            := 21
oGrp5:nWidth          := 151
oGrp5:nHeight         := 74
oGrp5:lShowHint       := .F.
oGrp5:lReadOnly       := .F.
oGrp5:Align           := 0
oGrp5:lVisibleControl := .T.

oSBtn7                 := SButton():Create(oDlgEnc)
oSBtn7:cName           := "oSBtn7"
oSBtn7:cCaption        := "OK"
oSBtn7:nLeft           := 39
oSBtn7:nTop            := 105
oSBtn7:nWidth          := 55
oSBtn7:nHeight         := 22
oSBtn7:lShowHint       := .F.
oSBtn7:lReadOnly       := .F.
oSBtn7:Align           := 0
oSBtn7:lVisibleControl := .T.
oSBtn7:nType           := 1
oSBtn7:bLClicked       := {|| lResp := .T., oDlgEnc:End()}

oBtnCancel                 := SButton():Create(oDlgEnc)
oBtnCancel:cName           := "oBtnCancel"
oBtnCancel:cCaption        := "Cancelar"
oBtnCancel:nLeft           := 110
oBtnCancel:nTop            := 105
oBtnCancel:nWidth          := 55
oBtnCancel:nHeight         := 22
oBtnCancel:lShowHint       := .F.
oBtnCancel:lReadOnly       := .F.
oBtnCancel:Align           := 0
oBtnCancel:lVisibleControl := .T.
oBtnCancel:nType           := 2
oBtnCancel:bLClicked       := {|| oDlgEnc:End()}

oDlgEnc:Activate()

If lResp
	RecLock("SZ4", .F.)
		ZX1->ZX1_DTENC  := dEncTI
		ZX1->ZX1_HRENC  := cHoraTI                                                                                                        
		ZX1->ZX1_STATUS := "2"	// Encerrado
	MsUnlock()
EndIf

Return


/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Programa   � TILegenda � Autor � Cesar A. O. Arneiro    � Data � 15/08/06 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o  � Exibe as legendas do browse.                                 ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Parametros �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Obs        �                                                              ���
���            �                                                              ���
�����������������������������������������������������������������������������Ĵ��
��� Retorno    �                                                              ���
���            �                                                              ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function TILegenda()

BrwLegenda(cCadastro, "Legenda", {	{"BR_VERDE"   , "Chamado Pendente" },;
									{"BR_VERMELHO", "Chamado Encerrado"},;
									{"BR_AMARELO" , "Chamado Cancelado"}  })

Return