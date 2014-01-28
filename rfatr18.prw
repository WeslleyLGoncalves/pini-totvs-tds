#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function rfatr18()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("MREV01,MREV02,AREGS,I,J,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR18   �Autor: Rosane Rodrigues       � Data:   03/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE CRONOGRAMA POR PRODUTO                        � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Produto Inicial              �
//�   mv_par02 = Produto Final                �
//�   mv_par03 = Data Inicial                 �
//�   mv_par04 = Data Final                   �
//���������������������������������������������

cPerg    := "PFAT19"
ValidPerg()
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SA3"
cDesc1   := PADC("Este programa emite o relat�rio do Cronograma das Revistas",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR18"
limite   := 80 
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Cronograma das Revistas"
cCabec1  := " "
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR18_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(24)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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

DbSelectArea("SZJ")
DbSetorder(01)
dbGotop()
SetRegua(Reccount())

Do While !eof() 
   IncRegua()

   MREV01 := '01' + SUBSTR(MV_PAR01,3,2)
   MREV02 := '01' + SUBSTR(MV_PAR02,3,2)

   If SZJ->ZJ_CODREV < MREV01 .OR. SZJ->ZJ_CODREV > MREV02 .OR.;
      SZJ->ZJ_DTCIRC < MV_PAR03 .OR. SZJ->ZJ_DTCIRC > MV_PAR04
      DbSelectArea("SZJ")
      DbSkip()
      Loop
   ENDIF

   If nlin > 60
      cCabec1 := "Prodt Inicial: "+MV_PAR01+SPACE(2)+"Prodt Final: "+MV_PAR02+;
                 SPACE(2)+"Dt Inicial: "+DTOC(MV_PAR03)+SPACE(2)+"Dt Final: "+DTOC(MV_PAR04)
      cCabec2 := " " 
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,28) //Impressao do cabecalho
      nLin := nLin + 2
      @ nlin,00 PSAY "Cod.Produto       Revista       Edi��o       Dt.Circula��o"
      nlin := nLin + 1                                                           
      @ nlin,00 PSAY "-----------       -------       ------       -------------"
      nLin := nLin + 1
   Endif
 
   @ nlin,01 PSAY '03'+SUBSTR(SZJ->ZJ_CODREV,3,2)
   @ nlin,18 PSAY SZJ->ZJ_DESCR
   @ nlin,33 PSAY SZJ->ZJ_EDICAO
   @ nlin,47 PSAY SZJ->ZJ_DTCIRC
   nLin := nLin + 1

   DbSelectArea("SZJ")
   DbSkip()
Enddo

DbSelectarea("SZJ")
RetIndex("SZJ")

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
   AADD(aRegs,{cPerg,"01","Produto Inicial : ","mv_ch1","C",4,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Produto Final ..: ","mv_ch2","C",4,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"03","Data Inicial ...: ","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"04","Data Final .....: ","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
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

