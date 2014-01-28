#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr12()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,_MTOT")
SetPrvt("_MAV,_NAV,NLIN,TITULO,CCABEC1,CCABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL,_CARQ,_CKEY,_CFILTRO")
SetPrvt("AREGS,I,J,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR12   �Autor: Rosane Rodrigues       � Data:   27/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE INSERCOES LIBERADAS E NAO FATURADAS - ESPECIAL� ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Periodo Inicial              �
//�   mv_par02 = Periodo Final                �
//�   mv_par03 = Impressao Resumida S/N       �
//���������������������������������������������

cPerg    := "PFAT24"
ValidPerg()
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SZV"
cDesc1   := PADC("Este programa emite o relat�rio das inser��es",70)
cDesc2   := PADC("liberadas e n�o faturadas por per�odo - Especiais",70)
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR12"
limite   := 80
aLinha   := { }
nLastKey := 0
_mtot    := 0
_mav     := 0
_nav     := SPACE(6)
nLin     := 80
titulo   := "Inser��es liberadas e n�o faturadas - Especiais"
cCabec1  := " "
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR12_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(14)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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

DBSELECTAREA("SZV")
_cArq     := CriaTrab(NIL,.F.)
_cKey     := "ZV_NUMAV"
_cFiltro := "ZV_FILIAL == '"+xFilial("SZV")+"'"
_cFiltro := _cFiltro+".and.DTOS(ZV_ANOMES)>=DTOS(CTOD('"+DTOC(MV_PAR01)+"'))"
_cFiltro := _cFiltro+".and.DTOS(ZV_ANOMES)<=DTOS(CTOD('"+DTOC(MV_PAR02)+"'))"
_cFiltro := _cFiltro+".and.ZV_SITUAC <> 'CC'"
IndRegua("SZV",_cArq,_cKey,,_cFiltro,"Selecionando registros .. ")

dbGotop()
SetRegua(Reccount()/2)

Do While !eof()  

   IncRegua()
   IF VAL(SZV->ZV_NFISCAL) <> 0 
      DbSkip()
      Loop
   ENDIF

   DbSelectArea("SA1")
   DbSetOrder(01)
   DbSeek(xFilial("SA1")+SZV->ZV_CODCLI)


    IF MV_PAR03 == 2        // IMPRESSAO RESUMIDA == NAO
        if _nav <> SPACE(6) .AND. _nav <> SZV->ZV_NUMAV
          nLin   := nLin + 2
          @ nlin,00 PSAY "TOTAL DA AV .........................................................: "
          @ nlin,86 PSAY _mav   PICTURE "@E 9,999,999.99"
          _mav   := 0
          nLin   := nLin + 2
          @ nlin,000 SAY REPLICATE ("-",132)
          nLin   := nLin + 2
        Endif

    ENDIF

    if nLin > 57
      cCabec1 := "Per�odo Inicial : " + DTOC(MV_PAR01) + SPACE(10) + "Per�odo Final : " + DTOC(MV_PAR02)
      cCabec2 := " " 
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 2
/*/
                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
                                1         2         3         4         5         6         7         8         9        10        11        12        13
/*/
      @ nlin,0  PSAY "Cliente       Nome do Cliente                                Num.Av       Parcela       Val.Parcela"
      nlin := nLin + 1                                                           
      @ nlin,0  PSAY "-------       ----------------------------------------       ------       -------       -----------"
      nLin := nLin + 2
   Endif


   @ nlin,000 PSAY SZV->ZV_CODCLI
   @ nlin,014 PSAY SA1->A1_NOME
   @ nlin,061 PSAY SZV->ZV_NUMAV
   @ nlin,074 PSAY STR(SZV->ZV_NPARC,2)+' / '+STR(SZV->ZV_TOTPARC,2)
   @ nlin,088 PSAY SZV->ZV_VALOR PICTURE "@E 999,999.99"

   nLin   := nLin + 1
   _mtot  := SZV->ZV_VALOR + _mtot
   _mav   := SZV->ZV_VALOR + _mav
   _nav   := SZV->ZV_NUMAV

   DbSelectArea("SZV")
   DbSkip()
Enddo

if _mtot <> 0
    IF MV_PAR03 == 2        // IMPRESSAO RESUMIDA == NAO
       nLin   := nLin + 2
       @ nlin,00 PSAY "TOTAL DA AV .........................................................: "
       @ nlin,86 PSAY _mav   PICTURE "@E 9,999,999.99"
       nLin   := nLin + 4
       @ nlin,00 PSAY "TOTAL GERAL .........................................................: "
       @ nlin,86 PSAY _mtot  PICTURE "@E 9,999,999.99"
    ELSE
       nLin   := nLin + 2
       @ nlin,00 PSAY "TOTAL GERAL .........................................................: "
       @ nlin,86 PSAY _mtot  PICTURE "@E 9,999,999.99"
    ENDIF
else
   cCabec1 := "Per�odo Inicial : " + DTOC(MV_PAR01) + SPACE(10) + "Per�odo Final : " + DTOC(MV_PAR02)
   cCabec2 := " " 
   nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
   nLin := nLin + 2
   @ nlin,0  PSAY "Cliente  Nome do Cliente                           Num.Av  Item   Produto    Ins/Qtde   Edi��o   Dt.Circ.   Val.Inser�ao   Cod.Mat."
   nlin := nLin + 1
   @ nlin,0  PSAY "-------  ----------------------------------------  ------  ----   --------   --------   ------   --------   ------------   --------"
Endif

DbSelectarea("SZV")
RetIndex("SZV")
Ferase(_cArq+OrdBagExt())

Roda(0,"",tamanho)
//Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
//        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

/*/
���������������������������������������������������������������������
������������������������������������������������������������������Ŀ�
��Funcao    �VALIDPERG� Autor � Jose Renato July � Data � 25.01.99 ��
������������������������������������������������������������������Ĵ�
��Descricao � Verifica perguntas, incluindo-as caso nao existam.   ��
������������������������������������������������������������������Ĵ�
��Uso       � SX1                                                  ��
������������������������������������������������������������������Ĵ�
��Release   � 3.0i - Roger Cangianeli - 12/05/99.                  ��
�������������������������������������������������������������������ٱ
���������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function VALIDPERG
Static Function VALIDPERG()

   cPerg    := PADR(cPerg,6)
   aRegs    := {}
   dbSelectArea("SX1")
   dbSetOrder(1)
   AADD(aRegs,{cPerg,"01","Periodo Inicial     ?","mv_ch1","D",08,0,2,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Periodo Final       ?","mv_ch2","D",08,0,2,"G","","mv_par02","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"03","Impressao Resumida  ?","mv_ch3","N",01,0,2,"C","","mv_par03","Sim","","","Nao","","","","","","","","","","",""})
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
