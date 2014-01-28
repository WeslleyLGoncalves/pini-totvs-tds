#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfat063()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR17   �Autor: Rosane Rodrigues       � Data:   01/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE VENDEDORES DE PUBLICIDADE                     � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Vendedor Inicial             �
//�   mv_par02 = Vendedor Final               �
//�   mv_par03 = Regi�o  Inicial              �
//�   mv_par04 = Regi�o  Final                �
//���������������������������������������������

cPerg    := "PFIN01"
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SA3"
cDesc1   := PADC("Este programa emite o relat�rio de vendedores de Publicidade",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR17"
limite   := 80 
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Vendedores de Publicidade"
cCabec1  := " "
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR17_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(23)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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

DbSelectArea("SA3")
DbSetorder(01)
dbGotop()
SetRegua(Reccount())

Do While !eof()  
   IncRegua()

   If SA3->A3_COD < MV_PAR01 .OR. SA3->A3_COD > MV_PAR02 .OR. SA3->A3_TIPOVEN <> 'CT'
      DbSelectArea("SA3")
      DbSkip()
      Loop
   ENDIF

   If nlin > 60
      cCabec1 := "Vendedor Inicial : "+MV_PAR01+SPACE(10)+"Vendedor Final : "+MV_PAR02
      cCabec2 := " " 
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 2
      @ nlin,00 PSAY "Vendedor      Nome do Vendedor                              Regi�o"
      nlin := nLin + 1                                                           
      @ nlin,00 PSAY "---------     ----------------------------------------      ------"
      nLin := nLin + 1
   Endif
 
   @ nlin,01 PSAY SA3->A3_COD
   @ nlin,14 PSAY SA3->A3_NOME
   @ nlin,61 PSAY SA3->A3_REGIAO
   nLin := nLin + 1

   DbSelectArea("SA3")
   DbSkip()
Enddo

DbSelectarea("SA3")
RetIndex("SA3")

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
