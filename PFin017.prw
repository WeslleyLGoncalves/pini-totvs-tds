#include "rwmake.ch"
#include "ap5mail.ch"
#INCLUDE "TOPCONN.CH"  //consulta SQL
/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFin017   �Autor  �Danilo C S Pala     � Data �  20041122   ���
�������������������������������������������������������������������������͹��
���Desc.     �Nova versao do programa de recebimentos por Stored Procedure���
���          �   														  ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFin017
Private _cTitulo  := "Recebimentos Stored Procedures"
setprvt("_aCampos, _cNome, caIndex, caChave, caFiltro, cQuery, contPed, _cMsgINFO, ContSzk")
Private cEmpresa := SM0->M0_CODIGO +"0"
Private contSZO := 0
Private contSZN := 0
Private MHORA     := TIME()
Private cArq      := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
Private naudit_id := 999999
Private cString := "\siga\arqtemp\"+ carq + ".dbf"           
Private nchave

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������


@ 010,001 TO 220,410 DIALOG oDlg TITLE _cTitulo
@ 010,010 SAY "Visualiza os relatorios j� emitidos."
@ 020,010 BUTTON "Pesquisar antigos" SIZE 60,11 ACTION   Processa({||Pesquisar()})
@ 040,010 BUTTON "Novo" SIZE 40,11 ACTION   Processa({||Novo()})
@ 090,010 SAY "By Danilo C S Pala"
@ 090,120 BUTTON "Fechar" SIZE 40,15 Action ( Close(oDlg) )
Activate Dialog oDlg CENTERED

Return

//**********************************************************************************************
//   DANILO_SA1
//**********************************************************************************************

//�����������������������������������Ŀ
//�Funcao para verificar se eh cliente�
//�������������������������������������

Static Function Pesquisar()
DbselectArea("SA1")
if RDDName() <> "TOPCONN"
	MsgStop("Este programa somente podera ser executado na versao SQL do SIGA Advanced.")
	Return nil
endif
DbClosearea("SA1")

setprvt("aCampos")
aCampos := {}
AADD(aCampos,{"ID","ID" })
AADD(aCampos,{"PARAMETROS"  ,"PARAMETROS"    })
AADD(aCampos,{"DURACAO","DURACAO"    })
AADD(aCampos,{"LINHAS", "LINHAS"      })
AADD(aCampos,{"USUARIO","USUARIO"    })


cQuery := "select audit_id as ID, Parametros, (fim - inicio)*60*24 DURACAO, qtd_linhas as Linhas, Usuario from danilo_auditoria"
TCQUERY cQuery NEW ALIAS "QUERYAudit"

@ 200,001 TO 400,600 DIALOG oDlg1 TITLE "QUERYAudit"
@ 6,5 TO 100,250 BROWSE "QUERYAudit" FIELDS aCampos                             
@ 020,260 SAY "Id:"
@ 020,270 GET naudit_id size 30,11
@ 060,260 BUTTON "Imprimir" SIZE 40,11 ACTION   Processa({||Imprimir(naudit_id)})
@ 070,260 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
DBCloseArea("QUERYAudit")

RETURN



Static Function Imprimir(naudit_id)
setprvt("nmax, natual")
DbselectArea("SA1")
if RDDName() <> "TOPCONN"
	MsgStop("Este programa somente podera ser executado na versao SQL do SIGA Advanced.")
	Return nil
endif
Farqtrab()                  

cQuery := "select * from DANILO_recebimentos where audit_id = "+ Alltrim(str(naudit_id))
TCQUERY cQuery NEW ALIAS "QUERY"

