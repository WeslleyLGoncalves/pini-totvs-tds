#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfat056()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_CARQ,_CKEY,_CFILTRO,_MQTDE,AREGS,I")
SetPrvt("J,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR10   �Autor: Fabio William          � Data:   27/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE PROGRAMACOES NAO LIBERADAS - NUMERO DE AV     � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = AV Inicial                   �
//�   mv_par02 = AV Final                     �
//���������������������������������������������

cPerg    := "PFAT60"
ValidPerg()
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SZS"
cDesc1   := PADC("Este programa emite o relat�rio das programa��es n�o liberadas - AV",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR10"
limite   := 80
aLinha   := { }
nLastKey := 0

nLin     := 80
titulo   := "Programa��es n�o liberadas - AV"
cCabec1  := " "
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR10_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(20)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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

DBSELECTAREA("SZS")
_cArq     := CriaTrab(NIL,.F.)
_cKey     := "ZS_FILIAL+ZS_NUMAV+ZS_ITEM+STR(ZS_EDICAO,4)"
_cFiltro  := 'ZS_FILIAL=="'+xFilial()+'"'
_cFiltro  := _cFiltro + '.and.ZS_SITUAC <> "CC".AND.SZS->ZS_EDICAO <> 0'
_cFiltro  := _cFiltro + '.and.(ZS_CODMAT == SPACE(6) .OR. "0" $(ZS_CODMAT))'
IndRegua("SZS",_cArq,_cKey,,_cFiltro,"Selecionando registros .. ")

dbSeek( xFilial("SZS")+MV_PAR01,.T.)
SetRegua(Reccount()/2)

Do While !eof()  .and. SZS->ZS_NUMAV >= MV_PAR01 .and. SZS->ZS_NUMAV <= MV_PAR02

   IncRegua()
   IF VAL(SZS->ZS_CODMAT) <> 0  
      DbSkip()
      Loop
   ENDIF

   _mqtde := 0

   DbSelectArea("SA1")
   DbSetOrder(01)
   DbSeek(xFilial("SA1")+SZS->ZS_CODCLI)

   DbSelectArea("SC6")
   DbSetOrder(01)
   DbSeek(xFilial("SC6")+SZS->ZS_NUMAV+SZS->ZS_ITEM)
   _mqtde := SC6->C6_QTDVEN

   if nLin > 60
      cCabec1 := "AV Inicial : " + MV_PAR01 + SPACE(15) + "AV Final : " + MV_PAR02
      cCabec2 := " " 
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 2
/*/
                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                                1         2         3         4         5         6         7         8         9        10        11
/*/
      @ nlin,0  PSAY "Cliente    Nome do Cliente                             Num.Av    Item    Produto     Ins/Qtde    Edi��o    Dt.Circ.    Cod.Mat."
      nLin := nLin + 1
      @ nlin,0  PSAY "-------    ----------------------------------------    ------    ----    --------    --------    ------    --------    --------"
      nLin := nLin + 1
   Endif
   nLin := nLin + 1
   @ nlin,000 PSAY SZS->ZS_CODCLI
   @ nlin,011 PSAY SA1->A1_NOME
   @ nlin,055 PSAY SZS->ZS_NUMAV
   @ nlin,066 PSAY SZS->ZS_ITEM
   @ nlin,073 PSAY SUBST(SZS->ZS_CODPROD,1,8)
   @ nlin,085 PSAY STR(SZS->ZS_NUMINS,2)+" / "+STR(_mqtde,2)
   @ nlin,098 PSAY SZS->ZS_EDICAO
   @ nlin,107 PSAY DTOC(SZS->ZS_DTCIRC)
   @ nlin,122 PSAY SZS->ZS_CODMAT

   nLin := nLin + 1

   DbSelectArea("SZS")
   DbSkip()
Enddo

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

   cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
   aRegs    := {}
   dbSelectArea("SX1")
   dbSetOrder(1)
   AADD(aRegs,{cPerg,"01","AV Inicial: ","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","AV Final  : ","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
   For i := 1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j := 1 to FCount()
            If j <= Len(aRegs[i])
               FieldPut(j,aRegs[i,j])
            Endif
         Next
         SX1->(MsUnlock())
      Endif
   Next

Return
