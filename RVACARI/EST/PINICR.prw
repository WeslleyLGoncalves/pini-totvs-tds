#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  07/05/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PINICR()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "Controle de Pedidos x Reserva"
Local nLin         	:= 80
					  //   453421     01     02021278          COMO PREPARAR ORCAMENTOS DE OB      T5   26/07/2007       1      92      16      76
Local Cabec1       	:= "   Pedido   Item     Produto           Descri��o do Produto                Arm  Emiss�o    Qtde PV Estoque  Reseva   Saldo"
Local Cabec2       	:= ""
Local imprime     	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "PINICR" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "PINICR" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	:= "SB2"

Private cPerg    := "PINICR"

dbSelectArea("SB2")
dbSetOrder(1)
                              

pergunte(cPerg,.T.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  07/05/14   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������                   

cQuery := " SELECT SC6.C6_NUM, SC5.C5_NOTA, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_LOCAL, SC6.C6_QTDVEN, SB2.B2_QATU, SB2.B2_RESERVA, SB2.B2_QATU - SB2.B2_RESERVA AS SALDO, SC6.C6_DATA " + CRLF
cQuery += " FROM SC6010 SC6 " + CRLF
cQuery += " JOIN SC5010 SC5 ON SC5.D_E_L_E_T_ != '*'  " + CRLF
cQuery += "      AND SC6.C6_FILIAL = SC5.C5_FILIAL  " + CRLF
cQuery += "      AND SC5.C5_NUM = SC6.C6_NUM  " + CRLF
cQuery += "      AND SC5.C5_CLIENTE = SC6.C6_CLI  " + CRLF
cQuery += "      AND SC5.C5_LOJACLI = SC6.C6_LOJA " + CRLF
cQuery += " JOIN SB2010 SB2 ON SB2.D_E_L_E_T_ != '*' " + CRLF
cQuery += "      AND SB2.B2_COD = SC6.C6_PRODUTO " + CRLF
cQuery += "      AND SB2.B2_LOCAL = SC6.C6_LOCAL " + CRLF
cQuery += " JOIN SB1010 SB1 ON SB1.D_E_L_E_T_ != '*' " + CRLF
cQuery += "      AND SB1.B1_COD = SC6.C6_PRODUTO  " + CRLF
cQuery += "      AND SB1.B1_FILIAL = '  ' " + CRLF
cQuery += " WHERE SC6.D_E_L_E_T_ != '*' " + CRLF
cQuery += " AND SC6.C6_FILIAL = '01' " + CRLF
cQuery += " AND SC6.C6_LOCAL IN ('T5', 'T6') " + CRLF
cQuery += " AND SB1.B1_TIPO NOT IN ('RE', 'DC') " + CRLF
cQuery += " AND SC5.C5_NOTA = ' '  " + CRLF
cQuery += " AND SC5.C5_LIBEROK != ' '  " + CRLF
cQuery += " AND NOT EXISTS (SELECT D2_PEDIDO FROM SD2010 SD2 WHERE SD2.D2_PEDIDO = SC6.C6_NUM) " + CRLF
cQuery += " AND SC6.C6_DATA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+ CRLF
cQuery += " AND SC6.C6_LOCAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + CRLF
cQuery += " AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + CRLF
cQuery += " ORDER BY SC6.C6_NUM, SC6.C6_DATA "+ CRLF 

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRB", .F., .T.)

dbGoTop()
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   //SC6.C6_NUM, SC5.C5_NOTA, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_LOCAL, SC6.C6_QTDVEN, SB2.B2_QATU, SB2.B2_RESERVA, SB2.B2_QATU - SB2.B2_RESERVA AS SALDO
   @nLin,03 	  PSAY TRB->C6_NUM + SPACE(4)
   @nLin,PCOL()+1 PSAY TRB->C6_ITEM + SPACE(4)
   @nLin,PCOL()+1 PSAY TRB->C6_PRODUTO + SPACE(2)
   @nLin,PCOL()+1 PSAY TRB->C6_DESCRI + SPACE(05)
   @nLin,PCOL()+1 PSAY TRB->C6_LOCAL + SPACE(2)
   @nLin,PCOL()+1 PSAY STOD(TRB->C6_DATA)
   @nLin,PCOL()+1 PSAY TRB->C6_QTDVEN 	PICTURE("@E 999,999")
   @nLin,PCOL()+1 PSAY TRB->B2_QATU		PICTURE("@E 999,999")
   @nLin,PCOL()+1 PSAY TRB->B2_RESERVA	PICTURE("@E 999,999")
   @nLin,PCOL()+1 PSAY TRB->SALDO		PICTURE("@E 999,999")

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

TRB->(DBCLOSEAREA("TRB"))

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return