DbSelectArea("Query")
DBGoTop()
Procregua(Reccount())
nmax := REccount()
While ! Eof()
	DBSelectArea(cArq)
	RECLOCK(cArq,.T.)  //INSERIR .T.  
	Replace PEDIDO with query->pedido
	Replace TIPOOP with query->TIPOOP
	Replace DESCROP with query->DESCROP 
	Replace SERIE with  query->SERIE 
	Replace DTFAT with StoD(query->DTFAT )
	Replace BAIXA with StoD(query->BAIXA )
	Replace DTALT with  StoD(query->DTALT) 
	Replace VENCTO with  StoD(query->VENCTO )
	Replace VENCREAL with  StoD(query->VENCREAL )
	Replace NATUREZA with query->NATUREZA 
	Replace DESCNAT with  query->DESCNAT 
	Replace DUPL with  query->DUPL 
	Replace PARCELA with  query->PARCELA
	Replace VLDUPL with query->VLDUPL 
	Replace VLPROD with  query->VLPROD 
	Replace PAGO with  query->PAGO 
	Replace DESCONTO with  query->DESCONTO 
	Replace AVENCER with  query->AVENCER 
	Replace VENCIDO with  query->VENCIDO 
	Replace CANCELADO with  query->CANCELADO 
	Replace LP with  query->lp
	Replace PORTADO with  query->PORTADO 
	Replace NOMPORT with  query->NOMPORT
	Replace CODPROM with  query->CODPROM 
	Replace CODCLI with  query->CODCLI
	Replace CODDEST with  query->CODDEST
	Replace TIPO with  query->TIPO
	Replace NOME with  query->NOME
	Replace MUN with  query->MUN
	Replace UF with  query->UF
	Replace ATIVIDA with  query->ATIVIDA
	Replace TELEFONE with  query->TELEFONE
	Replace VEND  with query->VEND
	Replace NOMEVEND with  query->NOMEVEND
	Replace REGIAO with  query->REGIAO
	Replace EQUIPE with  query->EQUIPE
	Replace DIVVEND with  query->DIVVEND
	Replace PRODUTO with  query->PRODUTO
	Replace DESCR with  query->DESCR
	Replace TITULO with  query->TITULO
	Replace EDICAO with  query->EDICAO
	Replace INADIMPL with  query->INADIMPL
	Replace FLUXO with  query->FLUXO
	Replace CGC with query->CGC
	MSUNLOCK(cARQ)
	DbSelectArea("Query")
	DBSkip()
	IncProc(Str(Recno(),7) + " de "+ alltrim(strzero(nmax,7)))

end
DbSelectArea(cArq)
COPY TO &cString VIA "DBFCDXADS" // 20121106 

DBCloseArea(cARQ)
DBCloseArea("Query")

