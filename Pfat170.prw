#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"  //consulta SQL
/*/ 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT170   �Autor: DANILO C S PALA        � Data:   20060829 � ��
������������������������������������������������������������������������Ĵ ��
���Descricao: ATUALIZAR ZZV COM PAGAMENTO DOS AUTORES SEGUNDO OS PARAMETROS� ��
��� 				          											 � ��
���  sp_dirautpgaut(in_datade => :in_datade,							 � ��
���                 in_dataate => :in_dataate,							 � ��
���                 in_autorde => :in_autorde,							 � ��
���                 in_autorate => :in_autorate,						 � ��
���                 in_datapg => :in_datapg,							 � ��
���                 in_valorminimo => :in_valorminimo,					 � ��
���                 in_igpm => :in_igpm);								 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PFAT170()

SetPrvt("CPERG, lend, cMsg, aRet")

//������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros     �
//� FAT170									 �
//� MV_PAR01 DATADE							 �
//� MV_PAR02 DATAATE						 �
//� MV_PAR03 AUTORDE						 �
//� MV_PAR04 AUTORAET						 �
//� MV_PAR05 VALOR MINIMO					 �
//� MV_PAR06 VALOR IGPM						 �
//��������������������������������������������

CPERG := 'FAT170'
IF !PERGUNTE(CPERG)
	RETURN
ENDIF

lEnd := .F.

Processa({|lEnd| ProcArq(@lEnd)})
Return



Static Function ProcArq()
DbSelectArea("zzv")
if RDDName() <> "TOPCONN"
		MsgStop("Este programa somente podera ser executado na versao SQL do SIGA Advanced.")
		Return nil
endif

//verifica se o igpm para o mes ja existe caso contrario insere 20061031
DBSELECTAREA("ZZX")
DBSETORDER(1)
/*If DBSEEK(xFilial("ZZX")+STOD(SUBSTR(DTOS(DDATABASE),1,6)+'01')) //EXISTE: ATUALIZAR
	RECLOCK("ZZX",.F.)
		ZZX->ZZX_INDICE := MV_PAR06
	MsUnlock()                                                                                           
ELSE //NAO EXISTE: INSERIR
	RECLOCK("ZZX",.T.)
		ZZX->ZZX_INDICE := MV_PAR06
		ZZX->ZZX_DATA := STOD(SUBSTR(DTOS(DDATABASE),1,6)+'01')
		ZZX->ZZX_FILIAL := XFILIAL("ZZX")
	MsUnlock()                                                                                           
ENDIF
  */
//Verifica se a Stored Procedure Teste existe no Servidor
If TCSPExist("SP_DIRAUTPGAUT")
	//SP_DIRAUTPGAUT(IN_DATADE VARCHAR2, IN_DATAATE VARCHAR2, IN_AUTORDE VARCHAR2, IN_AUTORATE VARCHAR2, IN_DATAPG VARCHAR2, IN_VALORMINIMO NUMBER, IN_IGPM NUMBER) is
	aRet := TCSPExec("SP_DIRAUTPGAUT", dtos(mv_par01), dtos(mv_par02), MV_PAR03, MV_PAR04, DTOS(DDATABASE), MV_PAR05, MV_PAR06)

cMsg:= "Processamento finalizado!"+ chr(13)+ "Execute o relatorio de direitos autorais"
MSGINFO(cMsg)
EndIf

Return

