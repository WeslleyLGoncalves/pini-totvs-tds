#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �POSSB1    � Autor �Gilberto A. de Oliveira� Data � 14/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �EXECBLOCK                                                   ���
���          �---------                                                   ���
���          �Posiciona o arquivo SB1 quando da Exclusao da Nota Fiscal,  ���
���          �afim de retornar a conta correta para contabilizacao do     ���
���          �Estorno.                                                    ���
�������������������������������������������������������������������������Ĵ��
���Observacao�Chamado atraves do Lancto Padrao 630-01                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Possb1()

Local aArea := GetArea()

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)

RestArea(aArea)

Return(SB1->B1_CONTA)
