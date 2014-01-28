#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  11/01/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PCUP001()

Local cPorta, cImpresssora, nRet
Private nHdlEcf

cPorta   	:= GetMv("MV_PORTFIS")
cImpressora := GetMv("MV_IMPFIS")

If MsgYesNo("Deseja emitir leitura X?","Confirme")
	nHdlECF := IFAbrir(cImpressora,cPorta)
	nRet    := IFAbrECF(nHdlECF)
	If nRet <> 0
		MsgInfo("Houve falha de comunicacao com a Impressora")
		Return
	EndIf
	nRet    := IFLeituraX(nHdlECF)
	If nRet <> 0 
		MsgInfo("Houve um erro na emissao da leitura X!")
	EndIf
	nRet    := IFFechar(nHdlECF, cPorta)
EndIf

Return