#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALNFEIRRF�Autor  �Danilo C S Pala     � Data �  20081205   ���
�������������������������������������������������������������������������͹��
���Desc.     � LOCALIZAR O TITULO NO CONTAS A PAGAR E PEGAR O VALOR       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                 
//E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
User Function VALNFEPARC(mPREFIXO, mNUM, mPARCELA, mFORNECE, mLOJA, mEMISSAO)
Local mVALPARC  := 0                                    
Local mTIPO := "NF "
mPREFIXO := "COM"

DBSELECTAREA("SE2")
DBSETORDER(1)                               
IF DBSEEK(XFILIAL("SE2") + mPREFIXO + mNUM + mPARCELA + mTIPO + mFORNECE + mLOJA) ////E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
	IF mEMISSAO == SE2->E2_EMISSAO
		mVALPARC := SE2->E2_VALOR
	ELSE
		mVALPARC := 0		
	ENDIF
ELSE                         
	mVALPARC := 0
ENDIF

mVALPARC := ROUND((SD1->D1_TOTAL/SF1->F1_VALMERC) * mVALPARC,2)

return (mVALPARC)