#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa:  RFATA08  �Autor: Roger Cangianeli       � Data:   26/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Browse para Manutencao de Faturamentos Especiais de A.V.'s � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico Editora PINI Ltda.                              � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rfat093()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

Local aArea := GetArea()
SetPrvt("AROTINA,CCADASTRO")


aRotina := {{"Pesquisa" , "AxPesqui"  							, 0 , 1},;      //"Pesquisar"
			{"Visualiza", 'U_RFATA09("V",2)', 0 , 2},;      //"Visualizar"
			{"Incluir"  , 'U_RFATA09("I",3)', 0 , 3},;      //"Incluir"
			{"Alterar"  , 'U_RFATA09("A",4)', 0 , 4},;      //"Alterar"
			{"Excluir"  , 'U_RFATA09("E",5)', 0 , 5}}     //"Excluir"

//����������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes               �
//������������������������������������������������������������
cCadastro := "Faturamento Programado"

cCadastro := OemToAnsi(cCadastro)
//����������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                              �
//������������������������������������������������������������
DbSelectArea("SZV")
DBSetOrder(1)

mBrowse( 6, 1,22,75,"SZV")            // "C5_LIBEROK")

RestArea(aArea)
Return