#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfat061()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_MQTDE,_CARQ,_CKEY,_CFILTRO,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: RFATR15   쿌utor: Rosane Rodrigues       � Data:   28/01/00 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: RELATORIO DE PROGRAMA��ES ESPECIAIS PENDENTES              � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : M줰ulo de Faturamento de Publicidade                       � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//�   Parametros Utilizados                   �
//�   mv_par01 = A.V Inicial                  �
//�   mv_par02 = A.V Final                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cPerg    := "PFAT60"
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SC6"
cDesc1   := PADC("Este programa emite o relat줿io das programa뉏es especiais pendentes",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR15"
limite   := 80
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Programa뉏es Especiais Pendentes"
cCabec1  := " "
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR15_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(20)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)
_mqtde   := 0

SetDefault(aReturn,cString)

IF NLASTKEY==27 .OR. NLASTKEY==65
   RETURN
ENDIF

// 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// 쿎hama Relatorio                                �
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
#IFDEF WINDOWS
   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    RptStatus({|| Execute(RptDetail) })
#ELSE
   RptDetail()
#ENDIF
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝ptDetail � Autor � Ary Medeiros          � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao do corpo do relatorio                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

DBSELECTAREA("SC6")
_cArq     := CriaTrab(NIL,.F.)
_cKey     := "C6_NUM+C6_ITEM"
_cFiltro := "C6_FILIAL == '"+xFilial("SC6")+"'"
_cFiltro := _cFiltro+".and.C6_TPPROG == 'E'"
IndRegua("SC6",_cArq,_cKey,,_cFiltro,"Selecionando registros .. ")

dbSeek(xfilial("SC6")+MV_PAR01,.T.)
SetRegua(Reccount()/7)

Do While !eof() .and. SC6->C6_NUM <= MV_PAR02
   IncRegua()
   _MQTDE := SC6->C6_QTDVEN

   DbSelectArea("SZS")
   DbSetOrder(01)
   DbSeek(xfilial("SZS")+SC6->C6_NUM+SC6->C6_ITEM)
   Do While SC6->C6_NUM+SC6->C6_ITEM == SZS->ZS_NUMAV+SZS->ZS_ITEM
      IncRegua()
      IF SZS->ZS_EDICAO <> 0 .OR. SZS->ZS_SITUAC == 'CC'
         DbSkip()
         Loop
      ENDIF

      DbSelectArea("SA1")
      DbSetOrder(01)
      DbSeek(xFilial("SA1")+SZS->ZS_CODCLI)

      if nLin > 60
         cCabec1 := "A.V Inicial : " + MV_PAR01 + SPACE(10) + "A.V Final : " + MV_PAR02
         cCabec2 := " " 
         nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
         nLin := nLin + 2
/*/
                         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
                                1         2         3         4         5         6         7         8         9        10        11        12        13
/*/
         @ nlin,0  PSAY "Cliente  Nome do Cliente                           Num.Av  Item   Produto    Ins/Qtde   Edi눯o"
         nlin := nLin + 1
         @ nlin,0  PSAY "-------  ----------------------------------------  ------  ----   --------   --------   ------"
         nLin := nLin + 1
      Endif

      nLin := nLin + 1
      @ nlin,000 PSAY SZS->ZS_CODCLI
      @ nlin,009 PSAY SA1->A1_NOME
      @ nlin,051 PSAY SZS->ZS_NUMAV
      @ nlin,060 PSAY SZS->ZS_ITEM
      @ nlin,066 PSAY SUBST(SZS->ZS_CODPROD,1,8)
      @ nlin,077 PSAY STR(SZS->ZS_NUMINS,2)+" / "+STR(_mqtde,2)
      @ nlin,088 PSAY SZS->ZS_EDICAO
      nLin   := nLin + 1

      DbSelectArea("SZS")
      DbSkip()
   Enddo
   DbSelectArea("SC6")
   DbSkip()
Enddo

If _mqtde == 0
   cCabec1 := "A.V Inicial : " + MV_PAR01 + SPACE(10) + "A.V Final : " + MV_PAR02
   cCabec2 := " " 
   nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
   nLin := nLin + 2
   @ nlin,0  PSAY "Cliente  Nome do Cliente                           Num.Av  Item   Produto    Ins/Qtde   Edi눯o"
   nlin := nLin + 1
   @ nlin,0  PSAY "-------  ----------------------------------------  ------  ----   --------   --------   ------"
Endif

DbSelectarea("SZS")
RetIndex("SZS")
Ferase(_cArq+OrdBagExt())

// Roda(0,"",tamanho)
Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

