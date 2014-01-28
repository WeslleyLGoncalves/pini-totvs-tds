#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr23()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CPERG,NLASTKEY")
SetPrvt("CSAVTELA1,NLIN,_MLOC,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR23   �Autor: Rosane Rodrigues       � Data:   04/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE MATERIAIS POR CLIENTE - VIDEO                 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
cSavTela   := SaveScreen( 0, 0,23,80)
cSavCursor := SetCursor()
cSavCor    := SetColor()
cSavAlias  := Select()
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   MV_PAR01  = Do Cliente                  �
//�   MV_PAR02  = At� o Cliente               �
//���������������������������������������������

cPerg    := "FIN450"
If !Pergunte(CPERG)
   Return
EndIf
nLastKey := 0
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

DbSelectArea("SZU")
DbSetOrder(01)
DbSeek(Xfilial("SZU")+MV_PAR01,.T.)

Set Devi to Screen
cSavCursor := SetCursor()
cSavCor    := SetColor()
cSavAlias  := Select()
cSavtela1:=Savescreen(3,0,24,79)
set color to B/BG
DrawAdvWin("** CONSULTA DE MATERIAIS POR CLIENTE **" , 3, 0, 24, 78 )
Set color to W+/B
@ 24,01 SAY PADC("QUALQUER TECLA CONTINUA CONSULTA",78)
SET COLOR TO B/BG

While SZU->ZU_CLIENTE <= MV_PAR02
    limpa()
    nlin := 5
    @ nlin,01 SAY "CodCli Nome do Cliente                             Local / Respons�vel      " 
    nLin     := nLin + 1
    @ nlin,01 SAY "CodMat Titulo do Material      Tipo                Observa��es              "
    nLin     := nLin + 1
    @ nlin,01 SAY REPLICATE ("+",76)
    nLin     := nLin + 2                                                                  

    FOR NLIN:=8 TO 22 .AND. SZU->ZU_CLIENTE <= MV_PAR02
         _mloc := " "
        If SZU->ZU_LOCALIZ == '0'
           _mloc := "PINI"
        Endif
        If SZU->ZU_LOCALIZ == '1'
           _mloc := "CLIENTE"
        Endif
        If SZU->ZU_LOCALIZ == '2'
           _mloc := "AGENCIA"
        Endif
        DbSelectArea("SA1")
        DbSetOrder(01)
        DbSeek(XFILIAL("SA1")+SZU->ZU_CLIENTE)
        @ nlin,001 SAY SZU->ZU_CLIENTE+' '+SA1->A1_NOME+SPACE(6)+SZU->ZU_LOCALIZ+SPACE(3)+_mloc
        nlin := nlin + 1
        @ nlin,001 SAY SZU->ZU_CODMAT+' '+SZU->ZU_TITULO+SPACE(4)+SZU->ZU_TIPOMAT+'  '+SUBST(SZU->ZU_OBS,1,23)
        nlin := nlin + 1
        @ nlin,001 SAY REPLICATE("-",76)
        DbSelectArea("SZU")
        DbSkip()
    NEXT
    inkey(0)
    DbSelectArea("SZU")
    If nLastKey == 27 .or. LastKey() == 27
        Exit
    EndIf
End
//limpa()
Restscreen(3,2,23,79,cSavtela1)
Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function LIMPA
Static Function LIMPA()
  @ 04,01 clear TO 23,77
//  @ 23,01 SAY REPLICATE(' ',76)
Return

