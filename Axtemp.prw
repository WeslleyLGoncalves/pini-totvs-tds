#include "rwmake.ch" 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: AXTEMP    �Autor: DANILO C S PALA        � Data:   20120509 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: CADASTRO DE Qq arquivo                                     � ��
���LOG DE CONSULTA							                             � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : PINI                                                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Axtemp()
Local _cTitulo  := "Abrir a tabela desejada"
Local cQuery := space(3)
Local lExec := .F.
Local cLoginUsuario := alltrim(substr(cusuario,7,15))

If (cLoginUsuario=="Administrador")

	@ 010,001 TO 210,400 DIALOG oDlg TITLE _cTitulo
	@ 020,010 SAY "Tabela:"
	@ 020,040 GET cQuery
	@ 080,020 BUTTON "Abrir" SIZE 40,11 ACTION (lExec := .T.,Close(oDlg))
	@ 080,080 BUTTON "Sair" SIZE 40,11 Action (lExec := .F.,Close(oDlg))
	Activate Dialog oDlg CENTERED      

	if lExec
		axCadastro( cQuery, "TABELA "+ cQuery)
	endif
Else 
	MsgAlert("Usu�rio sem direito de acesso")
Endif
	
Return
