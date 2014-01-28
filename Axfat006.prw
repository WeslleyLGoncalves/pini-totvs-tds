#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Axfat006()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NREG,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: AXFAT006  �Autor: Roger Cangianeli       � Data:   29/11/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Cadastro de Custos de Producao                             � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI.                                           � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()

dbSelectArea("ZZ0")
dbSetOrder(1)

axCadastro( "ZZ0", "Custo de Producao", ".T.", ".T." )

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)
Return
