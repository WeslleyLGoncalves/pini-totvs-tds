#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � PFAT069  � Autor � Andreia Silva         � Data � 15/03/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera relatorio de ocorrencias de acordo com o pedido de    ���
���          � venda.                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Editora Pini Ltda.                         ���
�������������������������������������������������������������������������Ĵ��
���Alteracoes� Alteracoes no Filtro. Andreia Silva      � Data � 27/03/00 ���
���          �                                          �      �          ���
���          � Consistencia C6_Produto. Raquel (Editora �      � 28/03/00 ���
���          � Pini).                                   �      �          ���
���          �                                          �      �          ���
���          � Inclusao de novos campos para impressao. �      � 28/03/00 ���
���          � Andreia Silva.                           �      �          ���
���          �                                          �      �          ���
���          � Informacao referente a Pedidos de Vendas �      � 07/04/00 ���
���          � nao encontrados. Andreia Silva.          �      �          ���
���          �                                          �      �          ���
���          � Informacao codigo/loja de cliente,confor �      � 10/04/00 ���
���          � me encontrado no SZ1 e nao mais no  SC6, �      �          ���
���          � em virtude de constar digitacao de Pedi- �      �          ���
���          � dos de Vendas incorretas. Andreia Silva. �      �          ���
���          �                                          �      �          ���
���          � Inclusao de validacao para Contas a Rece �      � 10/04/00 ���
���          � ber em Lucros & Perdas (E1_HIST=="LP".An �      �          ���
���          � dreia Silva.                             �      �          ���
���          �                                          �      �          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat069()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

SetPrvt("CSTRING,WNREL,TAMANHO,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,ARETURN,NOMEPROG,NLASTKEY,AORD,CBTXT")
SetPrvt("CPERG,LIMITE,_NREGTOT,CABEC1,CABEC2,CBCONT")
SetPrvt("LI,M_PAG,ADRIVER,NTIPO,CINDEX,CEXPRES")
SetPrvt("CARQTMP,NINDEX,CABEC3,_LFLAGE1,mhora")

cString  := "SZ1"
MHORA      := TIME()
wnRel    := "PFAT069_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
Tamanho  := "G"
Titulo   := "Ocorrencias - Especifico para Editora Pini Ltda."
cDesc1   := "Este programa imprimira as ocorrencias geradas de acordo com os pedidos"
cDesc2   := "de vendas e parametros solicitados pelo usuario."
cDesc3   := "Especifico para Editora Pini Ltda."
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
NomeProg :="PFAT069"
nLastKey := 0
aOrd     := {}
Cbtxt    := SPACE(10)
cPerg    := "PFAT69"
Limite   := 220           // P - 80 / M - 132 / G - 220
_nRegTot := 0
lAbortPrint := .F.
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    // Data Ocorrenc. De                             �
//� mv_par02    //                Ate                            �
//� mv_par03    // Produto        De                             �
//� mv_par04    //                Ate                            �
//� mv_par05    // Edicao         De                             �
//� mv_par06    //                Ate                            �
//� mv_par07    // Status         De                             �
//� mv_par08    //                Ate                            �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)

wnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If      nLastKey == 27
	Return
Endif

Processa({|| R010PRC() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> RptStatus({|| Execute(R010PRC) })

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � R010PRC  � Autor � Andreia Silva         � Data � 15/03/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Processa Relatorio                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Editora Pini Ltda.                         ���
�������������������������������������������������������������������������Ĵ��
���Revisao   �                                          � Data �          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static FUNCTION R010PRC()

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
Cabec1  := ""
Cabec2  := ""
cbCont  :=  0
li      := 80
m_pag   := 1
aDriver := ReadDriver()
nTipo   := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Filtra arquivo de Ocorrencias.                               �
//����������������������������������������������������������������

dbSelectArea("SZ1")
dbSetOrder(1)
cIndex  := "Z1_FILIAL + Z1_PEDIDO"

cExpres := 'Z1_FILIAL == "'+ xFilial("SZ1")
cExpres := cExpres + '" .And. DTOS(Z1_DTOCORR)  >= "'+ DTOS(mv_par01)
cExpres := cExpres + '" .And. DTOS(Z1_DTOCORR)  <= "'+ DTOS(mv_par02)
cExpres := cExpres + '" .And. Z1_CODPROD        >= "'+ mv_par03
cExpres := cExpres + '" .And. Z1_CODPROD        <= "'+ mv_par04  + '"'

//��������������������������������������������������������������Ŀ
//� 27.03.00 - Retirado de uso. Andreia Silva.                   �
//����������������������������������������������������������������

//cExpres := cExpres + '" .And. STR(Z1_EDICAO)    >= "'+ STR(mv_par05)
//cExpres := cExpres + '" .And. STR(Z1_EDICAO)    <= "'+ STR(mv_par06)
//cExpres := cExpres + '" .And. Z1_STATUSI        >= "'+ mv_par07
//cExpres := cExpres + '" .And. Z1_STATUSI        <= "'+ mv_par08 +'"'

cArqTmp := CriaTrab(NIL,.F.)
IndRegua("SZ1", cArqTmp, cIndex,,cExpres,"Selecionando Registros ...")
//nIndex := RetIndex("SZ1")+1

ProcRegua(RecCount())

Cabec1:="Nro.PV  E.Venc  E.Susp  Roteiro     Porte  Prod             CR  CodCli/Lj  Razao Social                               Ed.Rec  Status  Dt.Ocorr  Descricao da Ocorrencia                                       Operador       "
//       XXXXXX  9999    9999    XXXXXXXXXX  X      XXXXXXXXXXXXXXX  X   XXXXXX/XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   9999    XXX     XX/XX/XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX
//       12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160      170       180       190       200       210       220
Cabec2:=""
Cabec3:=""

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

dbSelectArea("SZ1")
//dbSetOrder(nIndex)
dbGoTop()

While !Eof()
	IncProc()
	//��������������������������������������������������������������Ŀ
	//� Verifica se o usuario interrompeu o relatorio                �
	//����������������������������������������������������������������
    If lAbortPrint
        @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
        Exit
    Endif

    If Li >= 60
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    Endif

    //��������������������������������������������������������������Ŀ
    //� 27.03.00 - Inclusao de consistencia que anteriormente encon- �
    //�            trava-se no filtro. Andreia Silva.                �
    //����������������������������������������������������������������

    If SZ1->Z1_EDICAO < mv_par05 .Or. SZ1->Z1_EDICAO > mv_par06
        dbSelectArea("SZ1")
        dbSkip()
        Loop
    EndIf

    If SZ1->Z1_STATUSI < mv_par07 .Or. SZ1->Z1_STATUSI > mv_par08
        dbSelectArea("SZ1")
        dbSkip()
        Loop
    EndIf

    //��������������������������������������������������������������Ŀ
    //� 07.04.00 -  Informa Pedidos de Vendas nao encontrados.       �
    //�             Andreia Silva.                                   �
    //����������������������������������������������������������������
    dbSelectArea("SC6")
    dbSetOrder(1)
    If !dbSeek(xfilial("SC6") + SZ1->Z1_PEDIDO, .F. )
        @ Li,001 PSAY "Pedido de Venda Nao Encontrado"
        @ Li,119 PSAY SZ1->Z1_EDICAO
        @ Li,127 PSAY SZ1->Z1_STATUSI
        @ Li,135 PSAY SZ1->Z1_DTOCORR
        @ Li,145 PSAY SZ1->Z1_OCORR
        @ Li,207 PSAY SZ1->Z1_OPER
        Li := Li + 1
        _nRegTot := _nRegTot + 1
        dbSelectArea("SZ1")
        dbSkip()
        Loop
    Endif

    //��������������������������������������������������������������Ŀ
    //� 28.03.00 - Verificacao de produto para ocorrencia. Raquel-Edi�
    //�            tora Pini.                                        �
    //����������������������������������������������������������������
    While SZ1->Z1_PEDIDO == SC6->C6_NUM
        If Substr(SC6->C6_PRODUTO,1,4)<>Substr(SZ1->Z1_CODPROD,1,4)
            dbSelectArea("SC6")
            dbSkip()
            Loop
        Else
            //��������������������������������������������������������������Ŀ
            //� Direciona linha, coluna para impressao. Andreia Silva.       �
            //����������������������������������������������������������������
            @ Li,001 PSAY SC6->C6_NUM
            @ Li,009 PSAY SC6->C6_EDVENC
            @ Li,017 PSAY SC6->C6_EDSUSP
            @ Li,025 PSAY SC6->C6_ROTEIRO
            @ Li,037 PSAY SC6->C6_TPPORTE
            @ Li,044 PSAY Substr(SC6->C6_PRODUTO,1,4)
            Exit
        Endif
    Enddo

    //��������������������������������������������������������������Ŀ
    //� Consiste se existe contas a receber em aberto.               �
    //����������������������������������������������������������������
    dbSelectArea("SE1")
	DbOrderNickName("E1_PEDIDO") //dbSetOrder(27) 20130225  ///dbSetOrder(15) AP5 //20090114 era(21) //20090723 mp10 era(22) //dbSetOrder(26) 20100412
    dbSeek(xfilial() + SZ1->Z1_PEDIDO)

    //��������������������������������������������������������������Ŀ
    //� 10.04.00 - Mudanca no conceito de contas a receber em aberto.�
    //�            O titulo que possuir saldo ou estiver em L&P,e con�
    //�            siderado em aberto. Andreia Silva.                �
    //����������������������������������������������������������������
    _lFlagE1        := .F.
    While !EOF() .And. xFilial()+SZ1->Z1_PEDIDO == SE1->E1_FILIAL+SE1->E1_PEDIDO

        If SE1->E1_SALDO > 0.00 .OR. ALLTRIM(SE1->E1_HIST) == "LP"
            _lFlagE1 := .T.
            Exit
        Endif

        dbSelectArea("SE1")
        dbSkip()
    EndDo

    If _lFlagE1
        @ Li,061 PSAY "S"
    Else
        @ Li,061 PSAY "N"
    EndIf

    //��������������������������������������������������������������Ŀ
    //� Imprime razao social do cliente.                             �
    //����������������������������������������������������������������
    //��������������������������������������������������������������Ŀ
    //� 10.04.00 - Inclusao de Mensagem para Clientes Nao Encontrados�
    //�            Andreia Silva.                                    �
    //����������������������������������������������������������������
    dbSelectArea("SA1")
    dbSetOrder(1)
    dbSeek(xFilial() + SZ1->Z1_CODCLI)
		
    If Found()
       @ Li,065 PSAY SA1->A1_COD
       @ Li,071 PSAY "/"
       @ Li,072 PSAY SA1->A1_LOJA
       @ Li,076 PSAY SA1->A1_NOME
    Else
        @ Li,076 PSAY "Cliente Nao Encontrado"
    EndIf
	 
    dbSelectArea("SZ1")

    //��������������������������������������������������������������Ŀ
    //� Continua o direcionamento para impressao nas linhas e colunas�
    //� correspondentes.                                             �
    //����������������������������������������������������������������
    @ Li,119 PSAY SZ1->Z1_EDICAO
    @ Li,127 PSAY SZ1->Z1_STATUSI
    @ Li,135 PSAY SZ1->Z1_DTOCORR
    @ Li,145 PSAY SZ1->Z1_OCORR
    @ Li,207 PSAY SZ1->Z1_OPER

    Li ++
    _nRegTot++

    dbSelectArea("SZ1")
    dbSkip()

EndDo                   // Finaliza While principal

Li++

@ Li,001 PSAY "Total de Ocorrencias: "
@ Li,023 PSAY _nRegTot

Roda(cbcont,cbtxt,Tamanho)
//��������������������������������������������������������������Ŀ
//� Apaga indice de trabalho                                     �
//����������������������������������������������������������������

dbSelectArea("SZ1")
RetIndex("SZ1")
Ferase( cArqTmp + OrdBagExt())

//��������������������������������������������������������������Ŀ
//� Apresenta relatorio na tela                                  �
//����������������������������������������������������������������
Set Device To Screen
If aReturn[5] == 1
    Set Printer TO
    dbcommitAll()
    ourspool(wnRel)
Endif
Ms_Flush()

Return