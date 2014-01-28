#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SISDEB	�Autor  �Danilo C S Pala     � Data �  20041215   ���
�������������������������������������������������������������������������͹��
���Desc.     � CNAB SISDEB: seleciona o pedido e retorna o valor correspon���
���          �  dente a passada por parametro							  ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SISDEB(PEDIDO, COLUNA)
//User Function SISDEB()
/*
SetPrvt("_APARAMETROS")
_APARAMETROS := PARAMIXB
Private  valor
*/
DBSELECTAREA("SC5")
DBSETORDER(1)

IF pedido = "EMPRESA"
	IF SM0->M0_CODIGO = "01" //ed
		valor := "1342505000674"
	ELSEIF SM0->M0_CODIGO = "02" //ps
		valor := "1343308300063"
	ELSE //bp
		Valor := ""           
	ENDIF
	
ELSE
	IF DBSEEK(XFILIAL("SC5")+SE1->E1_PEDIDO)
		IF COLUNA = "BANCO"
			Valor := SC5->c5_debbanc
		ELSEIF COLUNA = "AGENCIA"
			Valor := SC5->c5_debagen
		ELSEIF COLUNA = "CONTA"
			Valor := SC5->c5_debcont
		ELSEIF COLUNA = "DAC"
			Valor := SC5->c5_debdac
		ENDIF
	ELSE
		VALOR := ""
	ENDIF
ENDIF

return (VALOR)
