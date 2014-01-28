#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Pfat034()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("LIN,LI,WNREL,NTAMNF,CSTRING,mhora")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT034   �Autor: Solange Nalini         � Data:   10/01/98 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Emissao de etiquetas de clientes                           � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Nota Fiscal                       �
//� mv_par02             // Ate a Nota Fiscal                    �
//����������������������������������������������������������������
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
limite:=132
titulo :=PADC(" ETIQUETAS",74)
cDesc1 :=PADC("Este programa ira emitir ETIQUETAS DE CLIENTES",74)

cDesc2 :=""
cDesc3 :=PADC("da Nfiscal",74)
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="TESTE"
cPerg:="FAT004"
nLastKey:= 0
lContinua := .T.
Lin:=0
LI:=0
MHORA      := TIME()
wnrel    := "TETIQ_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)



//�����������������������������������������������������������Ŀ
//� Tamanho do Formulario de Nota Fiscal (em Linhas)          �
//�������������������������������������������������������������

nTamNf:=72     // Apenas Informativo

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//���������������������������������������������������������������������������

Pergunte(cPerg,.T.)               // Pergunta no SX1

cString:="SA1"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

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

//VerImp()

                DbSelectArea("Sa1")
                DBGOTOP()
                SET DEVIce TO PRINTer
                DO WHILE .NOT. EOF()
                @ LIN+LI,001 psay SA1->A1_NOME
                DBSKIP()
                @ LIN+LI,045 psay SA1->A1_NOME
                DBSKIP(-1)
                LI:=LI+1
                @ LIN+LI,001 psay SA1->A1_END
                DBSKIP()
                @ LIN+LI,045 psay SA1->A1_END
                DBSKIP(-1)
                LI:=LI+1
                @ LIN+LI,001 psay SA1->A1_MUN
                DBSKIP()
                @ LIN+LI,045 psay SA1->A1_MUN
                DBSKIP(-1)
                LI:=LI+1
                @ LIN+LI,001 psay SA1->A1_EST
                DBSKIP()
                @ LIN+LI,045 psay SA1->A1_EST
                DBSKIP(-1)
                LI:=LI+1
                @ LIN+LI,001 psay SA1->A1_CEP
                DBSKIP()
                LI:=LI+1
                @ LIN+LI,045 psay SA1->A1_CEP
                DBSKIP()
                LI:=LI+1
                setprc(0,0)
                lin:=prow()
            ENDDO

      @ LIN+LI,00 psay ' '
                SetPrc(0,0)
                liN := 14
                LI:=0
                SET DEVIce TO SCREEN
                DbSelectArea("SE1")
                RecLock("SE1",.F.)
                   replace E1_DUPLEM WITH 'S'
                se1->(msUnlock())
RETURN .T.

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

