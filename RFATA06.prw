#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function RFATA06()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCADASTRO,CDELFUNC,AROTINA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RFATA06  � Autor � Fabio William      � Data � Thu 10/10/98���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de Vencimento                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//���������������������������������������������������������������������Ŀ
//� Variavel com o titulo da janela (deve ser cCadastro, pois a versao  �
//� Windows refere-se a essa variavel).                                 �
//�����������������������������������������������������������������������

cCadastro := "Cadastro de Vencimentos"


//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
               { "Visualizar"   ,'ExecBlock("EFATA12",.F.,.F.)' , 0, 2},;
               { "Incluir"      ,'ExecBlock("EFATA13",.F.,.F.)' , 0, 3},;
               { "Alterar"      ,'ExecBlock("EFATA14",.F.,.F.)' , 0, 4},;
               { "Excluir"      ,'ExecBlock("EFATA15",.F.,.F.)' , 0, 5} }


//���������������������������������������������������������������������Ŀ
//� No caso do ambiente DOS, desenha a tela padrao de fundo             �
//�����������������������������������������������������������������������

#IFNDEF WINDOWS
    ScreenDraw("SMT050", 3, 0, 0, 0)
    @3,1 Say cCadastro Color "B/W"
#ENDIF


dbSelectArea("SZ6")
mBrowse( 6,1,22,75,"SZ6")

Return

