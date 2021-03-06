#INCLUDE "rwmake.ch"                       
#include "topconn.ch"
#include "tbiconn.ch"

/*/
//Danilo C S Pala 20120127: Novo Controle de Poder de Terceiros (Cicero/Mar)
//Danilo C S Pala 20120320: Qtd de armazenagem no index 8 (Odirlei) 
//Danilo C S Pala 20120529: Verificar se pedido ja foi faturado(Eliana)
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATPINI02  � Autor � Marcio Torresson   � Data �  14/08/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Primeira tela de gera��o de dados para a gera��o das NF's  ���
���          � de retorno e de emiss�o cliente                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ATPINI02()

Local aCores    := {{'Empty(ZZY_OK)', 'ENABLE'    },; // EM ABERTO
	                {'ZZY_OK=="OK"' , 'DISABLE'   },; // ENCERRADO O PODER 3�
	                {'ZZY_OK=="QT"' , 'BR_AZUL'   },; // TRANSPORTADO TOTAL OU PARCIAL
	                {'ZZY_OK=="QA"' , 'BR_AMARELO'},; // ARMAZENADO PARCIAL
	                {'ZZY_OK=="QV"' , 'BR_MARRON' },; // VENDA PARCIAL
	                {'ZZY_OK=="VT"' , 'BR_CINZA'  },; // VENDA E TRANSPORTE PARCIAL
	                {'ZZY_OK=="TA"' , 'BR_LARANJA'},; // TRANSPORTE E ARMAZENAGEM PARCIAL
	                {'ZZY_OK=="VA"' , 'BR_PINK'   },; // VENDA E ARMAZENAGEM PARCIAL
                    {'ZZY_OK=="TP"' , 'BR_PRETO'  }}  // VENDA, TRANSPORTE E ARMAZENAGEM PARCIAL

Private cCadastro := "Gera��o de NFs de Devolu��o e Venda"
Public cConsEmp := "X"
cperg := "PINICE01"
ValidConsEmp()
if !Pergunte(cPerg,.t.)
	return
endif

if mv_par01==1
	cConsEmp := "C" //Consignacao
elseif mv_par01==2
	cConsEmp := "E" //Emprestimo 
	MsgAlert("Esta op��o foi desabilitada, o programa considerar� Exposi��o") //desabilitar 20110815
	cConsEmp := "X" //Exposicao desabilitar 20110815
else
	cConsEmp := "X" //Exposicao
endif

if cConsEmp ="E" //20100317                               
	cCadastro := "Gera��o de NFs de Devolu��o e Venda: EMPRESTIMO"
elseif cConsEmp ="C"
	cCadastro := "Gera��o de NFs de Devolu��o e Venda: CONSIGNACAO"
else
	cCadastro := "Gera��o de NFs de Devolu��o e Venda: EXPOSICAO"
endif


Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := ""
Private cFiltro1 := "" //mp10
Private cFiltro2 := "" //mp10
Private cFiltro3 := "" //mp10

Private cPerg := "TELA01"
Private cCod01Ven := space(06)
Private cCod02Ven := space(06)
Private cCod03NF := space(09)
Private cCod04NF := space(09)
Private cCod07Baixa := 1
Private cNomeModulo := CARQREL

if cNomeModulo=="SIGAFAT.REW" //_nomeexec == "SIGAFAT.EXE"  //20130215
	Private aRotina := {{"Visualizar"    ,"AxVisual"       ,0,2},;
                    {"Pesquisa"      ,"AxPesqui"       ,0,1},;
                    {"Gera Pedido"   ,"U_GeraPedido(1)",0,4},; 
                    {"Log"   ,"U_PINIRLP3()",0,4},; 
					{"Legenda"       ,"U_Colores()"    ,0,2}}                    
elseif cNomeModulo=="SIGACOM.REW" //_nomeexec == "SIGACOM.EXE" //20130215
	Private aRotina := {{"Visualizar"    ,"AxVisual"       ,0,2},;
                    {"Pesquisa"      ,"AxPesqui"       ,0,1},;
             		{"Gera NF Transp","U_GeraPedido(2)",0,4},;
					{"Gera NF Armaz" ,"U_GeraPedido(3)",0,4},;	
					{"Gera NF Simbo" ,"U_GeraPedido(4)",0,4},;	
					{"Log"   ,"U_PINIRLP3()",0,4},; 
					{"Legenda"       ,"U_Colores()"    ,0,2}}                    
endif

dbselectarea("SZ9")
dbsetorder(1)

ValidPerg()

if !Pergunte(cPerg,.t.)   
	return
endif

cCod01Ven := mv_par01
cCod02Ven := mv_par02
cCod03NF   := mv_par03
cCod04NF  := mv_par04
cCod07Baixa := mv_par07

Processa({|| U_Preparando() },"Preparando Dados")

dbselectarea("TRB")
dbclosearea()

cString := "ZZY"

dbSelectArea(cString)
/*if cCod07Baixa == 2 //mp10 daqui
   set filter to zzy->zzy_ok <> "OK"
elseif !empty(cCod01Ven) .and. (substr(cCod02Ven,1,3) <> "zzz" .or. substr(cCod02Ven,1,3) <> "ZZZ")
   set filter to zzy->zzy_client >= cCod01Ven .and. zzy->zzy_client <= cCod02Ven
elseif !empty(cCod03NF) .and. (substr(cCod04NF,1,3) <> "zzz" .or. substr(cCod04NF,1,3)<> "ZZZ")
	set filter to zzy->zzy_doc >= cCod03NF .and. zzy->zzy_doc <= cCod04NF
else
   set filter to
endif    */ 
cFiltro1 := ""
cFiltro2 := ""
cFiltro3 := ""
if cCod07Baixa == 2
	cFiltro1 := "S"
endif
if !empty(cCod01Ven) .and. (substr(cCod02Ven,1,3) <> "zzz" .or. substr(cCod02Ven,1,3) <> "ZZZ")
	cFiltro2 := "S"
endif
if !empty(cCod03NF) .and. (substr(cCod04NF,1,3) <> "zzz" .or. substr(cCod04NF,1,3)<> "ZZZ")
	cFiltro3 := "S"
endif           

if cFiltro1="S" .and. cFiltro2="" .and. cFiltro3=""
	set filter to zzy->zzy_ok <> "OK"
elseif cFiltro1="S" .and. cFiltro2="S" .and. cFiltro3=""
	set filter to zzy->zzy_ok <> "OK" .and. zzy->zzy_client >= cCod01Ven .and. zzy->zzy_client <= cCod02Ven
elseif cFiltro1="S" .and. cFiltro2="S" .and. cFiltro3="S"
	set filter to zzy->zzy_ok <> "OK" .and. zzy->zzy_client >= cCod01Ven .and. zzy->zzy_client <= cCod02Ven .and. zzy->zzy_doc >= cCod03NF .and. zzy->zzy_doc <= cCod04NF
elseif cFiltro1="" .and. cFiltro2="S" .and. cFiltro3=""
	set filter to zzy->zzy_client >= cCod01Ven .and. zzy->zzy_client <= cCod02Ven
elseif cFiltro1="" .and. cFiltro2="S" .and. cFiltro3="S"
	set filter to zzy->zzy_client >= cCod01Ven .and. zzy->zzy_client <= cCod02Ven .and. zzy->zzy_doc >= cCod03NF .and. zzy->zzy_doc <= cCod04NF
elseif cFiltro1="" .and. cFiltro2="" .and. cFiltro3="S"	
	set filter to zzy->zzy_doc >= cCod03NF .and. zzy->zzy_doc <= cCod04NF
endif //ate aqui mp10

mBrowse(6,1,22,75,cString,,,,,,aCores)

Return                                                              

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Colores   � Autor � Marcio Torresson     � Data � 07.10.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria uma janela contendo a legenda da mBrowse              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � ATPINI02                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Colores()
Local aLegenda := {{"ENABLE"    ,"Em Aberto - Sem Movimenta��o"            },; 
	               {"DISABLE"   ,"Encerradas - Venda ou Armazenagem Total" },; 
	               {"BR_AZUL"   ,"Transporte Total ou Parcial"             },; 
	               {"BR_AMARELO","Armazenagem Parcial"                     },;
	               {"BR_MARRON" ,"Venda Parcial"                           },;
	               {"BR_CINZA"  ,"Venda e Transporte Parcial"              },;
	               {"BR_LARANJA","Transporte e Armazenagem Parcial"        },;
	               {"BR_PINK"   ,"Venda e Armazenagem Parcial"             },;
	               {"BR_PRETO"  ,"Venda, Transporte e Armazenagem Parcial" }} 

BrwLegenda(cCadastro,"Legendas",aLegenda) //"Legenda"

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Preparando�Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Preparando dados no arquivo zzy para novos processos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Preparando()

Local nTotal  := 0
Local nFeito  := 0

ProcRegua(1)

incproc("Este processo ir� demorar alguns minutos, Aguarde !!!")

cQuery := "SELECT D2_ITEM,B6_ATEND,D2_CLIENTE,D2_LOJA,A1_NOME,D2_DOC,D2_SERIE,D2_COD,B1_DESC,D2_ITEMPV,C6_QTDVEN,"
cQuery += "D2_QUANT,B6_SALDO,B6_PRUNIT FROM "+RETSQLNAME("SD2")+" SD2,"+RETSQLNAME("SB6")+" SB6,"+RETSQLNAME("SA1")+" SA1,"
cQuery += RETSQLNAME("SC6")+" SC6,"+RETSQLNAME("SB1")+" SB1"
if !empty(mv_par01) .and. (substr(mv_par02,1,3) <> "zzz" .or. substr(mv_par02,1,3) <> "ZZZ")
	cQuery += " WHERE SD2.D2_CLIENTE >= '"+MV_PAR01+"' AND SD2.D2_CLIENTE <= '"+MV_PAR02+"' AND"
