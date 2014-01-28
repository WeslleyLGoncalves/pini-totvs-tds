#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/* Alerado em 20040505 por Danilo C S Pala
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NUMSERASA �Autor  �Danilo C S Pala     � Data � 20040427    ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna e atualiza o numero da remessa do serasa, com base  ���
���          � no parametro criado: MV_SERASA                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NumSerasa()

SetPrvt("NNUMERO")
	dbSelectArea("SX6")  
	dbSetOrder(1)
//	nnumero := getmv("MV_SERASA")
	DbUseArea(.T.,, "SERASA.DTC","SERASA",.F.,.F.) //20121106 era dbf
	NNUMERO := SERASA->NUMSERASA
	RecLock("SERASA",.F.)
	SERASA->NUMSERASA := NNUMERO + 1
	MsUnlock()
	DBCloseArea("SERASA")	
Return   strzero(NNUMERO,6)