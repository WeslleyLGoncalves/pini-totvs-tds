#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function MTA410E()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NREG,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTA410E   � Autor � Fabio William         � Data � 16.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exclui as Av. Programadas. dos arquivos SZV e SZS           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Faturamento Publicidade  - Acionado antes da exclusao da AV ���
�������������������������������������������������������������������������Ĵ��
���Release   �Roger Cangianeli - padronizacao e otimizacao em 02/02/00.   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()

If SM0->M0_CODIGO == "01" .and. SC5->C5_DIVVEN == "PUBL"
	
	// ���������������������������Ŀ
	// � Exclui as Avs Normais     �
	// �����������������������������
	If SC5->C5_AVESP == "N" // Somente AV Com pagamento normal
		
		dbSelectArea("SZS")
		dbSetOrder(1)
		dbSeek(xFilial("SZS")+SC5->C5_NUM)
		While !eof()  .and. SZS->ZS_NUMAV == SC5->C5_NUM
			RecLock("SZS",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		End
		
	Else
		
		// ���������������������������Ŀ
		// � Exclui as Avs Especiais   �
		// �����������������������������
		dbSelectArea("SZV")
		dbSetOrder(01)
		dbSeek(xFilial()+SC5->C5_NUM)
		While !eof()  .and. SZV->ZV_NUMAV == SC5->C5_NUM
			RecLock("SZV",.F.)
			dbDelete()
			msUnlock()
			dbSkip()
		End
		
	EndIf
	
EndIf

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return
