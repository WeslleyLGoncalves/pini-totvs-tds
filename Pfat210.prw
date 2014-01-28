#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � PFAT210  � Autor �Gilberto A. Oliveira Jr� Data � 23.11.00    ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Pergunte do Boleto Unibanco.                                  ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Editora Pini.                                      ���
����������������������������������������������������������������������������Ĵ��
��� Revis�o  �                                          � Data �             ���
����������������������������������������������������������������������������Ĵ��
��� ROTINAS AUXILIARES E RELACIONADAS.                                       ���
��� ����������������������������������                                       ���
���*PFAT210.PRX     - Principal: Chama perguntas e aciona PFAT210A.          ���
���  PFAT210A.PRX   - Aciona A210DET, grava arquivo txt e chama Bloqueto.Exe.���
���   A210DET.PRX   - Dados do Lay-Out para criacao do arquivo.txt           ���
���    NOSSONUM.PRX - Calcula Digito do Nosso Num. e incremente EE_FAXATU.   ���
���    CALMOD10.PRX - Calcula digitos de controle com base no Modulo 1021    ���
���    CALMOD11.PRX - Calcula digitos do Codigo de Barras com base no Mod.11 ���
����������������������������������������������������������������������������Ĵ��
���Observacao� Caso queira compilar varios desses Rdmakes utilize a Bat      ���
���          � BOL409.                                                       ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function Pfat210()

SetPrvt("_CPERG,_ACRA,_CSAVSCR1,_CSAVCUR1,_CSAVROW1,_CSAVCOL1")
SetPrvt("_CSAVCOR1,_LEMFRENTE,NOPCA,_CMSG,_SALIAS,AREGS")
SetPrvt("I,J,")

//��������������������������������������������������������������Ŀ
//� Define Variaveis PRIVADAS BASICAS                            �
//����������������������������������������������������������������
_cPerg := "UNIBAN"
//ValidPerg()

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    // Banco                   ?                     �
//� mv_par02    // Agencia                 ?                     �
//� mv_par03    // Conta                   ?                     �
//� mv_par04    // Carteira                ?                     �
//� mv_par05    // Nota                De  ?                     �
//� mv_par06    // Nota                Ate ?                     �
//� mv_par07    // Da Serie                ?                     �
//� mv_par08    // Do Vencimento           ?                     �
//� mv_par09    // Ate o Vencimento        ?                     �
//����������������������������������������������������������������
Pergunte(_cPerg,.T.)

//Pergunte(_cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Monta Tela Inicial Do Programa                               �
//����������������������������������������������������������������
@ 096,042 TO 323,505 DIALOG oDlg TITLE "Boleto - Unibanco"
@ 008,010 TO 84,222
@ 091,136 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 091,166 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     @ 91,166 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 091,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
//��������������������������������������������������������������Ŀ
//� Descricao generica do programa                               �
//����������������������������������������������������������������
@ 023,014 SAY "Este programa tem como objetivo gerar o arquivo"
@ 033,014 SAY "de Boletos Unibanco para impressao."
ACTIVATE DIALOG oDlg CENTERED

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OkProc0   �Autor  �Microsiga           � Data �  03/28/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chamada do processamento                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PFAT210                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function OkProc()

Pergunte(_cPerg,.F.)
Close(oDlg)
Processa({|| RunProc()})

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunProc   �Autor  �Microsiga           � Data �  03/28/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc()
_lEmFrente:= .T.
If mv_par01 # "409"
	_cMsg := OemToAnsi('O Banco deve obrigatoriamente ser o 409 - Unibanco. Favor Verificar !!!')
	MsgBox(_cMsg,"* * * ATENCAO * * *","STOP")
	_lEmFrente:= .F.
	Return
EndIf

If !(Alltrim(mv_par02)$"0138/0363") .And. _lEmFrente
	_cMsg := "A ag�ncia deve obrigatoriamente ser 0138 ou 0363.  Favor Verificar !!!"
	MsgStop(_cMsg,"A T E N C A O")
	_lEmFrente:= .F.
ElseIf Alltrim(mv_par02) == "0138"
	If !(Alltrim(mv_par03)$"1152758/1152741") //"1018599/1152741/1171162"
		_cMsg := "A conta deve obrigatoriamente ser 1152758 ou 1152741. Favor Verificar !!!"
		MsgStop(_cMsg,"A T E N C A O")
		_lEmFrente:= .F.
	EndIf
ElseIf Alltrim(mv_par02) == "0363"
//	If Alltrim(mv_par03) # "1018599"
//		_cMsg := "A conta deve obrigatoriamente ser 1018599. Favor Verificar !!!"
	If !(Alltrim(mv_par03)$"1018599/1018318") 
		_cMsg := "A conta deve obrigatoriamente ser 1018599 ou 1018318. Favor Verificar !!!"
		MsgStop(_cMsg,"A T E N C A O")
		_lEmFrente:= .F.
	EndIf
Endif

If Alltrim(mv_par04) # "20" .And. _lEmFrente
	_cMsg := "A carteira deve obrigatoriamente ser 20 - Cobranca Especial. Favor Verificar !!!"
	MsgStop(_cMsg,"A T E N C A O")
	_lEmFrente:= .F.
EndIf

If _lEmFrente
	//��������������������������������������������������������������Ŀ
	//� Gera arq. para impressao do Boleto Unibanco                  �
	//����������������������������������������������������������������
	ExecBlock('PFAT210A',.F.,.F., MV_PAR07)
EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �VALIDPERG � Autor �  Luiz Carlos Vieira	� Data � 18/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam		  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Espec�fico para clientes Microsiga						  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
_cPerg    := PADR(_cPerg,10) //mp10 x1_grupo char(10)
aRegs  := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{_cPerg,"01","Banco             ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA6"})
Aadd(aRegs,{_cPerg,"02","Agencia           ?","mv_ch2","C",05,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Conta             ?","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Carteira          ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"05","Da Nota Fiscal    ?","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"06","Ate Nota Fiscal   ?","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"07","Serie             ?","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"08","Juros/Dia         ?","mv_ch8","N",05,2,0,"G","","mv_par08","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"09","Desconto          ?","mv_ch9","N",10,2,0,"G","","mv_par09","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"10","Parcelas          ?","mv_chA","C",10,0,0,"G","","mv_par10","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"11","Dias p/Recebimento?","mv_chB","N",02,0,0,"G","","mv_par11","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"12","Do  Vencimento    ?","mv_chC","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"13","Ate Vencimento    ?","mv_chD","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"14","Multa             ?","mv_chE","N",05,2,0,"G","","mv_par14","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next

dbSelectArea(_sAlias)

Return
