#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"  //consulta SQL
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFAT121   �Autor: DANILO C S PALA        � Data:   20081031 � ��
������������������������������������������������������������������������Ĵ ��
���Descricao: RELATORIO DE CONTROLE PODER DE TERCEIROS                   � ��
���                         											 � ��
SP_REL_PODER_TERCEIROS(IN_VENDEDOR, IN_LOJA, IN_DATADE, IN_DATAATE, IN_SITUACAO, IN_FORMATO)
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFAT121()
SetPrvt("lEnd")

//SP_REL_PODER_TERCEIROS(IN_VENDEDOR, IN_LOJA, IN_DATADE, IN_DATAATE, IN_SITUACAO, IN_FORMATO)
//������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros     �
//� mv_par01             //VENDEDOR          �
//� mv_par02             //LOJA              �
//� mv_par03             //DATADE            �
//� mv_par04             //DATAATE           �
//� mv_par05             //SITUACAO          �
//� mv_par06             //FORMATO           �
//� mv_par07             //Relatorio         �
//��������������������������������������������

CPERG := 'RFT121'
ValidPerg()
IF !PERGUNTE(CPERG)
	RETURN
ENDIF

lEnd := .F.
Processa({|lEnd| ProcArq(@lEnd)})
Return


Static Function ProcArq()
Private nQTD_ENT    := 0
PRIVATE MHORA     := TIME()
Private cString   := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
Private cArqPath  := GetMv("MV_PATHTMP")
Private _cString  := cArqPath+cString+".DBF"
Private cSituacao := Space(1) //mv_par05 //1=Aberto, 2=Fechado, 3=Todos
Private cFormato := Space(1) //mv_par06 //1=Analitico, 2=Sintetico
if mv_par05  == 1
	cSituacao := "A"
elseif mv_par05 == 2
	cSituacao := "F"
else
	cSituacao := "T"
endif

if mv_par06 == 1
	cFormato := "A"
else
	cFormato := "S"
endif

DbSelectArea("SB1")
if RDDName() <> "TOPCONN"
	MsgStop("Este programa somente podera ser executado na versao SQL do SIGA Advanced.")
	Return nil
endif
                 
if mv_par07  == 1
//Verifica se a Stored Procedure Teste existe no Servidor
If TCSPExist("SP_REL_PODER_TERCEIROS")
	//SP_REL_PODER_TERCEIROS(IN_VENDEDOR, IN_LOJA, IN_DATADE, IN_DATAATE, IN_SITUACAO, IN_FORMATO)
	aRet := TCSPExec("SP_REL_PODER_TERCEIROS", mv_par01, mv_par02, dtos(mv_par03), dtos(mv_par04), cSituacao, cFormato)
	
	cQuery := "select TIPO, SERIEORI, DOCORI, SERIE, DOC, OBS, EMISSAO, TPPROD, PRODUTO, DESCR, ROUND(QTDSAIDA,1) AS QTDSAIDA, ROUND(NVL(QTDENTR,0),1) AS QTDENTR, ROUND(QTDDIF,1) AS QTDDIF from rel_poder_terceiros ORDER BY SERIEORI, DOCORI, PRODUTO, TIPO DESC"
	//TCQUERY cQuery NEW ALIAS "PODER3"   
	MsAguarde({|| DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PODER3", .T., .F. )},"Aguarde - NAO DESCONECTE!","Selecionando dados. Isto pode demorar um pouco...")
	TcSetField("PODER3","QTDSAIDA" ,"N",10,0)
	TcSetField("PODER3","QTDENTR"  ,"N",10,0)
	TcSetField("PODER3","QTDDIF"   ,"N",10,0)
	
	DbSelectArea("PODER3")
	DBGoTop()
	
	DbSelectArea("PODER3")
	DBGotop()
	COPY TO &_cString VIA "DBFCDXADS" // 20121106 
	DBCloseArea()
	
	cMsg:= "Arquivo gerado em: "+_cString
	MSGINFO(cMsg)
EndIf

Else
	cQuery := "select f1_emissao, f1_serie, f1_doc, f1_fornece, f1_loja, f1_tipo, f1_valmerc, f1_valbrut from sf1010 where f1_filial='"+xfilial("SF1")+"' and f1_tipo ='B' and f1_emissao>='"+ dtos(mv_par03) +"' and f1_emissao<='"+ dtos(mv_par04) +"' and d_e_l_e_t_<>'*'"
	MsAguarde({|| DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PODER3", .T., .F. )},"Aguarde - NAO DESCONECTE!","Selecionando dados. Isto pode demorar um pouco...")
	TcSetField("PODER3","f1_emissao" ,"D")
	TcSetField("PODER3","f1_valmerc"  ,"N",10,2)
	TcSetField("PODER3","f1_valbrut"   ,"N",10,2)
	
	DbSelectArea("PODER3")
	DBGoTop()
	
	DbSelectArea("PODER3")
	DBGotop()
	COPY TO &_cString VIA "DBFCDXADS" // 20121106 
	DBCloseArea()
	
	cMsg:= "Arquivo gerado em: "+_cString
	MSGINFO(cMsg)
Endif

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �DANILO C S PALA     � Data �  20080919   ���
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
cPerg := PADR(cPerg,10)  //mp10 x1_grupo char(10)
aRegs := {}
aAdd(aRegs,{cPerg,"01","Vendedor?      ","Vendedor?      ","Vendedor?      ","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Loja?          ","Loja?          ","Loja?          ","mv_ch2","C",02,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Emiss�o de?    ","Emiss�o de?    ","Emiss�o de?    ","mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Emiss�o at�?   ","Emiss�o at�?   ","Emiss�o at�?   ","mv_ch4","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Situacao?      ","Situacao?      ","Situacao?      ","mv_ch5","C",01,0,2,"C","","MV_PAR05","Aberto","Aberto","Aberto","","","Fechado","Fechado","Fechado","","","Todos","Todos","Todos","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Formato?       ","Formato?       ","Formato?       ","mv_ch6","C",01,0,2,"C","","MV_PAR06","Analitico","Analitico","Analitico","","","Sintetico","Sintetico","Sintetico","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Relatorio?     ","Relatorio?     ","Relatorio?     ","mv_ch7","C",01,0,2,"C","","MV_PAR07","Poder3","Poder3","Poder3","","","NF Beneficiamento","NF Beneficiamento","NF Beneficiamento","","","","","","","","","","","","","","","","","","","","",""})

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