else
	cQuery += " WHERE"
endif
if !empty(mv_par03) .and. (substr(mv_par04,1,3) <> "zzz" .or. substr(mv_par04,1,3)<> "ZZZ")
	cQuery += " SD2.D2_DOC >= '"+MV_PAR03+"' AND SD2.D2_DOC <= '"+MV_PAR04+"' AND"
endif
cQuery += " SD2.D2_EMISSAO >= '"+DTOS(MV_PAR05)+"' AND SD2.D2_EMISSAO <= '"+DTOS(MV_PAR06)+"' AND SD2.D2_IDENTB6 <> '"+space(06)+"'"
cQuery += " AND SD2.D_E_L_E_T_ <> '*'"

cQuery += " AND SB6.B6_FILIAL = SD2.D2_FILIAL AND SB6.B6_PRODUTO = SD2.D2_COD AND SB6.B6_CLIFOR = SD2.D2_CLIENTE"
cQuery += " AND SB6.B6_LOJA = SD2.D2_LOJA AND SB6.B6_IDENT = SD2.D2_IDENTB6"
cQuery += " AND SB6.B6_ATEND <> 'S' AND SB6.B6_SALDO > 0 AND SB6.D_E_L_E_T_ <> '*'"

cQuery += " AND SA1.A1_FILIAL = '"+xfilial("SA1")+"' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA"
cQuery += " AND SA1.D_E_L_E_T_ <> '*'"

cQuery += " AND SB1.B1_FILIAL = '"+xfilial("SB1")+"' AND SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ <> '*'"

cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_ITEM = SD2.D2_ITEMPV"
cQuery += " AND SC6.C6_PRODUTO = SD2.D2_COD AND SC6.D_E_L_E_T_ <> '*'"

cQuery += " ORDER BY D2_CLIENTE,D2_DOC"

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

cString := "TRB"

dbSelectArea(cString)

dbselectarea("TRB")
dbGoTop()       

do while .t.
	if !eof()
		nTotal := nTotal + 1
    else
    	exit
	endif
	dbskip()
enddo       

dbGotop()

if nTotal == 0
   return
endif

ProcRegua(nTotal) // Numero de registros a processar

do while .t.        
	
	nFeito := nFeito + 1

	incproc("Processados: "+strzero(nFeito,6)+" de "+ strzero(nTotal,6))
	
	dbselectarea("ZZY")
	dbsetorder(1)
	dbseek(xfilial("ZZY")+trb->(d2_doc+d2_serie+d2_cliente+d2_loja+d2_cod+d2_itempv))
	if eof()
		reclock("ZZY",.t.)
		zzy_filial  := xfilial("ZZY")
		zzy_itempv  := trb->d2_itempv
		zzy_itemnf  := trb->d2_item
		zzy_doc     := trb->d2_doc
		zzy_serie   := trb->d2_serie 
		zzy_client  := trb->d2_cliente
		zzy_loja    := trb->d2_loja               
		zzy_nome    := trb->a1_nome
		zzy_cod     := trb->d2_cod
		ZZY_desc    := trb->b1_desc
		ZZY_qtdpv   := trb->c6_qtdven               
		ZZY_q3ini   := trb->d2_quant
		ZZY_q3fim   := trb->b6_saldo
		ZZY_prunit  := trb->b6_prunit
        ZZY_item    := trb->d2_item
		if trb->b6_atend == "S" .or. ZZY_q3fim == 0
			ZZY_atend   := "Encerrado"
			ZZY_ok      := "OK"
		else
			ZZY_atend   := "Aberto"
		endif
		msunlock()
    else
        reclock("ZZY",.f.)
        if trb->b6_atend == "S" .or. trb->b6_saldo == 0
           zzy_q3fim    := trb->b6_saldo
           zzy_atend    := "Encerrado"
           zzy_ok       := "OK"
        else
           zzy_q3fim    := trb->b6_saldo
           zzy_atend    := "Aberto"
			do case
				case zzy_qtdven > 0 .and. zzy_qtdtra == 0 .and. zzy_qtdarm == 0
					zzy_ok := "QV"
				case zzy_qtdven > 0 .and. zzy_qtdtra > 0 .and. zzy_qtdarm == 0
					zzy_ok := "VT"
				case zzy_qtdven > 0 .and. zzy_qtdtra == 0 .and. zzy_qtdarm > 0
					zzy_ok := "VA"
				case zzy_qtdven > 0 .and. zzy_qtdtra > 0 .and. zzy_qtdarm > 0
					zzy_ok := "TP" 	
				case zzy_qtdven == 0 .and. zzy_qtdtra > 0 .and. zzy_qtdarm == 0
					zzy_ok := "QT"
				case zzy_qtdven == 0 .and. zzy_qtdtra > 0 .and. zzy_qtdarm > 0
					zzy_ok := "TA"
				case zzy_qtdven == 0 .and. zzy_qtdtra == 0 .and. zzy_qtdarm > 0
					zzy_ok := "QA"
			endcase
        endif
        msunlock()
	endif
	
	dbselectarea("TRB")
	dbskip()           
	if eof()
		exit
	endif

enddo

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraPedido�Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GeraPedido(x)

Local cChave   := ""
Local nLin
Local i        := 0
Local lRet     := .F.                               
Local cAlias   := "ZZY"    
Local cProcura := ""     
Local nContS   := 0
Local cLibera  := ""

Private cT        := "Manuten��o de Vendas/Devolu��o"     
if cConsEmp == "E" //20100317                               
	cT := "Manuten��o de Vendas/Devolu��o: EMPRESTIMO"
elseif cConsEmp =="C"
	cT := "Manuten��o de Vendas/Devolu��o: CONSIGNACAO"
else
	cT := "Manuten��o de Vendas/Devolu��o: EXPOSICAO"
endif
Private aC        := {}
Private aR        := {}
Private aCGD      := {}
Private cLinOK    := ""
Private cAllOK    := "u_VerTudOK()"
Private aGetsGD   := {}
Private bF4       := {|| }
Private cIniCpos  := "+ZZY_ITEM"
Private nMax      := 15
Private aHeader   := {}
Private aCols     := {}
Private nCount    := 0
Private bCampo    := {|nField| FieldName(nField)}
Private aAlt      := {}   
Private xtipo     := x
Private nVlTot    := 0
Private nVlVend   := 0
Private cObs      := space(40)
Private cPagto    := space(03)
Private c1Comis   := space(06)
Private c2Comis   := space(06)
Private cTipoOper := space(03)
Private cTComis1 
Private cRegiao
Private nqItem    := 0
Private cCgc
Private cCodCli
Private cCodLoja

if xtipo == 4 .or. xtipo == 2
   dbselectarea("SA1")
   dbsetorder(1)
   if dbseek(xfilial("SA1")+(cAlias)->(zzy_client+zzy_loja))
      cCgc := a1_cgc
      if empty(cCgc)
         msginfo("N�o � poss�vel efetuar a emiss�o de Nota Fiscal Simbolica para Vendedor sem CPF/CNPJ !!!")
         return
      endif
      
      dbselectarea("SA3")
      dbsetorder(1)
	  if dbseek(xfilial("SA3")+SA1->A1_VEND)
        	//cCodCli  := a2_cod
         	//cCodLoja := a2_loja
			dbselectarea("SA2")
			dbsetorder(1)
			if dbseek(xfilial("SA2")+SA3->A3_FORNECE+SA3->A3_LOJA)
				cCodCli  := a2_cod
				cCodLoja := a2_loja
			else
				msginfo("No cadastro do Vendedor informe o codigo do Fornecedor para emiss�o da Nota Fiscal Simbolica/Transporte!!!")
				return
			endif
      else
         msginfo("No cadastro do Cliente informe o codigo do Vendedor, e no Vendedor informe o Fornecedor, para emiss�o da Nota Fiscal Simbolica!!!")
         return
      endif
   endif
endif

dbselectarea(cAlias)
For i := 1 to FCount()
	cCampo := FieldName(i)
	M->&(cCampo) := CriaVar(cCampo,.T.)
Next                 

dbselectarea("SX3")
dbsetorder(1)
dbseek(cAlias)

