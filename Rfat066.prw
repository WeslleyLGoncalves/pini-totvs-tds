#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfat066()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_MCONT,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR20   �Autor: Rosane Rodrigues       � Data:   03/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE ATUALIZA��O DE MATERIAIS                      � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   MV_PAR01  = Do N�mero                   �
//�   MV_PAR02  = At� o N�mero                �
//���������������������������������������������

cPerg    := "MTR160"
If !Pergunte(CPERG)
   Return
EndIf

cString  := "SZU"
cDesc1   := PADC("Este programa emite o relat�rio de atualiza��es de materiais",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR20"
limite   := 80
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Atualiza��es de Materiais"
cCabec1  := "Material Inicial : " + MV_PAR01 + SPACE(10) + "Material Final : " + MV_PAR02
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1               //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR20_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)       //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(20)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

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

_mcont := val(MV_PAR01)

While _mcont <= val(MV_PAR02)
    if nLin > 62
       nLin     := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
       nLin     := nLin + 2
                    //           1         2         3         4         5         6         7         8         9        10        11      
                    // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
       @ nlin,00 PSAY "Empresa   Material   Titulo                           Loc   Respons�vel                      Tipo Material   Cliente"
       nLin     := nLin + 1
       @ nlin,00 PSAY "-------   --------   ------------------------------   ---   ------------------------------   -------------   -------"
       nLin     := nLin + 3                                                                  
    Endif

    @ nlin,002 PSAY "01"
    @ nlin,010 PSAY STR(_mcont,6)
    @ nlin,021 PSAY REPLICATE ("_",30)
    @ nlin,054 PSAY REPLICATE ("_",03)
    @ nlin,060 PSAY REPLICATE ("_",30)
    @ nlin,093 PSAY REPLICATE ("_",13)
    @ nlin,109 PSAY REPLICATE ("_",07)
    nlin  := nlin + 3
    _mcont := _mcont + 1
End

If _mcont == 0 
   Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18)
   @ 15, 00 PSAY "NAO HA DADOS A APRESENTAR !!! "
Endif

Set Device to Screen
If aReturn[5] == 1
    Set Printer To
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
