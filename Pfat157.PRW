#include "rwmake.ch"
/* 20030711
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFAT157   �Autor  �Danilo C S Pala     � Data �  20030703   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para gerar ZZE dos Orgaos Publicos repassados pela���
���          � TMKT em 20030703                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Pfat157()

Private _cTitulo  := "Inserir em ZZE:Orgaos Publicos"
Private _ccMens1  := "Fontes: \siga\arqass\zze_op.dbf e OPTMKT.DBF"
Private cTexto1 := "Cruzar"
Private cTexto2 := "Processar ZZS"     
pRIVATE cTexto3 := "Cliente Pini" 
Private cTexto4 := "Vigencia ZZE_OP"
Private nContaZ := 0
Private nContaY := 0
Private nContaX := 0
Private nContaW := 0
Private nContaV := 0
Private nContaN1 := 0       
Private nContaN2 := 0
SetPrvt("_cID, _cCODCLI, _cREFPROC, _cNUMPEDIDO")
SetPrvt("cChave, cFiltro, cIndex")
SetPrvt("cChaveZ, cFiltroZ, cIndexZ, cMSGALERTA")
SetPrvt("_opID, _cProduto, _nValorASS, _edicaovenc")


@ 010,001 TO 150,280 DIALOG oDlg TITLE _cTitulo
@ 005,010 SAY _ccMens1
//@ 030,020 BMPBUTTON TYPE 1 ACTION Processa({||Iniciar()})
@ 030,010 BUTTON cTexto1 SIZE 40,11 ACTION Processa({||Cruzar()})
@ 030,050 BUTTON cTexto2 SIZE 40,11 ACTION Processa({||ProcessarZZS()})
@ 030,100 BMPBUTTON TYPE 2 ACTION ( Close(oDlg) )
@ 045,010 BUTTON cTexto3 SIZE 40,11 ACTION Processa({||XCliente()})    
@ 045,050 BUTTON cTexto4 SIZE 40,11 ACTION Processa({||XVigencia()})
Activate Dialog oDlg CENTERED

Return



//���������������������������������Ŀ
//�Funcao que inicia o processamento�
//�����������������������������������
Static Function Cruzar()

DBUSEAREA(.T.,,"\SIGA\ARQASS\OPTMKT.DBF","OPUBL",.F.,.F.)
DbSElectArea("OPubl")
cIndex  := CriaTrab(nil,.f.)
cChave  := "ID"
cFiltro := ""
IndRegua("OPubl",cIndex,cChave,,cFiltro,"Indexando ...")
Dbgotop()

DBUSEAREA(.T.,,"\SIGA\ARQASS\ZZE_OP.DBF","ZZE_OP",.F.,.F.)
DbSElectArea("ZZE_OP")
cIndexZ  := CriaTrab(nil,.f.)
cChaveZ  := "ID+AllTrim(STR(SEQPAG))+NUMPARC"
cFiltroZ := "DTOS(DT_VENCTO) >= '20021227'"
IndRegua("ZZE_OP",cIndexZ,cChaveZ,,cFiltroZ,"Indexando ...")
Dbgotop()

While !Eof()
	_cCODCLI := ""
	_cNUMPEDIDO := ""
	_cREFPROC := ""
	_cCLIENTE := ""
	_cID := ZZE_OP->ID
	DBSelectArea("OPUBL")
	IF DbSeek(_cID)
		_cCODCLI := OPUBL->ZZ6_CODCLI
		_cCLIENTE := OPUBL->ZZ6_COD
		if (AllTrim(ZZE_OP->CODCLI) <> Alltrim(_cCODCLI))  // codcli diferente
			_cNUMPEDIDO := OPUBL->NOVO_PED
			_cREFPROC := "Y"
			nContaY++
			DBSelectArea("ZZE_OP")
			Atualiza_ZZE_op()
			DbSkip()
			IncProc()
			Loop
		endif
		
		if (ZZE_OP->DT_PAGTO <> CtoD("  /  /  ")) // titulos pagos
			_cNUMPEDIDO := OPUBL->NOVO_PED
			_cREFPROC := "X"
			nContaX++
			DBSelectArea("ZZE_OP")
			Atualiza_ZZE_op()
			DbSkip()
			IncProc()
			Loop
		elseif (AllTrim(OPUBL->NOVO_PED) = "") // titulo nao pago e SEM PEDIDO ASSOCIADO
			_cREFPROC := "W"
			nContaW++
			DBSelectArea("ZZE_OP")
			Atualiza_ZZE_op()
			DbSkip()
			IncProc()
			Loop
		else // titulos para serem inseridos no ZZE
			_cNUMPEDIDO := OPUBL->NOVO_PED
			_cREFPROC := "V"
			nContaV++
			DBSelectArea("ZZE_OP")
			Atualiza_ZZE_op()
			DbSkip()
			IncProc()
			Loop
		endif
		
	ELSE    // id nao encontrado! e dt_vencto >= 20021227
		_cNUMPEDIDO := OPUBL->NOVO_PED
		_cREFPROC := "Z"
		nContaZ++
		DBSelectArea("ZZE_OP")
		Atualiza_ZZE_op()
		DbSkip()
		IncProc()
		Loop
	ENDIF
end

cMsgAlerta := "PROCESSAMENTO FINALIZADO!"+CHR(10)+CHR(13)
cMsgAlerta += "nContaZ = "+ STR(nContaZ)+CHR(10)+CHR(13)
cMsgAlerta += "nContaY = "+ STR(nContaY)+CHR(10)+CHR(13)
cMsgAlerta += "nContaX = "+ STR(nContaX)+CHR(10)+CHR(13)
cMsgAlerta += "nContaW = "+ STR(nContaW)+CHR(10)+CHR(13)
cMsgAlerta += "nContaV = "+ STR(nContaV)+CHR(10)+CHR(13)
MsgAlert(OemToAnsi(cMsgAlerta))

DbSelectArea("Opubl")
DBCloseArea()
DbSelectArea("ZZE_OP")
DBCloseArea()
return



//�������������������������������������������������������Ŀ
//�Atualiza o zze_op com o numero do pedido e a referencia�
//� ao procedimento associado                             �
//���������������������������������������������������������
Static Function Atualiza_zze_op()
RecLock("ZZE_OP",.F.) //update .F.
ZZE_OP->NOVO_PED := Alltrim(_cNumPedido)
ZZE_OP->REF_PROC := _cREFPROC
ZZE_OP->CLIENTE := _cCLIENTE //Cliente da pini
ZZE_OP->VIGENCI := OPUBL->ZZ6_VIGENC // XVigencia
MsUnlock()
return









/* 20030714
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |PROCESSARZZS�Autor  �Microsiga           � Data �  20030704   ���
�������������������������������������������������������������������������͹��
���Desc.     � Le o ZZE_OP e insere os dados no ZZS                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PROCESSARZZS()
nContaN1 := 0
DBSELECTAREA("ZZS")
dbSETORDER(4)

DBUSEAREA(.T.,,"\SIGA\ARQASS\ZZE_OP.DBF","ZZE_OP",.F.,.F.)
DbSElectArea("ZZE_OP")
cIndexZ  := CriaTrab(nil,.f.)
cChaveZ  := "ID+AllTrim(STR(SEQPAG))+NUMPARC"
cFiltroZ := ""
IndRegua("ZZE_OP",cIndexZ,cChaveZ,,cFiltroZ,"Indexando ...")
Dbgotop()


ProcRegua(Reccount())
While !Eof()
	DBSelectArea("ZZS")
	DBSetORder(4)
	RecLock("ZZS",.T.) //update .F.       
	ZZS->ZZS_FILIAL := "01"
	ZZS->ZZS_IDID := ZZE_OP->ID
	ZZS->ZZS_CODCLI := ZZE_OP->CODCLI
	ZZS->ZZS_CLIENT := ZZE_OP->CLIENTE
	ZZS->ZZS_SEQASS := ZZE_OP->SEQASS
	ZZS->ZZS_PRODUT := ZZE_OP->CODPROD
	ZZS->ZZS_VALOR := ZZE_OP->VL_TITULO
	ZZS->ZZS_DTVENC := ZZE_OP->DT_VENCTO
	ZZS->ZZS_DTPAG := ZZE_OP->DT_PAGTO
	ZZS->ZZS_NNUM := ZZE_OP->NOSSONUM
	ZZS->ZZS_NNUM2 := ZZE_OP->NOSSONUM2
	ZZS->ZZS_NNUM3 := ZZE_OP->NOSSONUM3
	ZZS->ZZS_VEND := ZZE_OP->VENDEDOR
	ZZS->ZZS_SEQPAG := ZZE_OP->SEQPAG
	ZZS->ZZS_PARCEL := ZZE_OP->NUMPARC
	ZZS->ZZS_STATUS := ZZE_OP->STATPAG
	ZZS->ZZS_PEDIDO := ZZE_OP->NOVO_PED         
	ZZS->ZZS_VIGENC := ZZE_OP->VIGENCI // VIGENCIA
	MsUnlock()
	nContaN1++
	
	DBSelectArea("ZZE_OP")
	DbSkip()
	IncProc()
	
end

cMsgAlerta := "PROCESSAMENTO FINALIZADO!"+CHR(10)+CHR(13)
cMsgAlerta += "INSERIDO = "+ STR(nContaN1)+CHR(10)+CHR(13)
MsgAlert(OemToAnsi(cMsgAlerta))
return


/* 20030714 - danilo
*/
Static Function XCliente()
Private XID := space(6)
nContaN1 := 0