while !SX3->(EOF()) .and. SX3->X3_Arquivo == cAlias
	if X3Uso(SX3->X3_USADO)    .and.;
	   cNivel >= SX3->X3_Nivel .and.;
	   Trim(SX3->X3_CAMPO) $ "ZZY_ITEMPV/ZZY_DOC/ZZY_SERIE/ZZY_COD/ZZY_DESC/ZZY_QTDVEN/ZZY_QTDTRA/ZZY_QTDARM/ZZY_PVENDA/ZZY_Q3INI/ZZY_Q3FIM/ZZY_PRUNIT/ZZY_QTDSIM/ZZY_NFSIMB"
	   if xtipo == 1 .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDTRA" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDARM" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDSIM" .and. Trim(SX3->X3_CAMPO) <> "ZZY_NFSIMB"
		   aAdd(aHeader, {Trim(SX3->X3_TITULO),;
		                       SX3->X3_CAMPO  ,;
		                       SX3->X3_PICTURE,;
		                       SX3->X3_TAMANHO,;
		                       SX3->X3_DECIMAL,;
		                       SX3->X3_VALID  ,;
		                       SX3->X3_USADO  ,;
		                       SX3->X3_TIPO   ,;
		                       SX3->X3_ARQUIVO,;
		                       SX3->X3_CONTEXT})
	   elseif xtipo == 2 .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDVEN" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDARM" .and. Trim(SX3->X3_CAMPO) <> "ZZY_PVENDA" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDSIM" .and. Trim(SX3->X3_CAMPO) <> "ZZY_NFSIMB"
		   aAdd(aHeader, {Trim(SX3->X3_TITULO),;
		                       SX3->X3_CAMPO  ,;
		                       SX3->X3_PICTURE,;
		                       SX3->X3_TAMANHO,;
		                       SX3->X3_DECIMAL,;
		                       SX3->X3_VALID  ,;
		                       SX3->X3_USADO  ,;
		                       SX3->X3_TIPO   ,;
		                       SX3->X3_ARQUIVO,;
		                       SX3->X3_CONTEXT})
	   elseif xtipo == 3 .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDVEN" .and. Trim(SX3->X3_CAMPO) <> "ZZY_Q3INI" .and. Trim(SX3->X3_CAMPO) <> "ZZY_PVENDA" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDSIM" .and. Trim(SX3->X3_CAMPO) <> "ZZY_NFSIMB"
		   aAdd(aHeader, {Trim(SX3->X3_TITULO),;
		                       SX3->X3_CAMPO  ,;
		                       SX3->X3_PICTURE,;
		                       SX3->X3_TAMANHO,;
		                       SX3->X3_DECIMAL,;
		                       SX3->X3_VALID  ,;
		                       SX3->X3_USADO  ,;
		                       SX3->X3_TIPO   ,;
		                       SX3->X3_ARQUIVO,;
		                       SX3->X3_CONTEXT})
       elseif xtipo == 4 .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDVEN" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDTRA" .and. Trim(SX3->X3_CAMPO) <> "ZZY_PVENDA" .and. Trim(SX3->X3_CAMPO) <> "ZZY_QTDARM"
		   aAdd(aHeader, {Trim(SX3->X3_TITULO),;
		                       SX3->X3_CAMPO  ,;
		                       SX3->X3_PICTURE,;
		                       SX3->X3_TAMANHO,;
		                       SX3->X3_DECIMAL,;
		                       SX3->X3_VALID  ,;
		                       SX3->X3_USADO  ,;
		                       SX3->X3_TIPO   ,;
		                       SX3->X3_ARQUIVO,;
		                       SX3->X3_CONTEXT})
	   endif
	endif
	
	sx3->(dbskip())
	
enddo

m->ZZY_doc     := (cAlias)->ZZY_doc
m->ZZY_serie   := (cAlias)->ZZY_serie
m->ZZY_client  := (cAlias)->ZZY_client
m->ZZY_nome    := (cAlias)->ZZY_nome
m->ZZY_loja    := (cAlias)->ZZY_loja 
m->ZZY_nclien  := (cAlias)->ZZY_nclien
m->ZZY_nloja   := (cAlias)->ZZY_nloja
m->ZZY_pedido  := (cAlias)->ZZY_pedido
m->ZZY_ok      := (cAlias)->ZZY_ok
m->ZZY_nnome   := (cAlias)->ZZY_nnome

c1Comis := posicione("SA1",1,xfilial("SA1")+m->(ZZY_client+ZZY_loja),"A1_VEND")
c2Comis := posicione("SA3",1,xfilial("SA3")+c1Comis,"A3_GEREN")

m->ZZY_ALMOXT := SA1->A1_ALMOXTR
m->ZZY_ALMOXV := SA1->A1_ALMOXVE
cProcura := xfilial(cAlias)+m->ZZY_doc+m->ZZY_serie+m->ZZY_client+m->ZZY_loja

dbselectarea(cAlias)
dbsetOrder(1)
dbseek(cProcura)

while !eof() .and. (cAlias)->(ZZY_filial+ZZY_doc+ZZY_serie+ZZY_client+ZZY_loja) == cProcura

	if (cAlias)->ZZY_ok == "OK" 
		cLibera := "N�o � poss�vel executar nenhum movimento com uma nota encerradas, verifique!!!"
	elseif xtipo == 2 .and. (cAlias)->ZZY_qtdtra >= (cAlias)->ZZY_q3fim
		cLibera := "N�o h� valor a ser transportado para este produto, verifique!!!"
	elseif (!empty((cAlias)->ZZY_nfsimb) .and. xtipo==4)
		 cLibera := "J� emitida Nota Simbolica deste produto, verifique!!!"
	else
		aAdd(aCols,Array(Len(aHeader)+1))
		nLin := Len(aCols)
		For i:= 1 to Len(aHeader)
			if xtipo==3 .and. aHeader[i][2] == "ZZY_QTDTRA" 
				aCols[nLin][i] := FieldGet(FieldPos(aHeader[i][2]))
			elseif aHeader[i][10] = "R" .and. aHeader[i][2] <> "ZZY_QTDVEN" .and. aHeader[i][2] <> "ZZY_QTDTRA" .and. aHeader[i][2] <> "ZZY_QTDARM" .and. aHeader[i][2] <> "ZZY_PVENDA" .and. aHeader[i][2] <> "ZZY_QTDSIM"
	   			aCols[nLin][i] := FieldGet(FieldPos(aHeader[i][2]))
			else
				aCols[nLin][i] := CriaVar(aHeader[i][2],.t.)
			endif       
		Next
		aCols[nLin][Len(aHeader)+1] = .F.
		aAdd(aAlt, Recno())
		nContS := nContS + 1
	endif              		
	dbselectarea(cAlias)
	dbskip()      
	
enddo

if nContS == 0
	msgalert(cLibera)
	return// nil
endif 

aAdd(aC,{"M->ZZY_CLIENT"  ,{20,10 },"Vendedor."          ,"@!"    ,           ,     ,.F.})
aAdd(aC,{"M->ZZY_LOJA"    ,{20,85 },"Loja"               ,"@!"    ,           ,     ,.F.})
aAdd(aC,{"M->ZZY_NOME"    ,{20,120},"Nome Vendedor."     ,"@!"    ,           ,     ,.F.})
if xtipo == 1	
	aAdd(aC,{"M->ZZY_NCLIEN"  ,{35,10 },"Cliente......"      ,"@!"    ,"u_achar()","SA1",.T.})
	aAdd(aC,{"M->ZZY_NLOJA"   ,{35,85 },"Loja"               ,"@!"    ,           ,     ,.T.})
	aAdd(aC,{"M->ZZY_NNOME"   ,{35,120},"Nome Cliente......" ,"@!"    ,           ,     ,.F.})
	aAdd(aC,{"M->ZZY_PEDIDO " ,{50,10 },"Pedido......"       ,"@!", "u_achaped()" ,"SC6",.T.})
	aAdd(aC,{"cPagto"         ,{50,85 },"Cond. Pagto"        ,"999"   ,           ,"SE4",.T.})
	aAdd(aC,{"cTipoOper"      ,{50,150},"Tipo de Opera��o"   ,"@!"    ,           ,"SZ9",.T.})
	aAdd(aC,{"c1Comis"        ,{50,230},"Comiss�o 01"        ,"999999","u_comis()","SA3",.T.})
	aAdd(aC,{"c2Comis"        ,{50,320},"Comiss�o 02"        ,"999999",           ,"SA3",.T.})
	aCGD := {110,5,63,280}
elseif xtipo == 4 .or. xtipo == 2 .or. xtipo == 3
	aAdd(aC,{"M->ZZY_ALMOXT"   ,{35,10},"Almox Transp"      ,"@!"    ,           ,     ,.F.})
	aAdd(aC,{"M->ZZY_ALMOXV"   ,{35,100},"Almox Venda"       ,"@!"    ,           ,     ,.F.})
	aCGD := {80,5,63,280}
else
	aCGD := {50,5,108,280}
endif

if xtipo == 1
   aAdd(aR,{"nVlTot" ,{68,10 },"Total Custo","@E 999,999,999.99",,,.F.})
   aAdd(aR,{"cObs"   ,{68,120},"Observa��es","@!"               ,,,.T.})
   aAdd(aR,{"nVLVend",{83,10 },"Total Venda","@E 999,999,999.99",,,.F.})
elseif xtipo == 2
   aAdd(aR,{"nVlTot",{112,10},"Total do Transporte","@E 999,999,999.99",,,.F.})
elseif xtipo == 3
   aAdd(aR,{"nVlTot",{112,10},"Total da Armazenagem","@E 999,999,999.99",,,.F.})
elseif xtipo == 4
   aAdd(aR,{"nVlTot",{112,10},"Total da Simbolico","@E 999,999,999.99",,,.F.})
endif

cLinOk := "u_VerLinOK()"

cTitulo := cT

lRet := Modelo2(cTitulo,aC,aR,aCGD,4,cLinOK,cAllOk,,,cIniCpos,nMax,{01,01,550,950},.f.)

if lRet
	if MsgYesNo("Confirma os Dados Digitados?",cTitulo)
		
		Processa({||U_Gravazzy(cAlias)},cTitulo,"Gerando as informa��es, aguarde por favor!!")
		
		if xtipo == 1
		   // Execu��o do cadastro do Pedido de venda (Mata410)
           u_gravaPED() //-p3 +v1
		elseif xtipo == 2
		   // Execu��o do cadastro de NF de Transporte (Mata103)
           u_gravaNFE() //nada
		elseif xtipo == 3
		   // Armazenagem - transferencia de almoxarifado(a260Processa)
           //u_PiniTransfAlmox()
           u_gravaNFE() //-p3 +t5 t6
        elseif xtipo == 4
        	u_gravaNFE() //nada (qtd total vendas)
		endif
	endif
else
	rollbackSX8()
endif

return nil                 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Achar     �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para o cadastro de cliente                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function Achar()
dbselectarea("SA1")
dbsetorder(1)
dbseek(xfilial("SA1")+m->ZZY_nclien)
if !eof()
	m->ZZY_nloja := a1_loja
	m->ZZY_nnome := a1_nome                                          
