#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr29()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_ACAMPOS,_CARQTMP,_CKEY,_CARQ,_CFILTRO,_AREV")
SetPrvt("_NPOS,_NVEZES,AREGS,I,J,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: RFATR29   쿌utor: Roger Cangianeli       � Data:   10/03/00 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: RELATORIO DE ANUNCIOS VENDIDOS POR REVISTA / EDICAO        � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : M줰ulo de Faturamento de Publicidade                       � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//�   Parametros Utilizados                   �
//�   mv_par01 = Dt Inicial                   �
//�   mv_par02 = Dt Final                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
cPerg    := "FATR29"
ValidPerg()
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SZS"
cDesc1   := PADC("Este programa emite o relat줿io de anuncios vendidos por revista ",70)
cDesc2   := PADC("/ edicao.                                                        ",70)
cDesc3   := PADC("Especifico Editora PINI Ltda. ",70)
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "FATR29"
limite   := 80
aLinha   := { }
nLastKey := 0

nLin     := 80
titulo   := "Anuncios Vendidos por Revista/Edicao. Periodo "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
cCabec1  := " "
cCabec2  := " "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "FATR29_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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
굇쿑un뇙o    쿝ptDetail � Autor � Roger Cangianeli      � Data � 10.03.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao do corpo do relatorio                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()


_aCampos := {}
aAdd(_aCampos, { "REVISTA", "C", 10, 0 })
aAdd(_aCampos, { "EDICAO",  "C", 06, 0 })
aAdd(_aCampos, { "DESCR",   "C", 36, 0 })
aAdd(_aCampos, { "QUANT",   "N", 06, 0 })
aAdd(_aCampos, { "VALBRUT", "N", 12, 2 })
aAdd(_aCampos, { "VALLIQ",  "N", 12, 2 })

_cArqTmp := CriaTrab(_aCampos, .T.)
dbUseArea(.t.,, _cArqTmp, "TRB", .f., .f.)
IndRegua("TRB",_cArqTmp, "REVISTA+EDICAO+DESCR",,,"Indexando Arq.Trabalho...")

dbSelectArea("SZS")
_cKey     := "ZS_FILIAL+DTOS(ZS_DTCIRC)+ZS_CODVEIC+STR(ZS_EDICAO,4)+ZS_NUMAV+ZS_ITEM+STR(ZS_NUMINS)"
_cArq     := CriaTrab(NIL,.F.)
_cFiltro  := 'ZS_FILIAL=="'+xFilial('SZS')+'".and.ZS_SITUAC #"CC".and.SZS->ZS_EDICAO # 0'
IndRegua("SZS",_cArq,_cKey,,_cFiltro,"Selecionando registros .. ")

dbSeek( xFilial("SZS")+DTOS(MV_PAR01),.T.)
SetRegua(Reccount()/2)

_aRev := {}
While !eof() .and. SZS->ZS_DTCIRC <= MV_PAR02

   IncRegua()

   If Empty(SZS->ZS_CODMAT)
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SC6")
   DbSetOrder(01)
   DbSeek(xFilial("SC6")+SZS->ZS_NUMAV+SZS->ZS_ITEM)

   dbSelectArea("SC5")
   dbSetOrder(1)
   dbSeek(xFilial("SC5")+SC6->C6_NUM)

   dbSelectArea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)


   dbSelectArea("TRB")
   If !dbSeek(SB1->B1_TITULO+STR(SZS->ZS_EDICAO, 6, 0)+Subs(SB1->B1_DESC, 1, 36), .F.)
        RecLock("TRB", .T.)
        TRB->REVISTA := SB1->B1_TITULO
        TRB->EDICAO  := STR(SZS->ZS_EDICAO, 6, 0)
        TRB->DESCR   := Subs(SB1->B1_DESC, 1, 36)
        TRB->QUANT   := 1
        TRB->VALBRUT := SZS->ZS_VALOR
        TRB->VALLIQ  := IIF(SC5->C5_TPTRANS $ "04/05", SZS->ZS_VALOR*0.8, SZS->ZS_VALOR )
        msUnlock()

   Else
        RecLock("TRB", .F.)
        TRB->QUANT   := TRB->QUANT + 1
        TRB->VALBRUT := TRB->VALBRUT + SZS->ZS_VALOR
        TRB->VALLIQ  := TRB->VALLIQ  + IIF(SC5->C5_TPTRANS $ "04/05", SZS->ZS_VALOR*0.8, SZS->ZS_VALOR )
        msUnlock()

   EndIf

   DbSelectArea("SZS")
   DbSkip()

