#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Pfat015()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("TITULO,CDESC1,CTITULO,CPERG,NCARACTER,TAMANHO")
SetPrvt("LIMITE,M_PAG,LCONTINUA,WNREL,L,CDESC2")
SetPrvt("CDESC3,NLASTKEY,CPROGRAMA,CCABEC1,CCABEC2,ARETURN")
SetPrvt("CSTRING,MCLIENTE,MNFISCAL,MEMISSAO,MNOMECLI,mhora")

/*/   SERA ALTERADO EM 14/06/00

1)INCLUIR FILTRO DA SERIE NO ARQ PERGUNTAS
  PARA ESTE PROGRAMA

2) ADAPTAR PARA FILTRAR A NOTA QUE EU QUERO, EU INFORMO, GERO ARQ TEMPORARIO, IMPRIMO
   E DELETO ARQ TEMPORARIO

LAY OUT DE IMPRESSAO IGUAL.

/*/
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴엽�
굇쿛rograma: PFAT015   쿌utor: Solange Nalini           � Data:  01/08/98 낢�
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴눙�
굇쿏escri뇚o:  Relatorio de N Fiscais Venda Mercantil - Protocolo         낢�
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so: Especifico para Clientes Microsiga                                낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define  Variaveis                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Nota Fiscal                       �
//� mv_par02             // Ate a Nota Fiscal                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

titulo    :=PADC(" RELATORIO DE NOTAS FISCAIS ENVIADAS - V.MERCANTIL  ",74)
cDesc1    :=PADC("Este programa emite relatorio de N.Fiscais de V.Mercantil ",74)
cTitulo   := ' **** RELATORIO DE NOTAS FISCAIS ENVIADAS **** '

CPERG     :='FAT004'
NCARACTER :=10
tamanho   :="P"
limite    :=80
M_PAG     :=1
lContinua := .T.
MHORA      := TIME()
wnrel    := "PFAT015_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
L:= 0
cDesc2 :=""
cDesc3 :=""
NLASTKEY:=0
cprograma:="PFAT015"

//                 10        20        30        40        50        60        70         80        90        100      110       120     130         140      150       160
//         123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12456789'

cCabec1:= 'N.FISCAL  EMISSAO   NOME DO CLIENTE                           DT.ENTREGA OBSERVACAO'
cCabec2:=" ========  =======   ========================================  ========== =========="

aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas selecionadas.                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If .Not. PERGUNTE(cPerg)
    Return
Endif

cString:="SC5"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica Posicao do Formulario na Impressora                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//�  Prepara regua de impress�o                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

DBSELECTAREA("SF2")
setregua(Reccount())

#IFDEF WINDOWS
       RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>        RptStatus({|| Execute(RptDetail)})
       Return
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>        Function RptDetail
Static Function RptDetail()
#ENDIF



Set Softseek on
dbSeek(xFilial()+mv_par01)

Do while SF2->F2_DOC>=MV_PAR01 .and. SF2->F2_DOC<=MV_PAR02
   If l==0
      CABEC(cTitulo,cCabec1,cCabec2,cPrograma,tamanho)
      L:=08
   Endif
   mCLIENTE := SF2->F2_CLIENTE
   mNFISCAL := SF2->F2_DOC
   mEMISSAO := SF2->F2_EMISSAO

   dbSelectArea("SA1")
   dbSeek(xFilial()+mCliente)

   IF FOUND()
      mNomecli := SA1->A1_NOME
   ENDIF

   @ L,00 PSAY mNFISCAL
   @ L,09 PSAY mEMISSAO
   @ L,20 PSAY mNOMECLI
   @ l,65 PSAY '__/__/__'
   @ l,74 PSAY '___________'

   IF L>60
      L:=0
      M_PAG:=M_PAG+1
   ELSE
      L:=L+1
   ENDIF

   dbSelectArea("SF2")

   DBSKIP()

   IncRegua()

ENDDO
@ L+2,03 PSAY '** FIM **'


SET DEVICE TO SCREEN
IF aRETURN[5] == 1
  Set Printer to
  dbcommitAll()
  ourspool(WNREL)
ENDIF
MS_FLUSH()

Return









// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02