DBUSEAREA(.T.,,"\SIGA\ARQASS\OPTMKT.DBF","OPUBL",.F.,.F.)
DbSElectArea("OPubl")
cIndex  := CriaTrab(nil,.f.)
cChave  := "ID"
cFiltro := ""
IndRegua("OPubl",cIndex,cChave,,cFiltro,"Indexando ...")
Dbgotop()

DBUSEAREA(.T.,,"\SIGA\ARQASS\ZZE_OP.DBF","ZZE_OP",.F.,.F.)
DbSElectArea("ZZE_OP")
cIndexZ  := CriaTrab(nil,.f.)
cChaveZ  := "ID+AllTrim(STR(SEQPAG))+NUMPARC"
cFiltroZ := ""
IndRegua("ZZE_OP",cIndexZ,cChaveZ,,cFiltroZ,"Indexando ...")
Dbgotop()
         
ProcRegua(Reccount())
While !Eof()            
	xID := ZZE_OP->ID
	DBSelectArea("OPUBL")
	IF DbSeek(xID)
		RecLock("ZZE_OP",.F.) //update .F.    
		ZZE_OP->CLIENTE := OPUBL->ZZ6_COD         
		MsUnlock()
		nContaN1++
	ENDIF
	DBSelectArea("ZZE_OP")
	DbSkip()
	IncProc()