End



dbSelectArea("SZS")
dbGoTop()
While !EOF()

   If nLin > 60
/*/
                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                            1         2         3         4         5         6         7         8         9        10        11
/*/
      cCabec1 := "REVISTA EDICAO DESCRICAO DO ANUNCIO                 QTDE  VL.BRUTO   VL.LIQUIDO "
      cCabec2 := "======= ====== ==================================== ====  ========== ==========="
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 2
   Endif

   nLin := nLin + 1
   @ nlin,000 PSAY TRB->REVISTA
   @ nlin,008 PSAY TRB->EDICAO
   @ nlin,015 PSAY TRB->DESCR
   @ nlin,052 PSAY STR(TRB->QUANT, 6, 0)
   @ nlin,058 PSAY STR(TRB->VALBRUT, 10, 2)
   @ nlin,069 PSAY STR(TRB->VALLIQ, 10, 2)
   nLin := nLin + 1

   _nPos := aScan(_aRev, {|x| x[1] == TRB->REVISTA } )
   If _nPos == 0
        aAdd(_aRev, { TRB->REVISTA, TRB->QUANT, TRB->VALBRUT, TRB->VALLIQ } )
   Else
        _aRev[_nPos, 2] := _aRev[_nPos, 2] + TRB->QUANT
        _aRev[_nPos, 3] := _aRev[_nPos, 3] + TRB->VALBRUT
        _aRev[_nPos, 4] := _aRev[_nPos, 4] + TRB->VALLIQ
   EndIf

   dbSkip()

End



/*/
            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      1         2         3         4         5         6         7         8         9        10        11
/*/
cCabec1 := "REVISTA         QTDE        VL.BRUTO            VL.LIQUIDO "
cCabec2 := "=======         ====        ==========          ==========="
nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
nLin := nLin + 2

For _nVezes := 1 to Len(_aRev)
    @ nlin,000 PSAY _aRev[_nVezes, 1]
    @ nlin,016 PSAY Str( _aRev[_nVezes, 2], 4 )
    @ nlin,028 PSAY Str( _aRev[_nVezes, 3], 10, 2 )
    @ nlin,048 PSAY Str( _aRev[_nVezes, 4], 10, 2 )
    nLin := nLin + 2
    If nLin > 60
        nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
        nLin := nLin + 2
    EndIf
Next

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

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
귿컴컴컴컴컴쩡컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커�
교Funcao    쿣ALIDPERG� Autor � Jose Renato July � Data � 25.01.99 낢
궁컴컴컴컴컴탠컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑�
교Descricao � Verifica perguntas, incluindo-as caso nao existam.   낢
궁컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑�
교Uso       � SX1                                                  낢
궁컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑�
교Release   � 3.0i - Roger Cangianeli - 12/05/99.                  낢
굼컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function VALIDPERG
Static Function VALIDPERG()

   cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
   aRegs    := {}
   dbSelectArea("SX1")
   dbSetOrder(1)
   AADD(aRegs,{cPerg,"01","Data Inicial: ","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Data Final  : ","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
   For i := 1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j := 1 to FCount()
            If j <= Len(aRegs[i])
               FieldPut(j,aRegs[i,j])
            Endif
         Next
         MsUnlock()
      Endif
   Next

Return

