#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Rfat003()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,NLIN,TITULO")
SetPrvt("CABEC1,CABEC2,CCANCEL,M_PAG,WNREL,_TBRUTO")
SetPrvt("_TLIQ,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa : RFAT003  � Autor: Mauricio Mendes       � Data:  19/10/01  � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Relacao de Cursos  por periodo                             � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = curso de                     �
//�   mv_par02 = curso curso ate              �
//�   mv_par03 = periodo de                   �
//�   mv_par04 = periodo ate                  �
//�   mv_par05 = autorizados                  �
//�              nao autorizados              �
//�              ambos                        �
//���������������������������������������������


cPerg    := "ZZG001"
If !pergunte(cperg)
   Return
Endif

cString  := "ZZG"
cDesc1   := PADC("Emite o relat�rio da agenda de cursos",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATZZG3"
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := oemtoansi("RELACAO DE CURSOS / PARTICIPANTES")
Cabec1   := " "
cabec2   := "EMPRESA                                          PARTICIPANTE                                            CIDADE"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATZZG3_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
wnrel    := SetPrint(cString,wnrel,cPerg,space(15)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)
_Tbruto  := 0
_Tliq    := 0

SetDefault(aReturn,cString)



If nLastKey == 27 .or. nlastkey == 65
   Return
Endif

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

dbSelectArea("ZZG")
dbSetOrder(2)
dbSeek(xFilial("ZZG")+dtos(mv_par03)+MV_PAR01,.t.)
SetRegua(Reccount())
Do While !eof() .and. ZZG->ZZG_FILIAL == XFILIAL("ZZG");
                .and. ZZG->ZZG_PROD   >= mv_par01 ;
                .and. ZZG->ZZG_PROD   <= mv_par02

   IncRegua()

   If ZZG->ZZG_DATAOC  <  mv_par03
      DbSelectArea("ZZG")
      dbSkip()
      Loop
   Endif

   If ZZG->ZZG_DATAOC  >  mv_par04
      DbSelectArea("ZZG")
      dbSkip()
      Loop
   Endif

   IncRegua()

   if mv_par05 == 1 .and. ZZG->ZZG_FLAG <> "S"
      dbSelectArea("ZZG")
      dbskip()
      loop
   endif

   if mv_par05 == 2 .and. ZZG->ZZG_FLAG <> "N"
      dbSelectArea("ZZG")
      dbskip()
      loop
   endif


   if nLin > 50
      Cabec1 := "Curso: "+MV_PAR01+" a "+MV_PAR02+"  De: "+dtoc(mv_par03)+"  ate.: "+DTOC(MV_PAR04)+"  "+IIF(MV_PAR05 == 1,"AUTORIZADOS",IIF(MV_PAR05 == 2,"NAO AUTORIZADOS","AMBOS"))
      nLin   := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
      nLin   := nLin + 2
   endif

   @ nLin,000 PSAY ZZG->ZZG_CLIENT+"-"+ZZG->ZZG_LOJA+" "+ZZG->ZZG_DESCLI
   @ nlin,054 PSAY ZZG->ZZG_PARTIC+" - "+ZZG->ZZG_NOME
   @ nlin,105 PSAY ZZG->ZZG_CIDADE
   nLin := nLin +2
   @ nlin,000 PSAY "Curso : "+ZZG->ZZG_PROD+"-"+ZZG->ZZG_DESPRO+"      Inicio : "+dtoc(ZZG->ZZG_DATINI)+;
                   " Ate : "+dtoc(ZZG->ZZG_DATAFI)+ " HORARIO : "+ZZG->ZZG_HORARI
   nLin := nLin +2
   @ nlin,000 PSAY "LOCAL : "+ZZG->ZZG_LOCAL
   @ nlin,070 PSAY "Data Ocorrencia : "+DTOC(ZZG->ZZG_DATAOC)
   nLin := nLin +2
   @ nlin,000 PSAY "Endereco: "+ZZG->ZZG_END+;
                   "      Bairro : "+ZZG->ZZG_BAIRRO+"  UF: "+ZZG->ZZG_UF+;
                   "  CEP :"+ZZG->ZZG_CEP
   nLin := nLin +2
   @ nlin,000 PSAY "FONE    : "+ZZG->ZZG_FONE+" FAX : "+ZZG->ZZG_FAX+" EMAIL: "+ZZG->ZZG_EMAIL
   nLin := nLin +2
   @ nlin,000 PSAY "OBS     : "+ZZG->ZZG_OBS1+ZZG_OBS2
   nLin := nLin +2
   @ nlin,000 PSAY REPLICATE("-",132)
   nLin := nLin +1


   DbSelectArea("ZZG")
   DbSkip()
Enddo


Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



