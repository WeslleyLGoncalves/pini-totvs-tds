#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr05()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("MCLI,MVALOR,_ACAMPOS,_CNOME,CINDEX1,CKEY1")
SetPrvt("CINDEX2,CKEY2,_CFILTRO,CARQ,CKEY,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR05   �Autor: Rosane Rodrigues       � Data:   13/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE CONTRATOS DE PUBLICIDADE A FATURAR            � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Da Data                      �
//�   mv_par02 = At� a Data                   �
//���������������������������������������������

cPerg    := "FAT022"
IF .NOT. PERGUNTE(CPERG)
   RETURN
ENDIF

cString  := "SZS"
cDesc1   := PADC("Este programa emite o relat�rio dos contratos de Publicidade a Faturar ",70)
cDesc2   := PADC("com data de circula��o a partir da data inicial selecionada",70)
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR05"
limite   := 80
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Contratos de Publicidade a Faturar"
cCabec1  := "Data de Circula��o a partir de : " + DTOC(MV_PAR01)
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR05_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(20)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)
mcli     := 0
mvalor   := 0

SetDefault(aReturn,cString)

IF NLASTKEY==27 .OR. NLASTKEY==65
   RETURN
ENDIF

// �����������������������������������������������Ŀ
// �Chama Relatorio                                �
// �������������������������������������������������
#IFDEF WINDOWS
   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    RptStatus({|| Execute(RptDetail) })
#ELSE
   RptDetail()
#ENDIF
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do corpo do relatorio                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

_aCampos := {{"CODCLI","C",6 ,0} ,;
             {"NOME"  ,"C",40,0} ,;
             {"VALOR" ,"N",10,2}}

_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"FATPB",.F.,.F.)
CINDEX1:=CRIATRAB(NIL,.F.)
CKEY1:="CODCLI"
INDREGUA("FATPB",CINDEX1,CKEY1,,,"SELECIONANDO REGISTROS DO ARQ")
CINDEX2:=CRIATRAB(NIL,.F.)
CKEY2:="DESCEND(VALOR)"
INDREGUA("FATPB",CINDEX2,CKEY2,,,"SELECIONANDO REGISTROS DO ARQ")
Set Index To
DbSetIndex(CINDEX1)
DbSetIndex(CINDEX2)

DbSelectArea("SC5")
DbSetOrder(01)

DbSelectArea("SA1")
DbSetOrder(01)

DBSELECTAREA("SZS")
_cFiltro := "ZS_FILIAL == '"+xFilial("SZS")+"'"
_cFiltro := _cFiltro+".and.DTOS(ZS_DTCIRC)>=DTOS(CTOD('"+DTOC(MV_PAR01)+"'))"
_cFiltro := _cFiltro+".and.ZS_EDICAO <> 0 .AND. ZS_SITUAC <> 'CC'"
cArq     := CriaTrab(NIL,.F.)
cKey     := "ZS_NUMAV+ZS_ITEM"
IndRegua("SZS",cArq,cKey,,_cFiltro,"Selecionando registros .. ")
dbGotop()
SetRegua(Reccount())

Do While !eof()  
   IncRegua()

   DbSelectArea("SC5")
   DbSeek(xFilial()+SZS->ZS_NUMAV)
   
   if .not. found() .or. sc5->c5_tptrans == '03' .or. sc5->c5_tptrans == '10' .or. sc5->c5_tptrans == '07'
      dbselectarea("SZS")
      DBSKIP()
      LOOP
   ENDIF

   DbSelectArea("SA1")
   DbSeek(xFilial()+SZS->ZS_CODCLI)

   DBSELECTAREA("FATPB")
   DBSETORDER(01)
   DBSEEK(SZS->ZS_CODCLI)
   IF FOUND()
      RECLOCK("FATPB",.F.)
      FATPB->VALOR  := FATPB->VALOR + SZS->ZS_VALOR
      MSUNLOCK()
   ELSE
      RECLOCK("FATPB",.T.)
      FATPB->CODCLI := SZS->ZS_CODCLI
      FATPB->NOME   := SA1->A1_NOME
      FATPB->VALOR  := SZS->ZS_VALOR
      MSUNLOCK()
   ENDIF

   DbSelectArea("SZS")
   DbSkip()
   IncRegua()
Enddo

DBSELECTAREA("FATPB")
DBSETORDER(02)
DBGOTOP()
DO WHILE .NOT. EOF()
   if nLin > 60
      nLin    := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
      nLin    := nLin + 2
      @ nlin,0 PSAY "Cliente   Nome do Cliente                            Valor"
      nLin := nLin + 1
      @ nlin,0  PSAY "------   ----------------------------------------   -----------"
      nLin := nLin + 1
   Endif
   nLin := nLin + 1
   @ nlin,00 PSAY FATPB->CODCLI
   @ nlin,10 PSAY FATPB->NOME
   @ nlin,53 PSAY FATPB->VALOR
   nLin   := nLin + 1
   MCLI   := MCLI + 1
   MVALOR := MVALOR + FATPB->VALOR
   DBSKIP()
ENDDO
IF MVALOR > 0
   nLin := nLin + 2
   @ nlin,00   PSAY "TOTAL DE CLIENTES: "
   @ nlin,27   PSAY MCLI   PICTURE "@E 999999"
   @ nlin+1,00 PSAY "TOTAL GERAL .....: "
   @ nlin+1,19 PSAY MVALOR PICTURE "@E 999,999,999.99"
ENDIF

DBSELECTAREA("FATPB")
DBCLOSEAREA()

DbSelectarea("SZS")
RetIndex("SZS")
DbSelectarea("SA1")
RetIndex("SA1")
DbSelectarea("SC5")
RetIndex("SC5")

Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