endif
return
                                                                                           
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Comis     �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para o cadastro de cliente                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function Comis()

c2Comis := posicione("SA3",1,xfilial("SA3")+c1Comis,"A3_GEREN")
cTComis1 := posicione("SA3",1,xfilial("SA3")+c1Comis,"A3_TIPOVEN")
cRegiao := posicione("SA3",1,xfilial("SA3")+c1Comis,"A3_REGIAO")

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AchaPed  �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para o cadastro de cliente                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function AchaPed()
dbselectarea("SC5")
dbsetorder(1)
dbseek(xfilial("SC5")+m->ZZY_pedido)
if !eof() .and. c5_cliente == m->zzy_nclien .and. c5_lojacli == m->zzy_nloja
	IF SC5->C5_LIBEROK=="S" 	//20120529
		MSGALERT("ATEN��O: ESTE PEDIDO J� FOI FATURADO!")
	ELSE
		nVlVend := c5_vlrped
	ENDIF
endif
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Gravazzy  �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados ajustados e digitados na tela                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function Gravazzy(cAlias)

Local i
Local y
Local nNrCampo
ProcRegua(Len(aCols))
dbselectarea(cAlias)
dbsetOrder(1)
For i := 1 to Len(aCols)
	if i <= Len(aAlt)
		dbselectarea("ZZY")
		dbgoto(aAlt[i])
		if aCols[1][Len(aHeader)+1]
			MsgInfo("Nesta Op��o n�o � poss�vel excluir dados!!!",cTitulo)
		else
			reclock("ZZY",.f.)
			for y := 1 to Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[y][2]))
				if xtipo <> 2 .and. xtipo <> 4
					Fieldput(nNrCampo,aCols[i][y])
				else
					if trim(aHeader[y][2]) <> alltrim("ZZY_Q3FIM")
						Fieldput(nNrCampo,aCols[i][y])
					endif
				endif
			next
			(cAlias)->ZZY_filial   := xfilial(cAlias)
			(cAlias)->ZZY_pedido   := m->ZZY_pedido
			(cAlias)->ZZY_nclien   := m->ZZY_nclien
			(cAlias)->ZZY_nloja    := m->ZZY_nloja
			(cAlias)->zzy_nnome    := m->zzy_nnome
			if (cAlias)->ZZY_q3fim == 0 .and. zzy_qtdtra == zzy_qtdarm
                if xtipo == 3
                   (cAlias)->zzy_atend := "Encerrado"
                   (cAlias)->zzy_ok := "OK"
                elseif xtipo == 1
                   (cAlias)->zzy_ok := "OK"
                   (cAlias)->zzy_atend := "Encerrado"
                endif         
            else
				do case
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra == 0 .and. (cAlias)->zzy_qtdarm == 0
						(cAlias)->zzy_ok := "QV"
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm == 0
						(cAlias)->zzy_ok := "VT"
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra == 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "VA"
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "TP" 	
					case (cAlias)->zzy_qtdven == 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm == 0
						(cAlias)->zzy_ok := "QT"
					case (cAlias)->zzy_qtdven == 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "TA"
					case (cAlias)->zzy_qtdven == 0 .and. (cAlias)->zzy_qtdtra == 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "QA"
				endcase
            endif
			zzy->(msunlock())
		endif
	else
		if !aCols[i][Len(aHeader)+1]
			reclock(cAlias,.t.)
			for y := 1 to Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[y][2]))
				if xtipo <> 2 .and. xtipo <> 4
					Fileldput(nNrCampo,aCols[i][y])
				else
					if trim(aHeader[y][2]) <> alltrim("ZZY_Q3FIM")
						Fieldput(nNrCampo,aCols[i][y])
					endif
				endif
			next
			(cAlias)->ZZY_filial   := xfilial(cAlias)
			(cAlias)->ZZY_pedido   := m->ZZY_pedido
			(cAlias)->ZZY_nclien   := m->ZZY_nclien
			(cAlias)->ZZY_nloja    := m->ZZY_nloja
			(cAlias)->zzy_nnome := m->zzy_nnome
			if (cAlias)->ZZY_q3fim == 0 .and. zzy_qtdtra == zzy_qtdarm
                if xtipo == 3
                   (cAlias)->zzy_atend := "Encerrado"
                   (cAlias)->zzy_ok := "OK"
                elseif xtipo == 1
                   (cAlias)->zzy_ok := "OK"
                   (cAlias)->zzy_atend := "Encerrado"
                endif
            else
				do case
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra == 0 .and. (cAlias)->zzy_qtdarm == 0
						(cAlias)->zzy_ok := "QV"
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm == 0
						(cAlias)->zzy_ok := "VT"
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra == 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "VA"
					case (cAlias)->zzy_qtdven > 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "TP" 	
					case (cAlias)->zzy_qtdven == 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm == 0
						(cAlias)->zzy_ok := "QT"
					case (cAlias)->zzy_qtdven == 0 .and. (cAlias)->zzy_qtdtra > 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "TA"
					case (cAlias)->zzy_qtdven == 0 .and. (cAlias)->zzy_qtdtra == 0 .and. (cAlias)->zzy_qtdarm > 0
						(cAlias)->zzy_ok := "QA"
				endcase
            endif
			msunlock()
		endif
	endif
next

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaNFE  �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados ajustados para a emiss�o da Nota Fiscal de   ���
���          �entrada                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GravaNFE()
Local aCabec := {}
Local aItens := {}
Local aLinha := {}   
Local aRetorno := {}
Local nX := 0
Local nY := 0
Local nNumNF := len(aCols)/15
Local lOk := .T.
Local _cSerieNFS := "MOV" // "UNI" //20100630 // MOV
Local _cmvnfs:=SuperGetMV("MV_TPNRNFS")
Local cE2_Naturez := "DEVOLUCAO"
PRIVATE lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private cNumero         
     
//20100805 daqui
if xtipo == 4
	_cSerieNFS := "2  "
elseif xtipo == 2 //20100819
	_cSerieNFS := "2  "
else
	_cSerieNFS := "MOV"
endif
//20100805 ate aqui

if nNumNF <= 15
   nNumNF := 1
else
    nNumNF := int(nNumNF)
endif
//��������������������������������������������������������������Ŀ
//| Verifica o ultimo documento valido para um fornecedor |
//����������������������������������������������������������������
dbSelectArea("SF1")
dbSetOrder(1)

