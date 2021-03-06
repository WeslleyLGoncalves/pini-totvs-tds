#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr13()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,_MTOT")
SetPrvt("_MNOTA,NLIN,TITULO,CCABEC1,CCABEC2,CCANCEL")
SetPrvt("M_PAG,WNREL,_ACAMPOS,_CNOME,CINDEX,CKEY")
SetPrvt("_CARQ,_CKEY,_CFILTRO,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: RFATR13   쿌utor: Rosane Rodrigues       � Data:   27/01/00 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: RELATORIO DE N.F POR ESTADO                                � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : M줰ulo de Faturamento de Publicidade                       � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//�   Parametros Utilizados                   �
//�   mv_par01 = Periodo Inicial              �
//�   mv_par02 = Periodo Final                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cPerg    := "PFAT24"
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SD2"
cDesc1   := PADC("Este programa emite o relat줿io das N.F por Estado",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR13"
limite   := 80
aLinha   := { }
nLastKey := 0
_mtot    := 0
_MNOTA   := ' '
nLin     := 80
titulo   := "Notas Fiscais por Estado"
cCabec1  := " "
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR13_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(25)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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

_aCampos := {{"ESTADO"  ,"C",2, 0} ,;
             {"VALOR"   ,"N",10,2}}

_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"TRB",.F.,.F.)
CINDEX:=CRIATRAB(NIL,.F.)
CKEY:="ESTADO"
INDREGUA("TRB",CINDEX,CKEY,,,"SELECIONANDO REGISTROS DO ARQ")

DBSELECTAREA("SD2")
_cArq     := CriaTrab(NIL,.F.)
_cKey     := "D2_DOC+D2_SERIE"
_cFiltro := "D2_FILIAL == '"+xFilial("SD2")+"'"
_cFiltro := _cFiltro+".and.DTOS(D2_EMISSAO)>=DTOS(CTOD('"+DTOC(MV_PAR01)+"'))"
_cFiltro := _cFiltro+".and.DTOS(D2_EMISSAO)<=DTOS(CTOD('"+DTOC(MV_PAR02)+"'))"
_cFiltro := _cFiltro+".and.D2_TES == '670'"
//_cFiltro := _cFiltro+".and.D2_TES == '670'"
//_cFiltro := _cFiltro+".and.D2_TES == '670'"
IndRegua("SD2",_cArq,_cKey,,_cFiltro,"Selecionando registros .. ")

dbGotop()
SetRegua(Reccount()/13)

Do While !eof()  

   IncRegua()
   IF SD2->D2_DOC+SD2->D2_SERIE == _MNOTA
      DbSkip()
      Loop
   ENDIF

   DbSelectArea("SF2")
   DbSetOrder(01)
   Dbseek(xfilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE)
   If Found()
      DbSelectArea("TRB")
      DbSetOrder(01)
      DbSeek(SF2->F2_EST)
      If Found()
         Reclock("TRB",.f.)
         TRB->VALOR  := ((SF2->F2_VALBRUT - SF2->F2_DESCONT) + TRB->VALOR)
         MsUnlock()
      Else
         Reclock("TRB",.T.)
         TRB->ESTADO := SF2->F2_EST
         TRB->VALOR  := SF2->F2_VALBRUT - SF2->F2_DESCONT
         MsUnlock()
      Endif
   Endif

   _MNOTA := SD2->D2_DOC+SD2->D2_SERIE

   DbSelectArea("SD2")
   DbSkip()
Enddo

DbSelectArea("TRB")
DbSetOrder(01)
DbGotop()
Do While !eof()
   if nLin > 60
      cCabec1 := "Per죓do Inicial : " + DTOC(MV_PAR01) + SPACE(10) + "Per죓do Final : " + DTOC(MV_PAR02)
      cCabec2 := " " 
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 2
      @ nlin,05  PSAY "Estado" + SPACE(15) + "Valor Bruto  " 
      nlin := nLin + 1                                                           
      @ nlin,05  PSAY "------" + SPACE(15) + "-------------"
      nLin := nLin + 1
   Endif

   nLin := nLin + 1
   @ nlin,005 PSAY TRB->ESTADO
   @ nlin,025 PSAY TRB->VALOR  PICTURE "@E 9,999,999.99"

   nLin   := nLin + 1
   _mtot  := TRB->VALOR + _mtot

   DbSkip()
Enddo

If _mtot <> 0
   nlin := nlin + 2
   @ nlin,05 PSAY "TOTAL .......: "
   @ nlin,24 PSAY _mtot PICTURE "@E 99,999,999.99"
Endif

DbSelectArea("TRB")
DbCloseArea()

DbSelectarea("SD2")
RetIndex("SD2")
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

