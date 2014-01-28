#INCLUDE "RWMAKE.CH"
/*                                                                     
//Alterado por Danilo C S Pala em 20050520: CFB
//Alterado por Danilo C S Pala em 20070315: CFE
//Alterado por Danilo C S Pala em 20070328: NFS
//Alterado por Danilo C S Pala em 20080220: SEN
//Alterado por Danilo C S Pala em 20081031: STD
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RECCRED   �Autor  �Microsiga           � Data �  04/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RecCred()
// BAIXA DE TITULOS A RECEBER
// RETORNA CONTA DE CREDITO

MCTACRED := 'CREDITO'
IF ALLTRIM(SE1->E1_TIPO) == 'NF'
   IF ALLTRIM(SE1->E1_SERIE) $ 'UNI/D1/CUP/CFS/CFA/CFB/ANG/CFE/NFS/SEN/STD/8'  //20050520 CFB //20061031 ANG //20070315 CFE //20070328 NFS //20080220 SEN //20081031 STD
      MCTACRED := '11020101002'
   ENDIF
   IF ALLTRIM(SE1->E1_SERIE) $ 'ASS/LIV'
      MCTACRED:='21080101001'
   ENDIF
ENDIF
IF ALLTRIM(SE1->E1_TIPO) == 'CH'
   IF ALLTRIM(SE5->E5_MOTBX) == 'NOR' .OR. ALLTRIM(SE5->E5_MOTBX) == 'CAN'
      MCTACRED := '11020101001'
   ENDIF
ENDIF

RETURN(MCTACRED)