For nY := 1 To nNumNF
    aCabec := {}
    aItens := {}
    aRetorno := u_pinip3perg()
    cdoc := NxtSX5Nota( _cSerieNFS,.T.,_cmvnfs)
    if xtipo == 2 // transporte passou a movimentar estoque!, igual ao antigo 3
       /*aadd(aCabec,{"F1_TIPO"   ,"N"})
       aadd(aCabec,{"F1_FORMUL" ,"S"})
       aadd(aCabec,{"F1_DOC"    ,cdoc})
       aadd(aCabec,{"F1_SERIE"  ,_cSerieNFS})
       aadd(aCabec,{"F1_EMISSAO",dDataBase})
       aadd(aCabec,{"F1_DESPESA",0})
       aadd(aCabec,{"F1_FORNECE",cCodCli})
       aadd(aCabec,{"F1_LOJA"   ,cCodLoja})
       aadd(aCabec,{"F1_ESPECIE","SPED"}) //20100707 NFE
       aadd(aCabec,{"F1_COND"   ,"201"})
       aadd(aCabec,{"F1_DESCONT",0,NIL})
       aadd(aCabec,{"F1_SEGURO" ,0,NIL})
       aadd(aCabec,{"F1_FRETE"  ,0,NIL})
       aadd(aCabec,{"F1_VALMERC",nVlTot,NIL})
       aadd(aCabec,{"F1_VALBRUT",nVlTot,NIL})*/
       
       aadd(aCabec,{"F1_TIPO"   ,"N"})
       aadd(aCabec,{"F1_FORMUL" ,"S"})
       aadd(aCabec,{"F1_DOC"    ,cdoc})
       aadd(aCabec,{"F1_SERIE"  ,_cSerieNFS})
       aadd(aCabec,{"F1_EMISSAO",dDataBase})
       aadd(aCabec,{"F1_DESPESA",0})
       aadd(aCabec,{"F1_FORNECE",cCodCli})
       aadd(aCabec,{"F1_LOJA"   ,cCodLoja})
       aadd(aCabec,{"F1_ESPECIE","SPED"}) //20100707 NFE
       aadd(aCabec,{"F1_COND"   ,"201"})
       aadd(aCabec,{"F1_DESCONT",0,NIL})
       aadd(aCabec,{"F1_SEGURO" ,0,NIL})
       aadd(aCabec,{"F1_FRETE"  ,0,NIL})
       aadd(aCabec,{"F1_VALMERC",nVlTot,NIL})
       aadd(aCabec,{"F1_VALBRUT",nVlTot,NIL})     
       aadd(aCabec,{"F1_TRANSP",aRetorno[1],NIL})
       aadd(aCabec,{"F1_PLACA",aRetorno[2],NIL})
       aadd(aCabec,{"F1_PLIQUI",aRetorno[3],NIL})
       aadd(aCabec,{"F1_PBRUTO",aRetorno[4],NIL})
       aadd(aCabec,{"F1_ESPECI1",aRetorno[5],NIL})
       aadd(aCabec,{"F1_VOLUME1",aRetorno[6],NIL})
    elseif xtipo == 3 //mov
       aadd(aCabec,{"F1_TIPO"   ,"B"})
       aadd(aCabec,{"F1_FORMUL" ,"S"})
       aadd(aCabec,{"F1_DOC"    ,cdoc})
       aadd(aCabec,{"F1_SERIE"  ,_cSerieNFS})
       aadd(aCabec,{"F1_EMISSAO",dDataBase})
       aadd(aCabec,{"F1_FORNECE",m->ZZY_client})
       aadd(aCabec,{"F1_LOJA"   ,m->ZZY_loja})
       aadd(aCabec,{"F1_ESPECIE","NFE"})
       aadd(aCabec,{"F1_COND"   ,"201"})
       aadd(aCabec,{"E2_NATUREZ",cE2_Naturez})
       aadd(aCabec,{"F1_VALMERC",nVlTot,NIL})
       aadd(aCabec,{"F1_VALBRUT",nVlTot,NIL})
       aadd(aCabec,{"F1_TRANSP",aRetorno[1],NIL})
       aadd(aCabec,{"F1_PLACA",aRetorno[2],NIL})
       aadd(aCabec,{"F1_PLIQUI",aRetorno[3],NIL})
       aadd(aCabec,{"F1_PBRUTO",aRetorno[4],NIL})
       aadd(aCabec,{"F1_ESPECI1",aRetorno[5],NIL})
       aadd(aCabec,{"F1_VOLUME1",aRetorno[6],NIL})
    elseif xtipo == 4
       aadd(aCabec,{"F1_TIPO"   ,"N"})
       aadd(aCabec,{"F1_FORMUL" ,"S"})
       aadd(aCabec,{"F1_DOC"    ,cdoc})
       aadd(aCabec,{"F1_SERIE"  ,_cSerieNFS})
       aadd(aCabec,{"F1_EMISSAO",dDataBase})
       aadd(aCabec,{"F1_DESPESA",0})
       aadd(aCabec,{"F1_FORNECE",cCodCli})
       aadd(aCabec,{"F1_LOJA"   ,cCodLoja})
       aadd(aCabec,{"F1_ESPECIE","SPED"}) //20100707 NFE
       aadd(aCabec,{"F1_COND"   ,"201"})
       aadd(aCabec,{"F1_DESCONT",0,NIL})
       aadd(aCabec,{"F1_SEGURO" ,0,NIL})
       aadd(aCabec,{"F1_FRETE"  ,0,NIL})
       aadd(aCabec,{"F1_VALMERC",nVlTot,NIL})
       aadd(aCabec,{"F1_VALBRUT",nVlTot,NIL})     
       aadd(aCabec,{"F1_TRANSP",aRetorno[1],NIL})
       aadd(aCabec,{"F1_PLACA",aRetorno[2],NIL})
       aadd(aCabec,{"F1_PLIQUI",aRetorno[3],NIL})
       aadd(aCabec,{"F1_PBRUTO",aRetorno[4],NIL})
       aadd(aCabec,{"F1_ESPECI1",aRetorno[5],NIL})
       aadd(aCabec,{"F1_VOLUME1",aRetorno[6],NIL})
       aadd(aCabec,{"F1_NFSIMB",m->ZZY_SERIE+m->ZZY_DOC, NIL})
    endif
    
    For nX := 1 To len(aCols)
        aLinha := {}
        if (aCols[nX][7] > 0 .and. (xtipo ==2 .or. xtipo==4)) .or. (aCols[nX][8] > 0 .and. xtipo ==3)    // ZZY_qtdarm or ZZY_qtdtra //aCols[nX][7] > 0 20120320
	        //aadd(aLinha,{"D1_ITEM" ,strzero(nX,2),Nil})
	        aadd(aLinha,{"D1_COD" ,aCols[nX][5],Nil})
	        if xtipo == 2 // transport: nada
	           aadd(aLinha,{"D1_QUANT",aCols[nX][7],Nil})
	           aadd(aLinha,{"D1_VUNIT",aCols[nX][10],Nil})
	           aadd(aLinha,{"D1_TOTAL",(aCols[nX][7] * aCols[nX][10]),Nil}) 
          	   if cConsEmp ="E" //20100317
	          	   aadd(aLinha,{"D1_TES","022",Nil})
	   	           posicione("SF4",1,xfilial("SF4")+"022","F4_CODIGO") //20100810
	        	elseif cConsEmp =="C"
		        	aadd(aLinha,{"D1_TES","153",Nil})
		        	posicione("SF4",1,xfilial("SF4")+"153","F4_CODIGO") //20100810
		        else
		        	aadd(aLinha,{"D1_TES","041",Nil})
		        	posicione("SF4",1,xfilial("SF4")+"030","F4_CODIGO") //20100810
	        	endif
	           aadd(aLinha,{"D1_SEGURO",0,NIL})
	           aadd(aLinha,{"D1_VALFRE",0,NIL})
               aadd(aLinha,{"D1_DESPESA",0,NIL})
               aadd(aLinha,{"D1_LOCAL",posicione("SB1",1,xfilial("SB1")+aCols[nx][5],"B1_LOCPAD"),Nil}) //almoxarifado padrao do produto, pois nao movimenta nada
           	   U_PINILOGP3(m->ZZY_client, m->ZZY_loja, aCols[nX][4], aCols[nX][3], aCols[nX][1], aCols[nX][5], "T", "TRANSPORTE/ NFE "+ _cSerieNFS + cdoc +"/ FORN: "+ m->ZZY_client+ m->ZZY_loja +"/ EM "+ DTOS(DDATABASE) , m->ZZY_client, m->ZZY_loja, _cSerieNFS, cdoc, nil, nil, aCols[nX][7])  //transporte
            elseif xtipo == 3
	            aadd(aLinha,{"D1_QUANT",aCols[nX][8],Nil}) //era 7 20120320
    	        aadd(aLinha,{"D1_VUNIT",aCols[nX][10],Nil}) //era 7 20120320
	            aadd(aLinha,{"D1_TOTAL",(aCols[nX][8] * aCols[nX][10]),Nil}) //era 7 20120320
	            if cConsEmp =="E" //20100317
	          	    aadd(aLinha,{"D1_TES","023",Nil}) //20100705: era 020
	          	    posicione("SF4",1,xfilial("SF4")+"023","F4_CODIGO") //20100810
	        	elseif cConsEmp =="C"
	        		aadd(aLinha,{"D1_TES","019",Nil}) //20100128: era 005
	        		posicione("SF4",1,xfilial("SF4")+"019","F4_CODIGO") //20100810
	        	else
	        		aadd(aLinha,{"D1_TES","029",Nil}) //20100128: era 005
	        		posicione("SF4",1,xfilial("SF4")+"029","F4_CODIGO") //20100810
	        	endif
	        	aadd(aLinha,{"D1_NFORI",aCols[nX][3],NIL})
	        	aadd(aLinha,{"D1_SERIORI",aCols[nX][4],NIL})
            	aadd(aLinha,{"D1_ITEMORI",aCols[nX][1],NIL})
            	aadd(aLinha,{"D1_IDENTB6",posicione("SD2",3,xfilial("SD2")+aCols[nX][3]+aCols[nX][4]+m->(zzy_client+zzy_loja)+aCols[nX][5]+aCols[nX][1],"D2_IDENTB6"),NIL})
            	aadd(aLinha,{"D1_LOCAL",posicione("SB1",1,xfilial("SB1")+aCols[nx][5],"B1_LOCPAD"),Nil}) //almoxarifado padrao do produto
            	U_PINILOGP3(m->ZZY_client, m->ZZY_loja, aCols[nX][4], aCols[nX][3], aCols[nX][1], aCols[nX][5], "A", "ARMAZENAGEM/ NFE "+ _cSerieNFS + cdoc +"/ FORN: "+ m->ZZY_client+ m->ZZY_loja +"/ EM "+ DTOS(DDATABASE) , m->ZZY_client, m->ZZY_loja, _cSerieNFS, cdoc, nil, nil, aCols[nX][8])  //armazenagem  //era 7 20120320
	       elseif xtipo == 4
	           aadd(aLinha,{"D1_QUANT",aCols[nX][7],Nil})
	           aadd(aLinha,{"D1_VUNIT",aCols[nX][10],Nil})
	           aadd(aLinha,{"D1_TOTAL",(aCols[nX][7] * aCols[nX][10]),Nil}) 
          	   if cConsEmp =="E" //20100317
	          	   aadd(aLinha,{"D1_TES","022",Nil})
	   	           posicione("SF4",1,xfilial("SF4")+"022","F4_CODIGO") //20100810
	        	elseif cConsEmp =="C"
		        	aadd(aLinha,{"D1_TES","153",Nil})
		        	posicione("SF4",1,xfilial("SF4")+"153","F4_CODIGO") //20100810
		        else
		        	aadd(aLinha,{"D1_TES","031",Nil})
		        	posicione("SF4",1,xfilial("SF4")+"030","F4_CODIGO") //20100810
	        	endif
	           aadd(aLinha,{"D1_SEGURO",0,NIL})
	           aadd(aLinha,{"D1_VALFRE",0,NIL})
               aadd(aLinha,{"D1_DESPESA",0,NIL})
               aadd(aLinha,{"D1_LOCAL",posicione("SB1",1,xfilial("SB1")+aCols[nx][5],"B1_LOCPAD"),Nil}) //almoxarifado padrao do produto, pois nao movimenta nada
               //u_PINILOGP3(cCliente, cLoja, cSerie, cDoc, cItem, cProd, cTipo, cObs, cCliLog, cLojaLog, cSerLog, cDocLog, cPedLog, cTransf, nQtdLog)
            	U_PINILOGP3(m->ZZY_client, m->ZZY_loja, aCols[nX][4], aCols[nX][3], aCols[nX][1], aCols[nX][5], "S", "SIMBOLICA/ NFE "+ _cSerieNFS + cdoc +"/ CLI: "+ cCodCli+ cCodLoja +"/ EM "+ DTOS(DDATABASE), cCodCli, cCodLoja, _cSerieNFS, cdoc, nil, nil, aCols[nX][7])  //simbolica
	        endif
	        posicione("SB1",1,xfilial("SB1")+aCols[nx][5],"B1_COD") //20100810
	        aadd(aLinha,{"D1_CLASFIS",Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB,NIL}) //20100810
	        aadd(aLinha,{"AUTDELETA" ,"N",Nil}) // Incluir sempre no �ltimo elemento do array de cada item

	        aadd(aItens,aLinha)                       
		endif
    Next nX
    //MATA103(aCabec,aItens,3)
    MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens)
    If !lMsErroAuto
       while __lsx8
             confirmsx8()
       enddo
    Else
    	Mostraerro()
        MsgInfo("Erro na inclusao da Nota Fiscal, verifique!!!")

		dbselectarea("ZZY")
		dbsetorder(1)
		
		for nX := 1 to len(aCols)
		
		    if aCols[Nx][7] > 0
		       dbseek(xfilial("ZZY")+aCols[nX][3]+aCols[nX][4]+m->zzy_client+m->zzy_loja+aCols[nX][5]+aCols[nX][2])
		       reclock("ZZY",.f.)
		       if xtipo == 3   
		          zzy_q3fim  := zzy_q3fim + zzy_qtdarm
                  zzy_qtdarm := 0                     
                  zzy_ok     := ""
               elseif xtipo == 2
                  zzy_qtdtra := 0 
                  zzy_ok     := ""
               elseif xtipo == 4
	              zzy_qtdsim := 0 
                  zzy_ok     := ""
               endif
		       msunlock()
		    endif
		
		next nX        
        If ! MsgYesNo("Deseja continuar mesmo assim?")
	        return
	 	EndIf
    EndIf
