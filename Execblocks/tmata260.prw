#INCLUDE "rwmake.ch"                       
#include "topconn.ch"

// Transferencia entre almoxarifados / localizacoes          
User function Tmata260()
setprvt("cQuery, nTotal, nQtd, cTrans, nTotTrans, nQtdIdeal, nEstoque, nVend30, nQtdRSite, nSaldoLS, nSaldoIDEAL")

//��������������������������������������������������������������Ŀ
//� Pega a variavel que identifica se o calculo do custo e' :    �
//�               O = On-Line                                    �
//�               M = Mensal                                     �
//����������������������������������������������������������������
PRIVATE cCusMed  := GetMv("MV_CUSMED")
//PRIVATE cCadastro:= OemToAnsi(STR0001)	//"Transfer�ncias"
PRIVATE aRegSD3  := {}
//��������������������������������������������������������������Ŀ
//� Verifica se o custo medio e' calculado On-Line               �
//����������������������������������������������������������������
If cCusMed == "O"
	PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst 	// Numero do lote para lancamentos do estoque
	//��������������������������������������������������������������Ŀ
	//� Posiciona numero do Lote para Lancamentos do Faturamento     �
	//����������������������������������������������������������������
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
EndIf
/*
//para estorno passar o 15o. par�metro com .T.
//Function a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A260Processa  � Eveli Morasco             � Data � 16/01/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento da inclusao                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC01: Codigo do Produto Origem - Obrigatorio              ���
���          �ExpC02: Almox Origem             - Obrigatorio              ���
���          �ExpN01: Quantidade 1a UM         - Obrigatorio              ���
���          �ExpC03: Documento                - Obrigatorio              ���
���          �ExpD01: Data                     - Obrigatorio              ���
���          �ExpN02: Quantidade 2a UM                                    ���
���          �ExpC04: Sub-Lote                 - Obrigatorio se Rastro "S"���
���          �ExpC05: Lote                     - Obrigatorio se usa Rastro���
���          �ExpD02: Validade                 - Obrigatorio se usa Rastro���
���          �ExpC06: Numero de Serie                                     ���
���          �ExpC07: Localizacao Origem                                  ���
���          �ExpC08: Codigo do Produto Destino- Obrigatorio              ���
���          �ExpC09: Almox Destino            - Obrigatorio              ���
���          �ExpC10: Localizacao Destino                                 ���
���          �ExpL01: Indica se movimento e estorno                       ���
���          �ExpN03: Numero do registro original (utilizado estorno)     ���
���          �ExpN04: Numero do registro destino (utilizado estorno)      ���
���          �ExpC11: Indicacao do programa que originou os lancamentos   ���
���          �ExpC12: cEstFis    - Estrutura Fisica          (APDL)       ���
���          �ExpC13: cServico   - Servico                   (APDL)       ���
���          �ExpC14: cTarefa    - Tarefa                    (APDL)       ���
���          �ExpC15: cAtividade - Atividade                 (APDL)       ���
���          �ExpC16: cAnomalia  - Houve Anomalia? (S/N)     (APDL)       ���
���          �ExpC17: cEstDest   - Estrututa Fisica Destino  (APDL)       ���
���          �ExpC18: cEndDest   - Endereco Destino          (APDL)       ���
���          �ExpC19: cHrInicio  - Hora Inicio               (APDL)       ���
���          �ExpC20: cAtuEst    - Atualiza Estoque? (S/N)   (APDL)       ���
���          �ExpC21: cCarga     - Numero da Carga           (APDL)       ���
���          �ExpC22: cUnitiza   - Numero do Unitizador      (APDL)       ���
���          �ExpC23: cOrdTar    - Ordem da Tarefa           (APDL)       ���
���          �ExpC24: cOrdAti    - Ordem da Atividade        (APDL)       ���
���          �ExpC25: cRHumano   - Recurso Humano            (APDL)       ���
���          �ExpC26: cRFisico   - Recurso Fisico            (APDL)       ���
���          �ExpN05: nPotencia  - Potencia do Lote                       ���
���          �ExpC27: cLoteDest  - Lote Destino da Transferencia          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Transferencia                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



DbSelectArea("SB1")  
cQuery :=  "select b1_cod, b1_desc, b1_locpad, to_char(f_saldo_almox(b1_cod,b1_locpad)) as saldo, b1_qtdidea, b1_qtdrsit, b1_flagsit, to_char(f_saldo_almox(b1_cod,'LS')) as saldoLS, to_char(f_vend30_almox(b1_cod,'LS', '"+ dtos(ddatabase) +"')) as VEND30 from sb1010 where b1_filial='  ' and b1_flagsit='T' and sb1010.d_e_l_e_t_<>'*'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'PRODSITE', .F., .T.)
//TcSetField("PRODSITE","SALDO"   ,"N",9)
//TcSetField("PRODSITE","SALDOLS" ,"N",9)
dbselectarea("PRODSITE")
dbGoTop()              
             
nTotal := 0
nQtd := 0
cTrans := "N"
nTotTrans := 0
/* Regra:
M= qtd ideal - qtd reservada(ja vendido)
0) Se M > E(LS) ent�o:
1) Se S(T5 ou T6) >= M ent�o E(LS) = (M - E(LS))
2) Senao E(LS)= S(T5 ou T6) - E(LS) */     



