#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa:  RFATA10  �Autor: Roger Cangianeli       � Data:   26/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Browse para Manutencao de Programacoes de A.V.'s           � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico Editora PINI Ltda.                              � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rfat094()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

Local aArea := GetArea()
SetPrvt("AROTINA,CCADASTRO,")


//aRotina := {    {"Pesquisa" , "AxPesqui"  , 0 , 1},;                            //"Pesquisar"
//{"Visualiza", "ExecBlock('U_RFATA11()',.F.,.F.,'V')", 0 , 2 },;      //"Visualizar"
//{"Incluir"  , "ExecBlock('U_RFATA11()',.F.,.F.,'I')", 0 , 3 },;      //"Incluir"
//{"Alterar"  , "ExecBlock('U_RFATA11()',.F.,.F.,'A')", 0 , 2 },;      //"Alterar"
//{"Excluir"  , "ExecBlock('U_RFATA11()',.F.,.F.,'E')", 0 , 2 }  }     //"Excluir"

//����������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes               �
//������������������������������������������������������������
cCadastro := "Programacao de A.V.�s"
cCadastro := OemToAnsi(cCadastro)

aRotina := {    {"Pesquisa" , "AxPesqui"  , 0 , 1},;                            //"Pesquisar"
{"Visualiza", 'U_RFATA11("V")', 0 , 2 },;      //"Visualizar"
{"Incluir"  , 'U_RFATA11("I")', 0 , 3 },;      //"Incluir"
{"Alterar"  , 'U_RFATA11("A")', 0 , 4 },;      //"Alterar"
{"Excluir"  , 'U_RFATA11("E")', 0 , 5 }  }     //"Excluir"

dbSelectArea("SZS")         // Inclusao em 04/04/00 By RC

dbSetOrder(5)               // Idem Acima

//����������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                              �
//������������������������������������������������������������
//@ 006,005 TO 093,150 BROWSE "SZS"
mBrowse(6,1,22,75,"SZS")

RestArea(aArea)

Return