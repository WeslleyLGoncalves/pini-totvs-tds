#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PINIRLP3  �Autor  Danilo C S Pala      � Data �  20110519   ���
�������������������������������������������������������������������������͹��
���Desc.     �  RELATORIO DE LOG DO PODER3                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PINIRLP3()
SetPrvt("MRET,")   
SetPrvt("_NREGSA1,NLASTKEY,NOPCX,_CCLIENTE,AHEADER,NUSADO")
SetPrvt("CTITULO,NLINGETD,AC,AR,ACOLS,_CSTR")
SetPrvt("_LPED,_ACAMPOS,_CNOMARQ,_CKEY,_CMSG,_CDTINIC")
SetPrvt("_CDTFIN,_CDTVENC,_CDTSUSP,_CMOTIVO,ACGD,CLINHAOK")
SetPrvt("CTUDOOK,LRETMOD2,cPedido")
MRET:='NOME'

//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
aHeader:={}
nUsado:=0
	
nUsado:=nUsado+1
aAdd( aHeader, { "Log de Poder3", "TEXTO", "", 80, 0,;
"AllWaysTrue()", "������", "C", "TRB", Space(1) } )

//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������
cTitulo:= "Log de Poder3"
	
//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
nLinGetD:=0

// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:=6

	
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
//AADD(aC,{"_cCliente" , {15,10}  , "Cliente "  , "@!",,, .F. })
//cAlias:="SA1"
cPedido :=  space(10)
//cPedido :=CriaVar("A1_NOME",.T.)
//M->&("cPedido") := CriaVar("cPedido",.T.)

//aAdd(aC,{"cPedido",{15,010},"Pedido","@!","u_AcharPcli()" ,,.T.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .T. se nao .F.
	
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
aCols := {}

//aAdd( aCols, { "Aqui aparecer�o os detalhes do pedido...", .F. } )
                              
//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
aCGD:= {30,5,125,200}
	
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk        := "AllWaysTrue()"
cTudoOk         := "AllWaysTrue()"
        
	                                                                                  
Private aPini := {}

Private cQuery 		:= ""
Private cRetorno	:= ""
aCols := {}// zerando o array acols
cQuery := "SELECT ZY5_FILIAL, ZY5_CLIENT, ZY5_LOJA, ZY5_SERIE, ZY5_DOC, ZY5_ITEM, ZY5_PROD, ZY5_TIPO, ZY5_OBS, ZY5_CLILOG, ZY5_LOJALO, ZY5_SERLOG, ZY5_DOCLOG, ZY5_PEDLOG, ZY5_TRANSF, ZY5_QTDLOG, ZY5_USUARI, ZY5_DATALO, D_E_L_E_T_, R_E_C_N_O_ FROM "+ RetSqlName("ZY5") +" ZY5 WHERE ZY5_FILIAL='"+ XFILIAL("ZY5") +"' AND ZY5_CLIENT='"+ ZZY->ZZY_CLIENT +"' AND ZY5_LOJA='"+ ZZY->ZZY_LOJA +"' AND ZY5_SERIE='"+ ZZY->ZZY_SERIE +"' AND ZY5_DOC='"+ ZZY->ZZY_DOC +"' AND ZY5_ITEM='"+ ZZY->ZZY_ITEMNF +"' AND ZY5_PROD='"+ ZZY->ZZY_COD +"' AND D_E_L_E_T_<>'*'"
DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PINILOG", .T., .F. )
DbSelectArea("PINILOG")
dbGotop()                
aPini := {}

If !EOF()
	WHILE !EOF()
		aAdd( aCols, { "Tipo: "+ PINILOG->ZY5_TIPO +"/ Obs: "+ PINILOG->ZY5_OBS, .F. } )
		aAdd( aCols, { "  NFEntrada: "+ PINILOG->ZY5_SERLOG + PINILOG->ZY5_DOCLOG + "/ Pedido: "+ PINILOG->ZY5_PEDLOG +"/ Transf: "+ PINILOG->ZY5_TRANSF + "  Qtd: "+ transform(PINILOG->ZY5_QTDLOG, "@E 9999,99"), .F. } )
		aAdd( aCols, { "  Usuario: "+ PINILOG->ZY5_USUARI + "  Data: "+ dtoc(STOD(SUBSTR(PINILOG->ZY5_DATALO,1,8))) + SUBSTR(PINILOG->ZY5_DATALO,9,9), .F. } )
		aAdd( aCols, { "--------------------------------------------------------------------", .F.} )
		DbSelectArea("PINILOG")
		DBSkip()
	END
	//��������������������������������������������������������������Ŀ
	//� Chamada da Modelo2                                           �
	//����������������������������������������������������������������
	lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{125,50,500,635})
Else
	//aAdd( aCols, { "Log nao localizado", .F. } )
	MRET := nil
	MsgInfo("Log nao localizado para este item")
Endif

DbSelectArea("PINILOG")
DBCloseArea("PINILOG")

Return(MRET)                