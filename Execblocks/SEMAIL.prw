#include "rwmake.ch"
#include "ap5mail.ch"

/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEMAIL    �Autor  �Danilo C S Pala     � Data �  20090203   ���
�������������������������������������������������������������������������͹��
���Desc.     � envia email											      ���
���          �  				                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function SEMAIL(cbody, cTitle, cTo)

Private cServMail := "ex01" 
Private cOrigem := "microsiga@pini.com.br"
                                                       
CONNECT SMTP SERVER cServMail ACCOUNT cOrigem PASSWORD "sigavi"
SEND MAIL FROM cOrigem TO cTo SUBJECT cTitle BODY cBody
//SEND MAIL FROM cOrigem TO cOrigem SUBJECT cTitulo1 BODY cBody
DISCONNECT SMTP SERVER

//limpando as variaveis
return