Next nY        

dbselectarea("ZZY")
dbsetorder(1)

for nX := 1 to len(aCols)

    if aCols[Nx][7] > 0
       dbseek(xfilial("ZZY")+aCols[nX][3]+aCols[nX][4]+m->zzy_client+m->zzy_loja+aCols[nX][5]+aCols[nX][2])
       reclock("ZZY",.f.)
       if xtipo == 2
   	      zzy_tdoc := cdoc
       elseif xtipo == 3
    	  zzy_adoc := cdoc
       elseif xtipo == 4
    	  zzy_nfsimb := _cSerieNFS + cdoc
       endif
       
       if zzy_atend == "Encerrado"
          zzy_ok := "OK"
       endif
       msunlock()
    endif

next nX

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaPED  �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados ajustados para a emiss�o da Nota Fiscal de   ���
���          �entrada e o pedido de venda                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GravaPED()
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX := 0
Local nY := 0
Local nNumNF := len(aCols)/15
Local lOk := .T.
Local _cSerieNFS := "MOV" // "UNI" //20100630 MOV
Local _cmvnfs:=SuperGetMV("MV_TPNRNFS")
Local cE2_Naturez := "DEVOLUCAO"
PRIVATE lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private cNumero
Private _cCF := ""

if nNumNF <= 15
   nNumNF := 1
else
    nNumNF := int(nNumNF)
endif

dbSelectArea("SF1")
dbSetOrder(1)

For nY := 1 To nNumNF
    aCabec := {}
    aItens := {}
    cdoc := NxtSX5Nota( _cSerieNFS,.T.,_cmvnfs)
    aadd(aCabec,{"F1_TIPO"   ,"B"})
    aadd(aCabec,{"F1_FORMUL" ,"S"})
    aadd(aCabec,{"F1_DOC"    ,cdoc})
    aadd(aCabec,{"F1_SERIE"  ,_cSerieNFS})
    aadd(aCabec,{"F1_EMISSAO",dDataBase})
    aadd(aCabec,{"F1_FORNECE",m->ZZY_client})
    aadd(aCabec,{"F1_LOJA"   ,m->ZZY_loja})
    aadd(aCabec,{"F1_ESPECIE","SPED"}) //20100707 NFE
    aadd(aCabec,{"F1_COND"   ,cPagto})
    aadd(aCabec,{"E2_NATUREZ",cE2_Naturez})
    aadd(aCabec,{"F1_VALMERC",nVlTot})
    aadd(aCabec,{"F1_VALBRUT",nVlTot})

    For nX := 1 To len(aCols)
        aLinha := {}
        if aCols[nX][7] > 0     // ZZY_qtdven
	        //aadd(aLinha,{"D1_ITEM" ,aCols[nX][1],Nil})
	        aadd(aLinha,{"D1_COD" ,aCols[nX][5],Nil})
            aadd(aLinha,{"D1_QUANT",aCols[nX][7],Nil})
	        aadd(aLinha,{"D1_VUNIT",aCols[nX][11],Nil})
	        aadd(aLinha,{"D1_TOTAL",(aCols[nX][7] * aCols[nX][11]),Nil})
	        if cConsEmp =="E" //20100317
		       	aadd(aLinha,{"D1_TES","023",Nil}) //20100705: era 020
		       	posicione("SF4",1,xfilial("SF4")+"023","F4_CODIGO")  //20100810
	        elseif cConsEmp =="C"
	           	aadd(aLinha,{"D1_TES","018",Nil}) //20090521: 005
	           	posicione("SF4",1,xfilial("SF4")+"018","F4_CODIGO") //20100810
	        else
		        aadd(aLinha,{"D1_TES","030",Nil})
	           	posicione("SF4",1,xfilial("SF4")+"030","F4_CODIGO")
	        endif
		    aadd(aLinha,{"D1_NFORI",aCols[nX][3],NIL})
	        aadd(aLinha,{"D1_SERIORI",aCols[nX][4],NIL})
            aadd(aLinha,{"D1_ITEMORI",aCols[nX][1],NIL})
            aadd(aLinha,{"D1_NATUREZ",cE2_Naturez,NIL}) //20090909 NATUREZA DE DEVOLUCAO
            aadd(aLinha,{"D1_IDENTB6",posicione("SD2",3,xfilial("SD2")+aCols[nX][3]+aCols[nX][4]+m->(zzy_client+zzy_loja)+aCols[nX][5]+aCols[nX][1],"D2_IDENTB6"),NIL})
			posicione("SB1",1,xfilial("SB1")+aCols[nx][5],"B1_COD") //20100810
	        aadd(aLinha,{"D1_CLASFIS",Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB,NIL}) //20100810
            aadd(aLinha,{"D1_LOCAL",m->zzy_almoxv,Nil}) //almoxarifado de vendas do vendedor 20101006
	        aadd(aLinha,{"AUTDELETA" ,"N",Nil}) // Incluir sempre no �ltimo elemento do array de cada item
	        
			//u_PINILOGP3(cCliente, cLoja, cSerie, cDoc, cItem, cProd, cTipo, cObs, cCliLog, cLojaLog, cSerLog, cDocLog, cPedLog, cTransf, nQtdLog)
            U_PINILOGP3(m->ZZY_client, m->ZZY_loja, aCols[nX][4], aCols[nX][3], aCols[nX][1], aCols[nX][5], "PN", "PEDIDO/ NFE "+ _cSerieNFS + cdoc +"/ FORN: "+ m->ZZY_client+ m->ZZY_loja +"/ EM "+ DTOS(DDATABASE), m->ZZY_client, m->ZZY_loja, _cSerieNFS, cdoc, nil, nil, aCols[nX][7])  //pedido Nf Devolucao

	        aadd(aItens,aLinha)                       
		endif
    Next nX
    //MATA103(aCabec,aItens,3)
    MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens)
    If !lMsErroAuto
       while __lsx8
             confirmsx8()
       enddo
		// 20081201 Danilo C S Pala DAQUI
       	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		dbselectarea("SF1")
		dbsetorder(1)
		if dbseek(xfilial("SF1")+ PADR(cdoc,9) + _cSerieNFS + m->zzy_client + m->zzy_loja +"B") //mp10
			reclock("SF1",.f.)
				F1_OBS := "PEDIDO: " + m->ZZY_pedido
			msunlock()
		endif // 20081201 Danilo C S Pala ATE DAQUI

       MsgInfo("Nota Fiscal de Retorno n� "+cdoc+" gerada!!")
    Else
    	Mostraerro()
        MsgInfo("Erro na inclusao da Nota Fiscal, verifique!!!")          

		For nX := 1 To len(aCols)
			if aCols[nX][7] > 0
       			dbseek(xfilial("ZZY")+aCols[nX][3]+aCols[nX][4]+m->zzy_client+m->zzy_loja+aCols[nX][5]+aCols[nX][2])
       			reclock("ZZY",.f.)
				ZZY_nclien := ""
				ZZY_nloja  := ""
				zzy_nnome  := ""
				ZZY_pedido := ""
				zzy_q3fim  := zzy_q3fim + zzy_qtdven
				zzy_qtdven := 0
				zzy_pvenda := 0
				zzy_ok     := ""
				msunlock()
			endif
		next nX
  	If ! MsgYesNo("Deseja continuar mesmo assim?")
		return
	EndIf
       
    EndIf
Next nY

dbselectarea("SA1")
dbsetorder(1)
if !dbseek(xfilial("SA1")+m->ZZY_nclien+m->ZZY_nloja)
	MsgAlert("Cliente n�o localizado!")
endif

dbselectarea("SC5")
dbsetorder(1)
dbseek(xfilial("SC5")+m->ZZY_pedido)

