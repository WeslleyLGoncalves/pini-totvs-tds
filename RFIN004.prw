#INCLUDE "rwmake.ch"                       
#include "topconn.ch"
#include "tbiconn.ch"

/*/     
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFIN004   �Autor: Danilo C S Pala        � Data:   20081010 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Gera arquivo de recebimentos do versato                    � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFIN004() 
setprvt("cArq, cArqPath, cArquivo")
setprvt("mhora, mdata, cQuery, nLastKey, nTotal")


Private cPerg := "RFI004"
ValidPerg()

If !Pergunte(cPerg)
   Return
Endif


Processa({||ProcArq()  },"Preparando Dados")

Return    




//���������������������������������������������������������������������������Ŀ
//� Function  � ProcArq()                                                     �
//���������������������������������������������������������������������������Ĵ
//� Descricao � query na view v_versato									      �
//�           �                               								  �
//�           � 															  �
//�����������������������������������������������������������������������������
Static Function ProcArq()
     
DbSelectArea("SF2")  
cQuery := "SELECT A1_COD, A1_LOJA, A1_CGC, A1_NOME, A1_NREDUZ, A1_END, A1_BAIRRO, A1_CEP, A1_MUN, A1_EST, A1_CONTATO, B1_COD, B1_DESC, F2_SERIE, F2_DOC, F2_EMISSAO, F2_VALFAT, F2_VALMERC, F2_VALBRUT, D2_PEDIDO, D2_ITEMPV, D2_TES, D2_DOC, D2_SERIE, D2_EMISSAO, D2_QUANT, D2_PRCVEN, D2_TOTAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_VALOR, E1_SALDO, E1_VENCTO, E1_VENCREA, E1_BAIXA, E1_PORTADO, E1_MOTIVO, E1_OBS, VALOR_TITULO_POR_PRODUTO as V_VALOR, CLASSIFICACAO_TITULO AS V_CLASSI"
cQuery += " FROM V_VERSATO WHERE"    
if MV_PAR03 == 1 // FILTRO POR EMISSAO
	cQuery += " F2_EMISSAO >= '"+DTOS(MV_PAR01)+"' AND F2_EMISSAO <= '"+DTOS(MV_PAR02)+"'"
ELSE // FILTRO POR VENCIMENTO
	cQuery += " E1_VENCTO >= '"+DTOS(MV_PAR01)+"' AND E1_VENCTO <= '"+DTOS(MV_PAR02)+"'"
ENDIF
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'VERSATO', .F., .T.)
dbselectarea("VERSATO")
dbGoTop()              
             
nTotal := 0

while !eof() .and. nTotal <1
	nTotal := nTotal + 1
	dbskip()
end

if nTotal == 0 
	cArquivo := "Sem dados no per�odo"
else
	MHORA     := TIME()
	cArq      := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,4,2) +".DBF"
	cArqPath   :=GetMv("MV_PATHTMP")                    
	cArquivo := cArqPath+cArq
	COPY TO &cArquivo VIA "DBFCDXADS" // 20121106              
endif
MsgInfo(cArquivo)     
dbselectarea("VERSATO")
dbclosearea()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �DANILO C S PALA     � Data �  20081010   ���
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
aAdd(aRegs,{cPerg,"01","Data de?       ","Data de?       ","Data de?       ","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data at�?      ","Data at�?      ","Data at�?      ","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Filtro?        ","Filtro?        ","Filtro?        ","mv_ch3","C",01,0,2,"C","","MV_PAR03","Emiss�o","Emiss�o","Emiss�o","","","Vencimento","Vencimento","Vencimento","","","","","","","","","","","","","","","","","","","","",""})

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
