#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F040BLQ   �Autor  �Danilo C S Pala     � Data �  05/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//O ponto de entrada F040BLQ � utilizado para, em determinadas situa��es, bloquear a utiliza��o das rotinas de inclus�o, exclus�o, altera��o e substitui��o de titulos a receber. Este ponto de entrada possui retorno l�gico
User Function F040BLQ ()                           
	IF SE1->E1_PREFIXO='PUB'
		U_PINILOGCONS(SM0->M0_CODIGO, SE1->E1_CLIENTE, SE1->E1_LOJA, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_EMISSAO, SE1->E1_PEDIDO, "CON", "FINA040", "CONTAS A RECEBER") //20120504
	ENDIF
Return .t.