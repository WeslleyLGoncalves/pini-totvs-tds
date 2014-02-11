#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch" 
#include "protheus.ch" 


User Function ADJIN79()          

SFT->(DBSELECTAREA("SFT"))
SFT->(DBSETORDER(6))
SFT->(DBGOTOP())  

cQuery := " SELECT FT_FILIAL, FT_TIPOMOV, FT_NFISCAL, FT_SERIE, FT_VALCONT, FT_ISENICM, FT_PRCUNIT, FT_TOTAL, FT_BASEPIS, FT_BASECOF, SUM(E1_VALOR) AS E1_VALOR" 
cQuery += " FROM "+RETSQLNAME("SFT")+" SFT" 
cQuery += " JOIN "+RETSQLNAME("SE1")+" SE1 ON SE1.D_E_L_E_T_ != '*'"
cQuery += " AND SE1.E1_FILIAL = SFT.FT_FILIAL" 
cQuery += " AND SE1.E1_PREFIXO = SFT.FT_SERIE"  
cQuery += " AND SE1.E1_NUM = SFT.FT_NFISCAL " 
cQuery += " AND SE1.E1_CLIENTE = SFT.FT_CLIEFOR"
cQuery += " AND SE1.E1_LOJA = SFT.FT_LOJA"
cQuery += " WHERE SFT.D_E_L_E_T_ != '*'" 
cQuery += " AND FT_ENTRADA BETWEEN '20140129' AND '20140129' " 
cQuery += " AND FT_SERIE = '21' "
cQuery += " GROUP BY FT_FILIAL, FT_TIPOMOV, FT_NFISCAL, FT_SERIE, FT_VALCONT, FT_ISENICM, FT_PRCUNIT, FT_TOTAL, FT_BASEPIS, FT_BASECOF " 

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRB", .F., .T.)

Do While TRB->(!EOF())
    
		If SFT->(DBSEEK(TRB->FT_FILIAL+TRB->FT_TIPOMOV+TRB->FT_NFISCAL+TRB->FT_SERIE))
	    	
			SFT->(Reclock("SFT", .F.))
			  
			  SFT->FT_VALCONT 	:= TRB->E1_VALOR
			  SFT->FT_ISENICM  	:= TRB->E1_VALOR
			  SFT->FT_PRCUNIT  	:= TRB->E1_VALOR
			  SFT->FT_TOTAL		:= TRB->E1_VALOR
			  SFT->FT_BASEPIS		:= TRB->E1_VALOR
			  SFT->FT_BASECOF		:= TRB->E1_VALOR
			  SFT->FT_VALIMP5		:= TRB->E1_VALOR
			  SFT->FT_VALIMP6  	:= TRB->E1_VALOR
				
			SFT->(msUnLock())
		
		EndIf		
				
	TRB->(DBSKIP())
Enddo     
	
MSGINFO("Processamento OK V2!")
    
	TRB->(DBCLOSEAREA())

Return