while !eof() 
	nVend30   := val(alltrim(PRODSITE->Vend30)) ////20090218     
	nEstoque  := val(alltrim(PRODSITE->SALDO)) ////20090218     
	nQtdRSite := PRODSITE->B1_QTDRSIT ////20090219     
	nSaldoLS  := val(PRODSITE->SALDOLS) //20090219
	nEstoque  := (nEstoque + nSaldoLS) - nQtdRSite  //(a nQtdRSite ja foi vendido pelo site, falta apenas faturar)
	nQtdIdeal := CalculaQtdIdela(nEstoque, nVend30 ) //20090218 
	nTotal    := nTotal + 1
	DBSelectArea("SB1")
    dbSetOrder(1)
    dbSeek(xFilial("SB1")+PRODSITE->B1_COD)
    Reclock("SB1",.f.) //update
		replace B1_QTDIDEA WITH  nQtdIdeal
	MSUnlock()
	
	dbselectarea("PRODSITE")	
	//nQtd      := 0
	
/*	if PRODSITE->B1_MEDSITE > val(PRODSITE->SALDOLS)
		if val(PRODSITE->SALDO) >= PRODSITE->B1_MEDSITE //PRODSITE->B1_MEDSITE >=3 .and. 
			nQtd :=	(PRODSITE->B1_MEDSITE - val(PRODSITE->SALDOLS))
			cTrans := "S"
		else //if PRODSITE->B1_MEDSITE >val(PRODSITE->SALDO) //.and. val(PRODSITE->SALDO) <= 2
			nQtd :=	(val(PRODSITE->SALDO) - val(PRODSITE->SALDOLS))
			cTrans := "S"
        //else        
    	//	nQtd :=	0
    	//	cTrans := "N" //
		endif
	else             
		nQtd :=	0
		cTrans := "N"
	endif		
	if cTrans == "S" .and. nQtd > 0
		nTotTrans := nTotTrans + 1
	  a260Processa(cCodOrig         ,cLocOrig             ,nQuant260,cDocto  ,dEmis260  ,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest          ,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma  ,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)	
	  a260Processa("02021752       ","T5"                 ,1        ,space(6), ddatabase,0         ,""     ,""       ,ddatabase,""      ,""        ,"02021752       "  ,"T6"    ,""       ,.F.      ,0      ,0      ,       ""    ,""     ,""      ,""     ,""        ,""       ,""      ,""      ,""       ,"N"    ,""    ,""      ,""     ,""     ,""      ,""      ,0        ,"")
	  	a260Processa(PRODSITE->B1_COD ,PRODSITE->B1_LOCPAD ,NQTD     ,space(6), ddatabase,0         ,""     ,""       ,ddatabase,""      ,""        ,PRODSITE->B1_COD,"LS"    ,""       ,.F.      ,0      ,0      , "U_TMATA260",""     ,""      ,""     ,""       ,""       ,""      ,""      ,""       ,"N"    ,""    ,""     ,""     ,""     ,""      ,""      ,0        ,"")
	endif		*/
	
	nSaldoIDEAL := nQtdIdeal + nQtdRSite  //(a nQtdRSite ja foi vendido pelo site, falta apenas faturar, por isso compoe o saldo em LS)
	if nSaldoIDEAL == nSaldoLS
		nQtd   := 0
		cTrans := "N" 
	elseif nSaldoIDEAL > nSaldoLS //enviar mais para LS
		nQtd   := nSaldoIDEAL -  nSaldoLS
		cTrans := "E"
		nTotTrans := nTotTrans + 1
	    a260Processa(PRODSITE->B1_COD ,PRODSITE->B1_LOCPAD ,NQTD     ,space(6), ddatabase,0         ,""     ,""       ,ddatabase,""      ,""        ,PRODSITE->B1_COD,"LS"    ,""       ,.F.      ,0      ,0      , "U_TMATA260",""     ,""      ,""     ,""       ,""       ,""      ,""      ,""       ,"N"    ,""    ,""     ,""     ,""     ,""      ,""      ,0        ,"")
	else //retornar para T5 ou T6
		nQtd   := nSaldoLS - nSaldoIDEAL
		cTrans := "R"
		nTotTrans := nTotTrans + 1
	    a260Processa(PRODSITE->B1_COD ,"LS" ,NQTD     ,space(6), ddatabase,0         ,""     ,""       ,ddatabase,""      ,""        ,PRODSITE->B1_COD ,PRODSITE->B1_LOCPAD   ,""       ,.F.      ,0      ,0      , "U_TMATA260",""     ,""      ,""     ,""       ,""       ,""      ,""      ,""       ,"N"    ,""    ,""     ,""     ,""     ,""      ,""      ,0        ,"")
	endif

	dbselectarea("PRODSITE")
	dbskip()
