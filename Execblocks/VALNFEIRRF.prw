#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALNFEIRRF�Autor  �Danilo C S Pala     � Data �  20081125   ���
�������������������������������������������������������������������������͹��
���Desc.     � LOCALIZAR O TITULO DE IRRF NO CONTAS A PAGAR E PEGAR O VALOR���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                 
//E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
User Function VALNFEIRRF(mPREFIXO, mNUM, mEMISSAO)
Local mIRRF  := 0                                    
Local mPARCELA := "1"
Local mTIPO := "TX "
Local mFORNECE := "UNIAO "
Local mLOJA := "00"

DBSELECTAREA("SE2")
DBSETORDER(1)                               
IF DBSEEK(XFILIAL("SE2") + mPREFIXO + mNUM + mPARCELA + mTIPO + mFORNECE + mLOJA) ////E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
	IF mEMISSAO == SE2->E2_EMISSAO   .and. ALLTRIM(SE2->E2_NATUREZ) = "IRF"
		mIRRF := SE2->E2_VALOR
	ELSE
		mIRRF := 0		
	ENDIF
ELSE                         
	mIRRF := 0
ENDIF

return (mIRRF)