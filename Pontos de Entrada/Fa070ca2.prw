#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���PTO ENTRADA � FA070CA2 � Autor � Gilberto A. de Oliveira  � Data � 31/05/00 ���
������������������������������������������������������������������������������Ĵ��
���Descricao   � Ponto de no momento do cancelamento da baixa, quando todos os ���
���            � dados ja estao gravado e a contabilizacao ja esta feita.      ���
������������������������������������������������������������������������������Ĵ��
���Solicitante � Editora Pini - Depto de Informatica : Rosane/Solange.         ���
������������������������������������������������������������������������������Ĵ��
���Uso         � Utilizado para estornar o motivo da baixa gravado no campo    ���
���            � E1_MOTIVO (campo padrao que na Pini e gravado com o mesmo     ���
���            � conteudo de E5_MOTBX).                                        ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
User Function Fa070ca2()

Private aArea := GetArea()

RecLock("SE1",.F.)
SE1->E1_MOTIVO := ""
SE1->E1_NATBX  := ""
MsUnLock()

RestArea(aArea)

Return(.t.)