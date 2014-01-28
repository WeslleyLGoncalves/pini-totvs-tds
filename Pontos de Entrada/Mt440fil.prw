#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Mt440fil()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CFILTRO,_LR,_CFILTRO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: MTA440FIL �Autor: Fabio William          � Data:   07/07/99 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Liberacao automatica de Pedido de Venda                    � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico da Editora Pini                                 � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
 ��������������������������������������������������������������Ŀ
 �Parametros Utilizados                                         �
 ��������������������������������������������������������������Ĵ
 �mv_par08  Lote de                                             �
 �mv_par09  Lote Ate                                            �
 �mv_par10  Data Lote de                                        �
 �mv_par11  Data Lote Ate                                       �
 �mv_par05  No da 1a Nota Fiscal // Avaliar usa utilizacao      �
 ����������������������������������������������������������������
/*/

cfiltro  := "C6_LOTEFAT >='"+mv_par08+"' .AND. C6_LOTEFAT <= '"+mv_par09+"'.and."
cfiltro  := cFiltro+"Dtos(C6_DATA)  >='"+Dtos(mv_par10)+"' .AND. Dtos(C6_DATA) <= '"+Dtos(mv_par11)+"'"
_LR      := &Cfiltro
if _lR
  alert("PASSA")
  _cFiltro := ".T."
else
  _cFiltro := ".F."
endif
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return(cFiltro)
Return(cFiltro)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
Return

/*/
cfiltro := execblock("mt440fil",.f.,.f.)
if !&cFiltro
   dbselectarea("SC6")
   dbskip
   loop
Endif


empe + entr < vendida
   c5_liberado == " "
else


/*/