if eof()
	reclock("SC5",.t.)
	c5_filial	:= xfilial("SC5")
	c5_num		:= m->ZZY_pedido
	c5_tipo		:= "N"
	c5_divven	:= "MERC"
	c5_codprom	:= "N"
	c5_identif	:= "."
	c5_cliente	:= m->ZZY_nclien
	c5_lojacli	:= m->ZZY_nloja
	c5_lojaent  := m->zzy_nloja
	c5_tipocli	:= "F"
	c5_condpag	:= cPagto
	c5_lotefat	:= ""
	c5_data		:= ddatabase
	c5_emissao	:= ddatabase //20081201 danilo: solicitado por sandra
	c5_vend1	:= c1Comis
	c5_vlrped	:= nVlVend
	c5_vend4	:= c2Comis
	c5_tipoop	:= cTipoOper
	c5_dtcalc	:= ddatabase
	c5_avesp	:= "N"
	c5_tptrans	:= "99"
	c5_mennota	:= cObs
	msunlock()
else
	reclock("SC5",.f.)
	c5_vlrped := nVlVend
	msunlock()
endif

dbselectarea("SC6")
dbsetorder(1)
if dbseek(xfilial("SC6")+m->zzy_pedido)
   do while .t.
      nqItem := nqItem + 1
      dbskip()
      if eof() .or. sc6->c6_num <> m->zzy_pedido
         exit
      endif
   enddo
endif

For nX := 1 To len(aCols)
	if aCols[nX][7] > 0
		reclock("SC6",.t.)
		c6_filial	:= xfilial("SC6")
        if nqItem > 0
           c6_item    := strzero((nX+nqItem),2)
        else
           c6_item     := strzero(nX,2)
        endif
		c6_produto	:= aCols[nX][5]
		//c6_local    := posicione("SD2",3,xfilial("SD2")+aCols[nX][3]+aCols[nX][4]+m->(zzy_client+zzy_loja)+aCols[nX][5]+aCols[nX][1],"D2_LOCAL")
		c6_local    := m->zzy_almoxv //20101006
		c6_descri	:= aCols[nX][6]
		c6_tes		:= posicione("SB1",1,xfilial("SB1")+aCols[nx][5],"B1_TS")
		//c6_cf       := posicione("SF4",1,xfilial("SF4")+c6_tes,"F4_CF") //20111205 daqui
		_cCF        := posicione("SF4",1,xfilial("SF4")+c6_tes,"F4_CF") 
		If SA1->A1_EST == "SP" 
			_cCF:= '5'+SUBSTR(_cCF,2,3)
		ElseIf SA1->A1_EST=="EX"
			_cCF:='7'+SUBSTR(_cCF,2,3)
		Else
			_cCF:='6'+SUBSTR(_cCF,2,3)
		EndIf
		c6_cf       := _cCF //20111205 ate aqui
		c6_localcli	:= posicione("SD2",3,xfilial("SD2")+m->ZZY_doc+m->ZZY_serie+m->ZZY_client+m->ZZY_loja+aCols[nX][5]+aCols[nX][2],"D2_LOJA")
		c6_qtdven	:= aCols[nX][7]
		c6_prcven	:= aCols[nX][8]
		c6_valor	:= aCols[nX][7] * aCols[nX][8]
		c6_data		:= ddatabase
		c6_cli		:= m->ZZY_nclien
		c6_loja		:= m->ZZY_nloja
		c6_num		:= m->ZZY_pedido
		c6_tpop		:= "F"
		c6_tiporev  := "0"
		C6_EDINIC   := 9999
        C6_EDFIN    := 9999
        C6_EDVENC   := 9999
        C6_EDSUSP   := 9999
        C6_REGCOT   := '99'+space(13)
        C6_TPPROG   := 'N'
        C6_SITUAC   :='AA'  

        SZ3->(DBSELECTAREA("SZ3"))
        SZ3->(DBGOTOP())
        If SZ3->(DBSEEK(xfilial("SZ3")+cValToChar(aCols[nX][5])+cValToChar(cRegiao)))                                                             
	  		If cTComis1 $ "OP"
	  			c6_comis1 := SZ3->Z3_COMOTEL
			Else
				c6_comis1 := SZ3->Z3_COMREP1
			Endif
	        
	        If !empty(sc5->c5_vend3)
	        	c6_comis3 := SZ3->Z3_COMSUP
	        endif
	        
	        If !empty(sc5->c5_vend4)
	        	c6_comis4 := SZ3->Z3_COMGLOC
	        endif     
	    EndIf
	        
        C6_CLASFIS := Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB //20100715
		
	msunlock()    

		//u_PINILOGP3(cCliente, cLoja, cSerie, cDoc, cItem, cProd, cTipo, cCliLog, cLojaLog, cSerLog, cDocLog, cPedLog, cTransf, nQtdLog)
        U_PINILOGP3(m->ZZY_client, m->ZZY_loja, aCols[nX][4], aCols[nX][3], aCols[nX][1], aCols[nX][5], "PE", "PEDIDO/ NUMERO "+ m->ZZY_pedido +"/ CLI: "+ m->ZZY_nclien + m->ZZY_loja +"/ EM "+ DTOS(DDATABASE), m->ZZY_nclien, m->ZZY_nloja, nil, nil, m->ZZY_pedido, nil, aCols[nX][7])  //pedido Nf Devolucao
	endif
next nX

u_pfat248(m->ZZY_pedido) //20110512
Return nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Calczzy   �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica os dados em cada linha digitada                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function Calczzy()

Local noldq3fim := buscacols("ZZY_Q3FIM")
Local nq3fim := buscacols("ZZY_Q3FIM")
Local nPrUnit := buscacols("ZZY_PRUNIT")
Local gravaSaldo := zzy->zzy_q3fim
Local nQTran := 0
if xtipo==3
	nQTran := buscacols("ZZY_QTDTRA")
endif

if noldq3fim < gravaSaldo
   noldq3fim := gravaSaldo
endif

if xtipo == 1 .and. m->ZZY_qtdven > 0
	nq3fim := nq3fim - m->ZZY_qtdven
	if nq3fim < 0
		MsgInfo("Quantidade de Venda Informada � Superior ao Saldo Existente, verifique!!!",cTitulo)
		nq3fim := noldq3fim
		aCols[n][7]:= 0 //m->ZZY_qtdven := 0
	endif	
	nVlTot += m->ZZY_qtdven * nPrUnit
elseif xtipo == 1 .and. m->ZZY_qtdven < 0
	MsgInfo("N�o � permitido lan�ar valores negativo, verifique!!!",cTitulo)
	aCols[n][7]:= 0
elseif xtipo == 2 .and. m->ZZY_qtdtra > 0
	nq3fim := nq3fim - m->ZZY_qtdtra
	if nq3fim < 0
		MsgInfo("Quantidade de Transporte Informada � Superior ao Saldo Existente, verifique!!!",cTitulo)
		nq3fim := noldq3fim
		aCols[n][7]:= 0 //m->ZZY_qtdtra := 0
	endif		
	nVlTot += m->ZZY_qtdtra * nPrUnit
elseif xtipo == 2 .and. m->ZZY_qtdtra < 0
	MsgInfo("N�o � permitido lan�ar valores negativo, verifique!!!",cTitulo)
	aCols[n][7]:= 0
elseif xtipo == 3 .and. m->ZZY_qtdarm > 0
	/*nq3fim := nq3fim - m->ZZY_qtdarm
	if nq3fim < 0
		MsgInfo("Quantidade de Armazenagem Informada � Superior ao Saldo Existente, verifique!!!",cTitulo)
		nq3fim := noldq3fim
		aCols[n][7]:= 0 //m->ZZY_qtdarm := 0
	endif		
	*/                 
	nQTran := nQTran - m->ZZY_qtdarm
	if nQTran < 0
		MsgInfo("Quantidade de Armazenagem Informada � Superior a quantidade Transportada, verifique!!!",cTitulo)
		aCols[n][8]:= 0
	endif		
	nVlTot += m->ZZY_qtdarm * nPrUnit
elseif xtipo == 3 .and. m->ZZY_qtdarm < 0
	MsgInfo("N�o � permitido lan�ar valores negativo, verifique!!!",cTitulo)
	aCols[n][8]:= 0
elseif xtipo == 4 .and. m->ZZY_qtdsim > 0
	nq3fim := nq3fim - m->ZZY_qtdsim
	if nq3fim < 0
		MsgInfo("Quantidade de Simbolica Informada � Superior ao Saldo Existente, verifique!!!",cTitulo)
		nq3fim := noldq3fim
		aCols[n][7]:= 0 //m->ZZY_qtdarm := 0
	endif		
	nVlTot += m->ZZY_qtdsim * nPrUnit
elseif xtipo == 4 .and. m->ZZY_qtdsim < 0
	MsgInfo("N�o � permitido lan�ar valores negativo, verifique!!!",cTitulo)
	aCols[n][7]:= 0
elseif m->ZZY_qtdven < 0 .or. m->ZZY_qtdarm < 0 .or. m->ZZY_qtdtra < 0 .or. m->ZZY_qtdsim < 0
	MsgInfo("N�o � permitido lan�ar valores negativo, verifique!!!",cTitulo)
elseif m->zzy_qtdven == 0 .or. m->zzy_qtdarm == 0 .or. m->zzy_qtdtra == 0 .or. m->zzy_qtdsim == 0
   if nVlTot > 0
		nVlTot := nVltot - nPrUnit
   endif
   nq3fim := gravaSaldo
   if nVlVend >0 
   		nVlVend := nVlVend - buscacols("ZZY_PVENDA")
   endif             
   if xtipo == 1
      aCols[n][8]:= 0 //m->zzy_pvenda := 0
   endif
endif

return(nq3fim)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Calcped   �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica os dados em cada linha digitada                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function Calcped()

