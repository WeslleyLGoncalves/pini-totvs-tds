#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
//Danilo C S Pala 20060320: dados de enderecamento do DNE, etiqueta com 9 linhas, sendo a ultima ponto(.)
//Danilo C S Pala 20100305: ENDBP
User Function Rfat006()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LI,LIN,CBTXT,CBCONT,NORDEM,ALFA")
SetPrvt("Z,M,TAMANHO,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CNATUREZA,ARETURN,SERNF,NOMEPROG")
SetPrvt("CPERG,NLASTKEY,LCONTINUA,NLIN,WNREL,CSTRING")
SetPrvt("TREGS,M_MULT,P_ANT,P_ATU,P_CNT,M_SAV20")
SetPrvt("M_SAV7,XNFISCAL,XSERIE,XPEDIDO,XCLI,XLOJA")
SetPrvt("XRESPCOB,CLIE_NOME,CLIE_ENDE,CLIE_BAIR,CLIE_MUNI,CLIE_ESTA")
SetPrvt("CLIE_CEP,mhora")

*���������������������������������������������������������������������������ͻ
*� Programa    : ETIQ.prx                                                    �
*� Descricao   : Etiquetas  de livros e assinaturas e P.Sistemas             �
*� Programador : Solange Nalini                                              �
*� Data        : 18/05/98                                                    �
*���������������������������������������������������������������������������ͼ

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // NF_inicial                           �
//� mv_par02             // NF_Final                             �
//����������������������������������������������������������������
li:=0
LIN:=0
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo :=PADC("ETIQUETAS  ",74)
cDesc1 :=PADC("Este programa ira emitir as Etiquetas p/N.Fiscais",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""

aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
SERNF:='LIV'
nomeprog:="etiqL"

cPerg:="FAT004"
nLastKey:= 0

lContinua := .T.
nLin:=0
MHORA := TIME()
wnrel    := "ETIQLIV_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������

Pergunte(cPerg,.T.)               // Pergunta no SX1

cString:="SZF"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
DO WHILE LCONTINUA
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif
LCONTINUA:=.T.

//��������������������������������������������������������������Ŀ
//�  Prepara regua de impress�o                                  �
//����������������������������������������������������������������
tregs := LastRec()-Recno()+1
m_mult := 1
IF tregs>0
   m_mult := 70/tregs
EndIf
p_ant := 4
p_atu := 4
p_cnt := 0
m_sav20 := dcursor(3)
m_sav7 := savescreen(23,0,24,79)
***

DBSELECTAREA('SC6')
DBSETORDER(4)
DbSeek(xFilial()+MV_PAR01)

IF .NOT. FOUND()
    RETURN
ENDIF
DO WHILE SC6->C6_NOTA>=MV_PAR01 .AND.  SC6->C6_NOTA<=MV_PAR02
  IF SC6->C6_SERIE#"LIV"
     DBSKIP()
     LOOP
  ENDIF
                XNFISCAL:=SC6->C6_NOTA
                XSERIE:=SC6->C6_SERIE
                XPEDIDO:=SC6->C6_NUM
                XCLI:=SC6->C6_CLI
                XLOJA:=SC6->C6_LOJA
                DO WHILE SC6->C6_NOTA==XNFISCAL
                   DBSKIP()
                   IF SC6->C6_NOTA#XNFISCAL
                      DBSKIP(-1)
                      EXIT
                   ENDIF
                ENDDO

    DBSELECTAREA("SC5")
    DBSETORDER(1)
    DBSEEK(XFILIAL()+XPEDIDO)
    IF FOUND()
       IF SC5->C5_RESPCOB==SPACE(40)
          XRESPCOB:= ' '
       ELSE
          XRESPCOB:='A/C '+SC5->C5_RESPCOB
       ENDIF
    ENDIF
//��������������������������������������������������������������Ŀ
//�  Inicio do levantamento dos dados do Cliente                 �
//����������������������������������������������������������������

                DbSelectArea("SA1")
                IF XLOJA=='1 '
                   XLOJA:='01'
                ENDIF
                DBSEEK(xFilial()+XCLI+XLOJA)
                CLIE_NOME := SA1->A1_NOME

                *������������������������������������������������������������������*
                * VERIFICA ENDERECO DA COBRANCA                                    *
                *������������������������������������������������������������������*

				//20100305 DAQUI
				IF SM0->M0_CODIGO =="03" .AND. SA1->A1_ENDBP ="S"
					DbSelectArea("ZY3")
					DbSetOrder(1)
					DbSeek(XFilial()+XCLI+XLOJA)
					CLIE_ENDE :=ZY3_END
					CLIE_BAIR :=ZY3_BAIRRO
					CLIE_MUNI :=ZY3_CIDADE
					CLIE_ESTA :=ZY3_ESTADO
					CLIE_CEP  :=ZY3_CEP
                ELSEIF SUBS(SA1->A1_ENDCOB,1,1)=='S' .AND. SM0->M0_CODIGO <>"03"  //ATE AQUI 20100305
                        DbSelectArea("SZ5")
                        DbSetOrder(1)
                        DbSeek(XFilial()+XCLI+XLOJA)
                        CLIE_ENDE :=ALLTRIM(Z5_TPLOG)+ " " + ALLTRIM(Z5_LOGR) + " " + ALLTRIM(Z5_NLOGR) + " " + ALLTRIM(Z5_COMPL) //20060320
                        CLIE_BAIR :=Z5_BAIRRO
                        CLIE_MUNI :=Z5_CIDADE
                        CLIE_ESTA :=Z5_ESTADO
                        CLIE_CEP  :=Z5_CEP
                ELSE
                        CLIE_ENDE := ALLTRIM(SA1->A1_TPLOG) + " " + ALLTRIM(SA1->A1_LOGR) + " " + ALLTRIM(SA1->A1_NLOGR) + " " + ALLTRIM(SA1->A1_COMPL) //20060320
                        CLIE_BAIR := SA1->A1_BAIRRO
                        CLIE_MUNI := SA1->A1_MUN
                        CLIE_ESTA := SA1->A1_EST
                        CLIE_CEP  := SA1->A1_CEP
               ENDIF
               GRAVA_TEMP()
               DBSELECTAREA("SC6")
               DBSKIP()
      p_cnt := p_cnt + 1
      p_atu := 3+INT(p_cnt*m_mult)
      If p_atu != p_ant
         p_ant := p_atu
          Restscreen(23,0,24,79,m_sav7)
          Restscreen(23,p_atu,24,p_atu+3,m_sav20)
       Endif
            ENDDO
      IMPETIQ()

ENDDO
DbSelectArea("SC6")
Retindex("SC6")
DbSelectArea("SC5")
Retindex("SC5")
DbSelectArea("SA1")
Retindex("SA1")
DbSelectArea("SZ5")
Retindex("SZ5")

set devi to screen
IF aRETURN[5] == 1
  Set Printer to
  dbcommitAll()
  ourspool(WNREL)
ENDIF
MS_FLUSH()

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> __RETURN()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02


// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> FUNCTION GRAVA_TEMP
Static FUNCTION GRAVA_TEMP()
DBSELECTAREA("SZF")

                Reclock("SZF",.t.)
                REPLA ZF_NF       WITH  XNFISCAL
                repla ZF_NOME     WITH  CLIE_NOME
//                REPLA ZF_RESPCOB  WITH  XRESPCOB
                repla ZF_END      WITH  CLIE_ENDE
                repla ZF_BAIRRO   WITH  CLIE_BAIR
                repla ZF_MUN      WITH  CLIE_MUNI
                repla ZF_EST      WITH  CLIE_ESTA
                repla ZF_CEP      WITH  CLIE_CEP
                SZF->(MSUnlock())
RETURN

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> FUNCTION IMPETIQ
Static FUNCTION IMPETIQ()
SET DEVI TO PRINT
DBSELECTAREA("SZF")
DBGOTOP()
SETPRC(0,0)
DO WHILE .NOT. EOF()
                @ LIN+LI,001 SAY ZF_NOME
                DBSKIP()
                @ LIN+LI,045 SAY ZF_NOME
                DBSKIP()
                @ LIN+LI,089 SAY ZF_NOME
                DBSKIP(-2)
                LI:=LI+1

                @ LIN+LI,001 SAY " "
                DBSKIP()
                @ LIN+LI,045 SAY " "
                DBSKIP()
                @ LIN+LI,089 SAY " "
                DBSKIP(-2)
                LI:=LI+1

                //20060317 DAQUI
                @ LIN+LI,001 PSAY SUBSTR(ZF_END,1,40)
                DBSKIP()
                @ LIN+LI,045 PSAY SUBSTR(ZF_END,1,40)
                DBSKIP()
                @ LIN+LI,089 PSAY SUBSTR(ZF_END,1,40) 
                DBSKIP(-2)
                LI:=LI+1
                
                @ LIN+LI,001 PSAY SUBSTR(ZF_END,41,40)
                DBSKIP()
                @ LIN+LI,045 PSAY SUBSTR(ZF_END,41,40)
                DBSKIP()
                @ LIN+LI,089 PSAY SUBSTR(ZF_END,41,40) 
                DBSKIP(-2)
                LI:=LI+1
                
                @ LIN+LI,001 PSAY SUBSTR(ZF_END,81,40)
                DBSKIP()
                @ LIN+LI,045 PSAY SUBSTR(ZF_END,81,40)
                DBSKIP()
                @ LIN+LI,089 PSAY SUBSTR(ZF_END,81,40) 
                DBSKIP(-2)
                LI:=LI+1                         
 //20060317 ATE AQUI


                @ LIN+LI,001 SAY ZF_BAIRRO
                DBSKIP()
                @ LIN+LI,045 SAY ZF_BAIRRO
                DBSKIP()
                @ LIN+LI,089 SAY ZF_BAIRRO
                DBSKIP(-2)
                LI:=LI+1

                @ LIN+LI,001 SAY SUBS(ZF_CEP,1,5)+'-'+SUBS(ZF_CEP,6,3)+'   ' +ZF_MUN+' ' +ZF_EST
                DBSKIP()
                @ LIN+LI,045 SAY SUBS(ZF_CEP,1,5)+'-'+SUBS(ZF_CEP,6,3)+'   ' +ZF_MUN+' ' +ZF_EST
                DBSKIP()
                @ LIN+LI,089 SAY SUBS(ZF_CEP,1,5)+'-'+SUBS(ZF_CEP,6,3)+'   ' +ZF_MUN+' ' +ZF_EST
                LI:=LI+1
                
                DBSKIP(-2)
                RecLock("SZF",.F.)             // RESTAURADA APOS TESTE
                DELETE
                SZF->(MSUnlock())

                DBSKIP()
                RecLock("SZF",.F.)             // RESTAURADA APOS TESTE
                DELETE
                SZF->(MSUnlock())

                DBSKIP()
                RecLock("SZF",.F.)             // RESTAURADA APOS TESTE
                DELETE
                SZF->(MSUnlock())
                DBSKIP()
                
				//20060316 DAQUI
				@ LIN+LI,001 PSAY "."
				LI:=LI+1          
				// 20060316 ATE AQUI       


                LI:=2
                setprc(0,0)
                lin:=prow()
            ENDDO
SET DEVI TO SCREEN


IF aRETURN[5] == 1
  Set Printer to
  dbcommitAll()
  ourspool(WNREL)
ENDIF
MS_FLUSH()

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

return



