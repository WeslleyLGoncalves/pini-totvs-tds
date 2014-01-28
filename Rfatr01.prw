#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr01()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,NLIN,TITULO")
SetPrvt("CABEC1,CABEC2,CCANCEL,M_PAG,WNREL,CARQ")
SetPrvt("CKEY,CFILTRO,NINDEX,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
�����������������������������������������������������������������������Ŀ ��
��Programa: RFATR01   �Autor: Fabio William          � Data:   07/07/97 � ��
�����������������������������������������������������������������������Ĵ ��
��Descri�ao: Imprime Pedidos Nao Faturados ou com Bloqueio              � ��
�����������������������������������������������������������������������Ĵ ��
��Uso      : M�dulo de Faturamento                                      � ��
������������������������������������������������������������������������� ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/


//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Lote Inicial                 �
//�   mv_par02 = Lote Final                   �
//�   mv_par03 = Data do Lote Inicial         �
//�   mv_par04 = Data do Lote Final           �
//���������������������������������������������

cString  :="SC9"
cDesc1   := OemToAnsi("Este programa tem como objetivo, demostrar a utiliza��o ")
cDesc2   := OemToAnsi("das ferramentas de impress�o do Interpretador xBase.  ")
cDesc3   := ""
tamanho  :="P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog :="RFATR01"
aLinha   := { }
nLastKey := 0
cPerg    := "FATR01"
pergunte(cPerg,.F.)
nLin     :=  80
titulo      :=oemtoansi("Rela�ao de Pedidos Liberados/Bloqueados ")
cabec1      :="PEDIDO ITEM CLIENTE NOME                                       BLQ      NOTA"
cabec2      :="                                                             EST  CRED  NUM"
//             XXXXXX  XX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX    XX   XXXXXX
//             12345678901234567890123456789012345678901234567890123456789012345678901234567890
//                      1         2         3         4         5         6         7         8

cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0  //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel:="RFATR01_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Return
Endif

// �����������������������������������������������Ŀ
// �Cria o arquivo temporario                      �
// �������������������������������������������������

cArq       := CriaTrab(NIL,.F.)
cKey       := "C9_PEDIDO+C9_ITEM"
cFiltro    := 'C9_FILIAL=="'+xFilial()+'".And.C9_LOTEFAT>="'+MV_PAR01+'".And.'
cFiltro    := cFiltro + 'C9_LOTEFAT <="'+MV_PAR02+'".And.DTOS(C9_DATA)>="'+DTOS(MV_PAR03)+'".And.'
cFiltro    := cFiltro + ' DTOS(C9_DATA) <= "'+DTOS(MV_PAR04)+'" .AND.'
cFiltro    := cFiltro + ' (C9_BLEST #"  " .OR. C9_BLCRED # "  ")'
//cFiltro    := cFiltro + ' .AND. EMPTY(C9_NFISCAL)'

IndRegua("SC9",cArq,cKey,,cFiltro,"Selecionando registros .. ")
nIndex:=RetIndex("SC9")
#IFNDEF TOP
	dbSetIndex(cArq+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGotop()


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

SetRegua(Reccount())
Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho


Do While !eof()
   if nLin > 57
      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 1
   endif
   DbSelectArea("SA1")
   DbSeek(xFilial()+SC9->C9_CLIENTE+SC9->C9_LOJA)
   @ nlin,000 PSAY SC9->C9_PEDIDO
   @ nLin,009 PSAY SC9->C9_ITEM
   @ nlin,013 PSAY SC9->C9_CLIENTE
   @ nlin,021 PSAY SA1->A1_NOME
   @ nlin,062 PSAY SC9->C9_BLEST
   @ nlin,068 PSAY SC9->C9_BLCRED
   @ nlin,073 PSAY SC9->C9_NFISCAL
   nLin := nLin + 1

   DbSelectarea("SC9")
   DbSkip()
Enddo

DbSelectarea("SC9")
RetIndex("SC9")
Ferase(cArq+OrdBagExt())


Roda(0,"","P")
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