MsgAlert("ARQUIVO GERADO: "+ "\siga\arqtemp\"+ CARQ)
RETURN







//���������������
//�converterData�
//���������������
static Function ConverterData(data_old)             //12345678
setprvt("data_new")                      //20030814
data_new := substr(data_old,7,2)+"/"+substr(data_old,5,2)+"/"+substr(data_old,3,2)
return data_new



//���������������������������������������������������������������������������Ŀ
//� Function  � FARQTRAB()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Cria arquivo de trabalho para guardar registros que serao     �
//�           � impressos em forma de etiquetas.                              �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������
Static Function FARQTRAB()

_aCampos := {}

AADD(_aCampos,{"PEDIDO"    ,"C",6  ,0})
AADD(_aCampos,{"TIPOOP"    ,"C",2  ,0})
AADD(_aCampos,{"DESCROP"   ,"C",50 ,0})
AADD(_aCampos,{"SERIE"     ,"C",3  ,0})
AADD(_aCampos,{"DTFAT "    ,"D",8  ,0})
AADD(_aCampos,{"BAIXA"     ,"D",8  ,0})
AADD(_aCampos,{"DTALT"     ,"D",8  ,0})
AADD(_aCampos,{"VENCTO "   ,"D",8  ,0})
AADD(_aCampos,{"VENCREAL"   ,"D",8  ,0})
AADD(_aCampos,{"NATUREZA"  ,"C",10 ,0})
AADD(_aCampos,{"DESCNAT"   ,"C",30 ,0})
AADD(_aCampos,{"DUPL"      ,"C",6  ,0})
AADD(_aCampos,{"PARCELA"   ,"C",1  ,0})
AADD(_aCampos,{"VLDUPL"    ,"N",12 ,2})
AADD(_aCampos,{"VLPROD"    ,"N",12 ,2})
AADD(_aCampos,{"PAGO"      ,"N",12 ,2})
AADD(_aCampos,{"DESCONTO"  ,"N",12 ,2})
AADD(_aCampos,{"AVENCER"   ,"N",12 ,2})
AADD(_aCampos,{"VENCIDO"   ,"N",12 ,2})
AADD(_aCampos,{"CANCELADO" ,"N",12 ,2})
AADD(_aCampos,{"LP"        ,"N",12 ,2})
AADD(_aCampos,{"PORTADO"   ,"C",3  ,0})
AADD(_aCampos,{"NOMPORT"   ,"C",40 ,0})
AADD(_aCampos,{"CODPROM"   ,"C",15 ,0})
AADD(_aCampos,{"CODCLI"    ,"C",6  ,0})
AADD(_aCampos,{"CODDEST"   ,"C",6  ,0})
AADD(_aCampos,{"TIPO"      ,"C",1  ,0})
AADD(_aCampos,{"NOME"      ,"C",40 ,0})
AADD(_aCampos,{"MUN "      ,"C",30 ,0})
AADD(_aCampos,{"UF"        ,"C",2  ,0})
AADD(_aCampos,{"ATIVIDA"   ,"C",40 ,0})    
AADD(_aCampos,{"TELEFONE"  ,"C",22 ,0})
AADD(_aCampos,{"VEND"      ,"C",6  ,0})
AADD(_aCampos,{"NOMEVEND"  ,"C",15 ,0})
AADD(_aCampos,{"REGIAO"    ,"C",3  ,0})
AADD(_aCampos,{"EQUIPE"    ,"C",15 ,0})
AADD(_aCampos,{"DIVVEND"   ,"C",40 ,0})
AADD(_aCampos,{"PRODUTO"   ,"C",40 ,0})
AADD(_aCampos,{"DESCR"     ,"C",40 ,0})
AADD(_aCampos,{"TITULO"    ,"C",40 ,0})
AADD(_aCampos,{"EDICAO"  ,"N",4 ,0})
AADD(_aCampos,{"INADIMPL"  ,"N",12 ,2})
AADD(_aCampos,{"FLUXO"     ,"N",12 ,2})
AADD(_aCampos,{"CGC"    ,"C",14 ,0})

_cNome := CriaTrab(_aCampos,.t.)

cIndex := CriaTrab(Nil,.F.)
cKey   := "Pedido+Dupl+Parcela"
dbUseArea(.T.,, _cNome,cArq,.F.,.F.)
cArq      := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
dbSelectArea(cArq)
MsAguarde({|| Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")},"Aguarde","Gerando Indice Temporario (TRB)...")

Return


Static Function Novo()           
                                         
cPerg:="PFT146"
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros PFt146                             �
//�������������������������������������������������������������������������Ĵ
//� mv_par01 Vencimento de:                                                 �
//� mv_par02 Vencimento at�:                                                �
//� mv_par03 Baixado   Em Aberto    Ambos                                   �
//���������������������������������������������������������������������������
If !Pergunte(cPerg)
	Return
Endif

cQuery := "select seq_auditoria.nextval from dual"
TCQUERY cQuery NEW ALIAS "QUERYChave"

DbSelectArea("QueryChave")
DBGoTop()              
nChave := QueryChave->nextval
DBCloseArea("QueryChave")     

      
//Verifica se a Stored Procedure Teste existe no Servidor
If TCSPExist("SP_RECEBIMENTOS")
	//cQuery := "begin exec danilo_financeiro.sp_recebimentos ('"+ cempresa +"', '"+ dtoS(ddatabase) + "', '"+ DTOS(MV_PAR01) +"', '"+ DTOS(MV_PAR02) +"' , "+ AllTrim(Str(MV_PAR03)) +", '"+ SUBS(CUSUARIO,7,15) +"' , "+ Alltrim(str(nchave)) +" ); end;"
	//TCSQLExec(cQuery)
	//aRet := TCSPExec("danilo_financeiro.sp_recebimentos","'"+ cempresa +"'", "'"+ dtoS(ddatabase) + "'", "'"+ DTOS(MV_PAR01) +"'", "'"+ DTOS(MV_PAR02) +"'", MV_PAR03 , "'"+ SUBS(CUSUARIO,7,15) +"'" , nchave )
	aRet := TCSPExec("SP_RECEBIMENTOS", cempresa, dtoS(ddatabase), DTOS(MV_PAR01), DTOS(MV_PAR02), MV_PAR03, MV_PAR04,SUBS(CUSUARIO,7,15) ,nchave )
	//cMsg := "Retorno de Variaveis vem em um array: "
	//MsgInfo(cMsg + CHR(13)+ "Elemento 1: "+aRet[1]+CHR(13)+"Elemento 2"+Str(aRet[2]),"TCSPExec()")
EndIf

      
Imprimir(nchave)
Return