Local nPrVenda := buscacols("ZZY_PVENDA")
Local nQVenda := buscacols("ZZY_QTDVEN")

if xtipo == 1 .and. nQVenda > 0
	nVlVend += m->zzy_qtdven * nPrVenda
elseif nQVenda == 0
	nVlVend := nVlVend - nPrVenda
	if nVlVend < 0
		nVlVend := 0
	endif
	nPrVenda := 0
endif

return(nPrVenda)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerLinOK  �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica os dados em cada linha digitada                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function VerLinOK()   

Local lRet := .t.

if xtipo == 1 .and. m->ZZY_qtdven < 0
	MsgInfo("N�o � permitido valores negativos para Pedidos de Venda, verifique!!!",cTitulo)
	lret := .f.                                       
elseif xtipo == 1 .and. m->zzy_pvenda <= 0 .and. m->zzy_qtdven > 0
	MsgInfo("N�o � permitido Pre�o de venda negativo ou zerado, verifique !!!",cTitulo)
	lret := .f.
elseif xtipo == 2 .and. m->ZZY_qtdtra < 0
	MsgInfo("N�o � permitido valores negativos para Transporte, verifique!!!",cTitulo)
	lret := .f.	
elseif xtipo == 3 .and. m->ZZY_qtdarm < 0                   
	MsgInfo("N�o � permitido valores negativos para Armazenagem, verifique!!!",cTitulo)
	lret := .f.	
elseif xtipo == 4 .and. m->ZZY_qtdsim < 0                  
	MsgInfo("N�o � permitido valores negativos para NF Simbolica, verifique!!!",cTitulo)
	lret := .f.	
endif

Return lRet       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerTudOK  �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica os dados se est�o tudo certos                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function VerTudOK()

Local lRet := .t.
Local i    := 0
Local nDel := 0

For i := 1 to Len(aCols)
	if aCols[i][Len(aHeader)+1]
		nDel++
	endif
Next

if nDel == Len(aCols)
	MsgInfo("Nesta Op��o n�o � poss�vel excluir dados!!!",cTitulo)
	lRet := .f.
endif

if xtipo == 1
   if empty(m->zzy_nclien) .or. empty(m->zzy_pedido) .or. empty(cPagto) .or. empty(cTipoOper) .or. empty(c1Comis)
      msgInfo("Existem campos obrigat�rios em branco!! Verifique Cliente, Pedido, Condi��es de Pagto, Tipo de Opera��o e Comiss�o",cTitulo)
      lRet := .f.
   endif
endif

Return lRet


           
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TransAlmox�Autor  �Danilo PAla         � Data �  20100922   ���
�������������������������������������������������������������������������͹��
���Desc.     �											                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                             
User Function PiniTransfAlmox()
Private cCodProd := ""
Private cAlmoxOrigem := "" //almoxarifado de transferencia (origem)
Private cAlmoxDestino := ""  //almoxarifado padrao do produto (destino)
Private nQuant := 0
    For nX := 1 To len(aCols)
        if aCols[nX][8] > 0     // ZZY_qtdarm
	        cCodProd := aCols[nX][5]
            nQuant := aCols[nX][8]
            cAlmoxOrigem  := m->zzy_almoxt
	        cAlmoxDestino := posicione("SB1",1,xfilial("SB1")+cCodProd,"B1_LOCPAD")
	        If nQuant >0
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
				//para estorno passar o 15o. par metro com .T.
				//Function a260Processa(cCodOrig,cLocOrig,    nQuant260   ,cDocto,   dEmis260, nQuant260D,cNumLote,cLoteDigi,dDtValid, cNumSerie,cLoclzOrig,cCodDest, cLocDest,      cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,    cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)                                              
			   a260Processa(cCodProd,           cAlmoxOrigem,nQuant     ,(ALLTRIM(M->ZZY_DOC)), ddatabase,0         ,""      ,""       ,ddatabase,""       ,""        ,cCodProd,cAlmoxDestino ,""        ,.F.     ,0       ,0      , "U_ATPINI02",""     ,""      ,""     ,""        ,""       ,""      ,""      ,""       ,"N"    ,""    ,""     ,""     ,""     ,""      ,""      ,0        ,"")	 //20101020  //20101118
			   //msginfo(cCodProd + " em "+ cAlmoxOrigem +" para "+ cAlmoxDestino + " Qtd:" + alltrim(str(nQuant)))
			   
				//u_PINILOGP3(cCliente, cLoja, cSerie, cDoc, cItem, cProd, cTipo, cObs, cCliLog, cLojaLog, cSerLog, cDocLog, cPedLog, cTransf, nQtdLog)
		        U_PINILOGP3(m->ZZY_client, m->ZZY_loja, m->ZZY_serie, m->ZZY_DOC, aCols[nX][1], cCodProd, "A", "ARMAZENAGEM/ TRANSF DE:"+ ALLTRIM(cAlmoxOrigem) +" P:"+ ALLTRIM(cAlmoxDestino) + " / EM: "+ dtos(ddatabase) , nil, nil, nil, nil, nil, "DE:"+ ALLTRIM(cAlmoxOrigem) +" P:"+ ALLTRIM(cAlmoxDestino), aCols[nX][8])  //Armazenagem
		    EndIf
		endif
    Next nX
/*
-----------------------------------------------------------------------------
���Fun??o    �A260Processa  � Eveli Morasco             � Data � 16/01/92 ���
-----------------------------------------------------------------------------
���Descri??o � Processamento da inclusao                                  ���
-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
��� Uso      � Transferencia                                              ���
-----------------------------------------------------------------------------
*/
Return     



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PINIP3PERG� Autor � DANILO C S PALA    � Data �  20100924   ���
�������������������������������������������������������������������������͹��
���Descricao � 								 							  ���
���          � 															  ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PINIP3PERG()

Private aRetorno := {}
//Public cConsEmp := "C"
cperg := "PINICE02"
ValidP3Perg()
Pergunte(cPerg,.t.)        

aAdd(aRetorno, MV_PAR01)
aAdd(aRetorno, MV_PAR02)
aAdd(aRetorno, MV_PAR03)
aAdd(aRetorno, MV_PAR04)
aAdd(aRetorno, MV_PAR05)
aAdd(aRetorno, MV_PAR06)

Return aRetorno



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria parametros no SX1 nao existir os parametros.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs := {}
//
//mv_par01 - Vendedor de
//mv_par02 - Vendedor at�
//mv_par03 - Nota de
//mv_par04 - Nota at�
//mv_par05 - Emiss�o de
//mv_par06 - Emiss�o at�
//mv_par07 - Encerradas

aAdd(aRegs,{cPerg,"01","Vendedor de?   ","Vendedor de?   ","Vendedor de?   ","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"02","Vendedor at�?  ","Vendedor at�?  ","Vendedor at�?  ","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"03","Nota de?       ","Nota de?       ","Nota de?       ","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Nota at�?      ","Nota at�?      ","Nota at�?      ","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Emiss�o de?    ","Emiss�o de?    ","Emiss�o de?    ","mv_ch5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emiss�o at�?   ","Emiss�o at�?   ","Emiss�o at�?   ","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Encerradas?    ","Encerradas?    ","Encerradas?    ","mv_ch7","C",01,0,2,"C","","MV_PAR07","Sim","Sim","Sim","","","N�o","N�o","N�o","","","","","","","","","","","","","","","","","","","","",""})

_nLimite := If(Len(aRegs[1])<FCount(),Len(aRegs[1]),FCount())
For i := 1 To Len(aRegs)
	If !DbSeek(cPerg + aRegs[i,2])
		Reclock("SX1", .T.)
		For j := 1 to _nLimite
			FieldPut(j, aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return(.T.)


Static Function ValidConsEmp()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs := {}
aAdd(aRegs,{cPerg,"01","Tipo?","Tipo?","Tipo?","mv_ch1","N",01,0,2,"C","","MV_PAR01","Consignacao","Consignacao","Consignacao","","","Emprestimo","Emprestimo","Emprestimo","","","Exposicao","Exposicao","Exposicao","","","","","","","","","","","","","","","",""})

_nLimite := If(Len(aRegs[1])<FCount(),Len(aRegs[1]),FCount())
For i := 1 To Len(aRegs)
	If !DbSeek(cPerg + aRegs[i,2])
		Reclock("SX1", .T.)
		For j := 1 to _nLimite
			FieldPut(j, aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)
Return(.T.)



Static Function ValidP3Perg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs := {}
//
//mv_par01 - Transportadora
//mv_par02 - Placa
//mv_par03 - Peso Liquido
//mv_par04 - Peso Bruto
//mv_par05 - Especie 1
//mv_par06 - Volume 1

aAdd(aRegs,{cPerg,"01","Transportadora?","Transportadora?","Transportadora?","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","",""})
aAdd(aRegs,{cPerg,"02","Placa?         ","Placa?         ","Placa?         ","mv_ch2","C",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Peso Liquido?  ","Peso Liquido?  ","Peso Liquido?  ","mv_ch3","N",11,4,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Peso Bruto?    ","Peso Bruto?    ","Peso Bruto?    ","mv_ch4","N",11,4,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Especie 1?     ","Especie 1?     ","Especie 1?     ","mv_ch5","C",10,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Volume 1?      ","Volume 1?      ","Volume 1?      ","mv_ch6","N",6,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

_nLimite := If(Len(aRegs[1])<FCount(),Len(aRegs[1]),FCount())
For i := 1 To Len(aRegs)
	If !DbSeek(cPerg + aRegs[i,2])
		Reclock("SX1", .T.)
		For j := 1 to _nLimite
			FieldPut(j, aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)
Return(.T.)