#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �MTA225MNU �Autor  �Diorgenes Grzesiuk � Data �  26/02/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que habilita o recurso de consulta de Saldos em      ���
���          �Estoque de forma aglutinada atraves do atalho F4            ���
�������������������������������������������������������������������������͹��
���Uso       �Geral                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA225MNU()

//�������������������������������������������������������
//�Habilita a tecla F4 na rotina                        �
//�������������������������������������������������������     
SetKey(VK_F4, { || MTA225F4() })   
                                                              
//�������������������������������������������������������
//�Habilita a Bot�o na tela                             �
//�������������������������������������������������������     
aadd(aRotina,{'Reserva','U_RESEVPV()' , 0 , 3,0,NIL})  

Return          

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �MTA225F4  �Autor  �Diorgenes Grzesiuk � Data �  26/02/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela verificacao da rotina em execucao,  ���
���          �caso a rotina seja a consulta de saldo acessa o recurso,    ���
���          �caso contrario desabilita a tecla F4                        ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
             
Static Function MTA225F4()

IF ALLTRIM(FUNNAME()) == "MATA225"            
	MaViewSB2(SB2->B2_COD)     
Else
	SetKey(VK_F4, { || })	
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �MTA225F4  �Autor  �Diorgenes Grzesiuk � Data �  26/02/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela verificacao da rotina em execucao,  ���
���          �caso a rotina seja a consulta de saldo acessa o recurso,    ���
���          �caso contrario desabilita a tecla F4                        ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
             
User Function RESEVPV()  
Return
Static oDlg
Static oButton1
Static oGet1
Static nGet1 := SB2->B2_RESERVA
Static oGet2
Static nGet2 := SPACE(12)
Static oGroup1
Static oSay1
Static oSay2

  DEFINE MSDIALOG oDlg TITLE "Controle de Reserva" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 003, 001 GROUP oGroup1 TO 096, 200 PROMPT OF oDlg COLOR 0, 16777215 PIXEL
    @ 023, 007 SAY oSay1 PROMPT "Reservas:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 051, 009 SAY oSay2 PROMPT "Saldo Reserva" SIZE 039, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 070 MSGET oGet1 VAR nGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 049, 070 MSGET oGet2 VAR nGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 078, 151 BUTTON oButton1 PROMPT "&Gravar" SIZE 037, 012 OF oDlg PIXEL
  ACTIVATE MSDIALOG oDlg

Return