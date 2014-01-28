#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EPFAT01   �Autor  �Thiago Lima Dyonisio� Data �  11/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa � utilizado para gera��o do arquivo remessa  ���
���          � do CNAB do banco SIFRA. Ele verifica o STATUS da NF na     ���
���          � tabela SPED050, que poder� ser "transmitida" ou "Cancelada"���
�������������������������������������������������������������������������͹��
���Uso       � Editora PINI                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                                              
User Function EPFAT01(_cNumNf,_cSerieNf)//Recebe o n�mero e a s�rie da NF
                         
SetPrvt("_cStatsNF, _cChaveXml")
   
 	If Select("QRY") > 0
		QRY->(DbCloseArea())  
	EndIf

dbSelectArea("SF2")
dbSetOrder(10)
dbSeek(xFilial()+_cNumNf+_cSerieNf)

_cChaveXml := SF2->F2_CHVNFE

	cQuery := " SELECT DOC_CHV, STATUS AS STSNF, STATUSCANC "
	cQuery += " FROM SPED050 "
	cQuery += " WHERE DOC_CHV = '"+_cChaveXml+"' "

	cQuery := ChangeQuery(cQuery) 
	dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "QRY", .F., .T.) 
	
	dbSelectArea("QRY")                                                                                 
	dbGotop()
	
	if(QRY->STSNF == 6)
		_cStatsNF := '01'
	elseif(QRY->STSNF == 7 .and. QRY->STATUSCANC == 2)
		_cStatsNF := '02'
	else
   		_cStatsNF := '  '
   	endif	
   
    dbCloseArea("QRY")
      
Return(_cStatsNF)
	