END   
cMsgAlerta := "PROCESSAMENTO FINALIZADO!"+CHR(10)+CHR(13)
cMsgAlerta += "VIGENCIA: ATUALIZADO = "+ STR(nContaN1)+CHR(10)+CHR(13)
MsgAlert(OemToAnsi(cMsgAlerta))
  
return






/* 20030714 - danilo inserir a vigencia em ZZE_op
*/
Static Function XVigencia()
Private XID := space(6)
nContaN2 := 0
DBUSEAREA(.T.,,"\SIGA\ARQASS\OPTMKT.DBF","OPUBL",.F.,.F.)
DbSElectArea("OPubl")
cIndex  := CriaTrab(nil,.f.)
cChave  := "ID"
cFiltro := ""
IndRegua("OPubl",cIndex,cChave,,cFiltro,"Indexando ...")
Dbgotop()

DBUSEAREA(.T.,,"\SIGA\ARQASS\ZZE_OP.DBF","ZZE_OP",.F.,.F.)
DbSElectArea("ZZE_OP")
cIndexZ  := CriaTrab(nil,.f.)
cChaveZ  := "ID+AllTrim(STR(SEQPAG))+NUMPARC"
cFiltroZ := ""
IndRegua("ZZE_OP",cIndexZ,cChaveZ,,cFiltroZ,"Indexando ...")
Dbgotop()
         
ProcRegua(Reccount())
While !Eof()            
	xID := ZZE_OP->ID
	DBSelectArea("OPUBL")
	IF DbSeek(xID)
		RecLock("ZZE_OP",.F.) //update .F.
		ZZE_OP->VIGENCI := OPUBL->ZZ6_VIGENC		
		MsUnlock()
		nContaN2++
	ENDIF
	DBSelectArea("ZZE_OP")
	DbSkip()
	IncProc()
END   
cMsgAlerta := "PROCESSAMENTO FINALIZADO!"+CHR(10)+CHR(13)
cMsgAlerta += "ATUALIZADO = "+ STR(nContaN2)+CHR(10)+CHR(13)
MsgAlert(OemToAnsi(cMsgAlerta))
  
return