end
       
DBCloseArea("PRODSITE")
Public cbody := "Atualizacao de saldos no almoxarifado LS. Processados: "+ alltrim(str(nTotal)) + ".  Transferidos de almoxarifados: " + alltrim(str(nTotTrans))
u_semail(cbody, "TMATA260", "dpala@pini.com.br")
return


Static Function CalculaQtdIdela(nEstoque, nVend30)
Private qtd_ideal := 0

if nEstoque >=60 
	qtd_ideal := noround(nEstoque / 2,0)
elseif nEstoque <60 .and. nEstoque >=40
	qtd_ideal := 20
elseif nEstoque <40 .and. nEstoque >=20
	qtd_ideal := 12
elseif nEstoque <20 .and. nEstoque >=10
	qtd_ideal := 6
elseif nEstoque <10 .and. nEstoque >2
	qtd_ideal := 3
elseif nEstoque <=2 //2 ou 1
	if nVend30 = 0 
		qtd_ideal := 0
	else
		qtd_ideal := nEstoque
	endif
endif
/*20	SE 40<ESTOQUE<60	
12	SE 20<ESTOQUE<40	
6	SE 10<ESTOQUE<20	
3	SE 2<Estoque<10	
ou		
2	SE ESTOQUE=2	
		
ou		
1	SE ESTOQUE=1	
ou		
1	SE VENDA = 0 NOS �LTIMOS 30 DIAS
ou	
0	SE ESTOQUE =0
ou	
N	N = m�ximo (venda do dia anterior) x (venda m�dia dos �ltimos 2 dias) x (venda m�dia dos �ltimos 30 dias)*/

return qtd_ideal