#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfat048()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,NLIN,TITULO")
SetPrvt("CABEC1,CABEC2,CCANCEL,M_PAG,WNREL,CARQ")
SetPrvt("CKEY,CFILTRO,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa : RFATR02  �Autor: Fabio William          � Data:  12/01/00  � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Relatorio de Programa��o de An�ncios                       � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Revista                      �
//�   mv_par02 = Edicao                       �
//�   mv_par03 = Secao Inicial                �
//�   mv_par04 = Secao Final                  �
//���������������������������������������������

cPerg    := "FATR02"
If .not. pergunte(cperg)
   Return
Endif

cString  := "SZS"
cDesc1   := PADC("Emite o relat�rio de programa��o de an�ncios da se��o indeterminadas",70)
cDesc2   := " "
cDesc3   := ""
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR02"
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := oemtoansi("Programa��o de An�ncios - Indeterminadas")
Cabec1   := "Revista : " + MV_PAR01 + "  Edicao : " + STR(MV_PAR02,4)
cabec2   := "Cliente Nome do Cliente                Num Av Item Descricao do Produto               C.Mat. Titulo               Observacao"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR02_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(17)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

SetDefault(aReturn,cString)

If nLastKey == 27 .or. nlastkey == 65
   Return
Endif

// �����������������������������������������������Ŀ
// �Cria o arquivo temporario                      �
// �������������������������������������������������

cArq     := CriaTrab(NIL,.F.)
cKey     := "ZS_NUMAV+ZS_ITEM"
DBSELECTAREA("SZS")
cFiltro  := 'ZS_FILIAL=="'+xFilial()+'".And.ZS_CODREV=="'+MV_PAR01+'"'
cFiltro  := cFiltro + '.and.STR(ZS_EDICAO,4) =="'+str(MV_PAR02,4)+'".And.ZS_CODTIT=="999"'
IndRegua("SZS",cArq,cKey,,cFiltro,"Selecionando registros .. ")

#IFNDEF TOP
        dbSetIndex(cArq+OrdBagExt())
#ENDIF

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
DbGotop()
Do While !eof()

   if val(szs->zs_codmat) == 0 .or. szs->zs_situac == 'CC'
      dbskip()
      loop
   endif

   if nLin > 62
      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
   endif

   DbSelectArea("SC6")
   dbsetorder(01)
   DbSeek(xFilial()+SZS->ZS_NUMAV+SZS->ZS_ITEM)

   DbSelectArea("SA1")
   DbSeek(xFilial()+SC6->C6_CLI+SC6->C6_LOJA)

   DbSelectArea("SZU")
   DBSETORDER(01)
   DbSeek(xFilial("SZU")+SC6->C6_CLI+SZS->ZS_CODMAT)

   DbSelectArea("SB1")
   DbSeek(xFilial()+SZS->ZS_CODPROD)

   nLin := nLin + 2
   @ nLin,000 PSAY SC6->C6_CLI
   @ nLin,008 PSAY SUBST(SA1->A1_NOME,1,30)
   @ nlin,039 PSAY SZS->ZS_NUMAV 
   @ nlin,046 PSAY SZS->ZS_ITEM  
   @ nlin,051 PSAY SUBSTR(SB1->B1_DESC,1,34)
   @ nlin,086 PSAY SZS->ZS_CODMAT
   @ nlin,093 PSAY SZU->ZU_TITULO
   @ nlin,114 PSAY SZU->ZU_OBS

   DbSelectArea("SZS")
   DbSkip()
Enddo

DbSelectarea("SZS")
RetIndex("SZS")
Ferase(cArq+OrdBagExt())


//Roda(0,"",tamanho)
Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



