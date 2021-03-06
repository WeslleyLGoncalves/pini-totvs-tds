#include "rwmake.ch"
#include "ap5mail.ch"
/*     20030829
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Pfat151   �Autor  �Danilo C S Pala     � Data �  04/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Informatizacao de aprovacao de proposta de credito, atraves���
���          �  do envio de email                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function Pfat151

Private _cTitulo  := "Informatizacao de aprovacao de proposta"
Private _ccMens1  := "Informe o CPF/CGC:"
Private ctexto := "Consultar"
Private ctexto1 := "Enviar"
Private ctexto2 := "Fechar"
Private ctexto3 := "Prospects"
Private _ccMens2  := "Valor da proposta:"
Private CMsg3 := "Razao social:"
Private CMsg4 := "Telefone:"
Private CMsg5 := "Data:"
Private CMsg6 := "Vendedor:"
Private cRz := space(50)
Private cDe  := "E-mail de:"
Private cPara  := "E-mail para:"
Private cOrigem := space(60) 
Private aItens := {"maurocosta@pini.com.br","brunogoncalves@pini.com.br","debora.andrade@pini.com.br"}
Private cDestino := "mauriciopc@pini.com.br" //"marceloa@pini.com.br" 
Private lEnd      := .F.
Private nCont     := 0
Private cCli := space(14)
Private nValor := 0
Private lClienteSN
Private cTipocli := space(1)
Private cCodCliente := space(6) 
Private cTel := space(50)
Private cData := Dtoc(date())
Private cVendedor := space(50)       
Private aRadio := {"A vista","A prazo"}
Private nRadio := 1
Private NumeroParcela  := space(2) 
Private MsgParcela := "Parcelado em "
Private MSgFormaPag := "Forma de Pagamento"          
Private NRisco := 0
Private nRiscoTotal := 0
setprvt("_aCampos, _cNome, caIndex, caChave, caFiltro")

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
                             
@ 010,001 TO 300,400 DIALOG oDlg TITLE _cTitulo
@ 005,010 SAY _ccMens1
@ 005,070 GET cCli  Picture "@R 99.999.999/9999-99"
@ 005,110 BUTTON cTexto SIZE 40,11 ACTION   Processa({||VerificaCli()})
@ 005,150 BUTTON cTexto3 SIZE 40,11 ACTION   Processa({||U_Axfat027()})
@ 020,010 SAY cMsg3
@ 020,070 GET cRz
@ 030,010 SAY cMsg4
@ 030,070 GET cTel
@ 040,010 SAY cMsg5
@ 040,070 GET cData
@ 050,010 SAY cMsg6
@ 050,070 GET cVendedor
@ 060,010 SAY _ccMens2
@ 060,070 GET nValor Picture "@R 999,999.99"
@ 075,010 SAY MsgFormaPag
@ 075,070 RADIO aRadio VAR nRadio
@ 090,010 SAY MSgParcela
@ 090,070 Get NumeroParcela
@ 100,010 SAY cDe               
@ 100,070 COMBOBOX cOrigem ITEMS aItens SIZE 90,90
//@ 100,070 GET cOrigem
@ 110,010 SAY cPara
@ 110,070 GET cDestino          
@ 125,070 BUTTON cTexto1 SIZE 40,11 ACTION Processa({||EnviaMail()})
@ 125,110 BUTTON cTexto2 SIZE 40,11 Action ( Close(oDlg) )
Activate Dialog oDlg CENTERED

Return



//�����������������������������������Ŀ
//�Funcao para verificar se eh cliente�
//�������������������������������������

Static Function VerificaCli()

cCli := Alltrim(ccli)
DbSelectArea("SA1")
DbSetOrder(3)

If !DbSeek(xFilial("SA1")+cCli)
	// nao eh cliente
	lClienteSN := .F.
	Msgalert(Xfilial("SA1")+cCli+" nao e cliente.")
else
	lClienteSN := .T.
	Msgalert(Xfilial("SA1")+cCli + " e cliente.")
	cRz := SA1->A1_NOME
	cCodCliente := SA1->A1_cod
	cTipocli := SA1->a1_tpcli  
	cTel := SA1->a1_tel
endif

DbCloseArea("SA1")
return



//������������������������Ŀ
//�Funcao para enviar email�
//��������������������������

Static function EnviaMail()

Private cServMail := "172.22.4.51"
Private cBody     := "<html><title>Aprovacao de proposta de credito</title>"
cBody +="<body><h3>Aprovacao de proposta de credito - "+AllTrim(cRz)+"</h3> <hr>"
if lClienteSN
	//eh cliente
	cBody += "<p><b>1. Dados do Cliente</b><br>"
	cBody += "Codigo: <i>"+cCodCliente+"</i><br>"
	if len(cCli) = 11 .and. cTipocli = "F"
		//pessoa fisica
		cBody += "CPF:<i> "+Transform(cCli,"@R 999.999.999-99")+"</i><br>"
		cBody += "Nome: <i>"+cRz+"</i><br>"
		cBody += "Telefone: <i>"+cTel+"</i><br>"		
		cBody += "Data: <i>"+CData+"</i><br>" 
		cBody += "Vendedor: <i>"+cVendedor+"</i><br>"
		cBody += "Valor da proposta: <i>R$ "+Transform(nValor,"@E 999,999.99")+"</i><br>"
	else
		cBody += "CGC:<i> "+Transform(cCli,"@R 99.999.999/9999-99")+"</i><br>"
		cBody += "Razao Social: <i>"+cRz+"</i><br>"
		cBody += "Telefone: <i>"+cTel+"</i><br>"		
		cBody += "Data: <i>"+CData+"</i><br>" 
		cBody += "Vendedor: <i>"+cVendedor+"</i><br>"
		cBody += "Valor da proposta: <i>R$ "+Transform(nValor,"@E 999,999.99")+"</i><br>"
		
	endif
	//DADOS SE1
	cBody += "<hr> <p><b>2. Posicao do Cliente</b><br>"
	cBody += "<center> <table border=1 cellpadding=1>"
	cBody += "<tr><th>CLIENTE</th>"
	cBody += "<th>NUM</th>"
	cBody += "<th>PARC</th>"
	cBody += "<th>VALOR</th>"
	cBody += "<th>EMISS</th>"
	cBody += "<th>VENCTO</th>"
	cBody += "<th>BAIXA</th>"
	cBody += "<th>PORT</th>" 
	cBody += "<th>MOT</th>"
	cBody += "<th>SALDO</th>"

	DbselectArea("SE1")
	DbSetOrder(2)
	DbSeek(xfilial("SE1")+cCodCliente)
	
	While (SE1->E1_CLIENTE = cCodCliente)
        if (DTOS(SE1->E1_EMISSAO) >= "20000101") //alteracao em 16/05/2003
        
		  if (SE1->E1_SALDO <> 0) .OR. Empty(SE1->E1_BAIXA);
				.OR. 'LP'$(SE1->E1_MOTIVO) .OR. 'CAN'$(SE1->E1_MOTIVO);
				.OR. 'DEV'$(SE1->E1_MOTIVO) .OR. '920'$(SE1->E1_PORTADO) .OR. '930'$(SE1->E1_PORTADO)

			nRisco += SE1->e1_SALDO
			// em destaque: Parcela nao paga
			cBody += "<tr><td><FONT COLOR='#FF0000'><i><b>"+SE1->e1_CLIENTE+"</b></i></FONT></td>"
			cBody += "<tD><FONT COLOR='#FF0000'><i><b>"+SE1->e1_NUM+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+SE1->e1_PARCELA+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+Transform(SE1->e1_VALOR,"@E 999,999.99")+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+dtoc(SE1->E1_EMISSAO)+"</b></i></FONT></td>"		
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+dtoc(SE1->e1_VENCTO)+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+dtoc(SE1->e1_BAIXA)+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+SE1->e1_PORTADO+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+SE1->e1_MOTIVO+"</b></i></FONT></td>"
			cBody += "<td><FONT COLOR='#FF0000'><i><b>"+Transform(SE1->e1_SALDO,"@E 999,999.99")+"</b></i></FONT></td></tr>"
			
		  else
			cBody += "<tr><td>"+SE1->e1_CLIENTE+"</td>"
			cBody += "<tD>"+SE1->e1_NUM+"</td>"
			cBody += "<td>"+SE1->e1_PARCELA+"</td>"
			cBody += "<td>"+Transform(SE1->e1_VALOR,"@E 999,999.99")+"</td>"
			cBody += "<td>"+dtoc(SE1->E1_EMISSAO)+"</td>"		
			cBody += "<td>"+dtoc(SE1->e1_VENCTO)+"</td>"
			cBody += "<td>"+dtoc(SE1->e1_BAIXA)+"</td>"
			cBody += "<td>"+SE1->e1_PORTADO+"</td>"
			cBody += "<td>"+SE1->e1_MOTIVO+"</td>"		
			cBody += "<td>"+Transform(SE1->e1_SALDO,"@E 999,999.99")+"</td></tr>"
		  endif
		endif
		DbSkip()
	end
	cBody += "</table></center></p>"
else
	//nao cliente 
	nRisco := 0
	if len(cCli) = 11
		//pessoa fisica
		cBody += "<p><b>1. Dados da Pessoa Fisica</b><br>"
		cBody += "CPF:<i> "+Transform(cCli,"@R 999.999.999-99")+"</i><br>"
		cBody += "Nome: <i>"+cRz+"</i><br>"
		cBody += "Telefone: <i>"+cTel+"</i><br>"		
		cBody += "Data: <i>"+CData+"</i><br>" 
		cBody += "Vendedor: <i>"+cVendedor+"</i><br>"
		cBody += "Valor da proposta: <i>R$ "+Transform(nValor,"@E 999,999.99")+"</i><br>"
		cBody += "<hr> <p><b>2. Posicao do Cliente</b><br>"
		cBody += "Nada consta (nao e cliente)"
	else
		cBody += "<p><b>1. Dados da Pessoa Juridica</b><br>"
		cBody += "CGC:<i> "+Transform(cCli,"@R 99.999.999/9999-99")+"</i><br>"
		cBody += "Razao Social: <i>"+cRz+"</i><br>"
			cBody += "Telefone: <i>"+cTel+"</i><br>"		
		cBody += "Data: <i>"+CData+"</i><br>" 
		cBody += "Vendedor: <i>"+cVendedor+"</i><br>"
		cBody += "Valor da proposta: <i>R$ "+Transform(nValor,"@E 999,999.99")+"</i><br>"
		cBody += "<hr> <p><b>2. Posicao do Cliente</b><br>"
		cBody += "Nada consta (nao e cliente)"
	endif
endif

	cBody += "<hr><p><b>3. Operacao Proposta</b><br>"
	cBody += "Produto:<br>"
	cBody += "<input type='text' size=1> Sistema (software) "
	cBody += "<input type='text' size=1> Publicidade "
	cBody += "<input type='text' size=1> Outros  _______________________________</p>"
	
	cBody += "<hr><p><b>4. Risco Cliente</b><br>"
	cBody += "<table>"
	cBody += "<tr><td>Risco Atual<td>R$ "+Transform(nRisco,"@E 999,999.99")+ "<br></tr>"
	cBody += "<tr><td>Operacao Proposta<td>R$ "+Transform(nValor,"@E 999,999.99")+ "<br></tr>"
	nRiscoTotal := nRisco + nValor	
	cBody += "<tr><td>Risco Total<td>R$ "+Transform(nRiscoTotal,"@E 999,999.99")+ "<br></tr>"
	cBody += "</table></p>"
	
	cBody += "<hr><p><b>5. Forma de Pagamento:</b><i>"+ aRadio[nRadio]+"</i><br>"
	if nRadio = 2
		cBody += "Parcelado em <i>"+ Transform(NumeroParcela,"@E 99") +"</i> vezes<br>"
	endif
	
	cBody += "<hr><p><b>6. Aprovacao</b><br>"
	cBody += "Atraso: <input type='text' size=1> Sim "
	cBody += "<input type='text' size=1> Nao </p>"
	cBody += "<table cellpadding=0>"
	cBody += "<tr><td>Serasa</td><td> ________________________________________</td></tr>"
	cBody += "<tr><td>ACSP</td><td> ________________________________________</td></tr>"
	cBody += "<tr><td>Restricoes<td> _________________________________________________________</td></tr>"         
	cBody += "<tr><td>___________</td><td>_________________________________________________________</td></tr>"
	cBody += "<tr><td>___________</td><td>_________________________________________________________</td></tr>"
	cBody += "<tr><td>___________</td><td>_________________________________________________________</td></tr>"
	cBody += "<tr><td>___________</td><td>_________________________________________________________</td></tr>"
	cBody += "<tr><td>___________</td><td>_________________________________________________________</td></tr>"
	cBody += "</table>"


	cBody += "<hr><p>Aprovado: "
	cBody += "<input type='text' size=1> Sem restricoes  "
	cBody += "<input type='text' size=1> Com restricoes </p>"
	        
	cBody += "<hr><p>Obs. ________________________________________________________________<br>"
	cBody += "____________________________________________________________________<br>"
	cBody += "____________________________________________________________________<br>"
	cBody += "____________________________________________________________________<br>"
	cBody += "____________________________________________________________________<br></p>"

	cBody += "<table cellpadding =5>"
	cBody += "<tr><td>Gerente de Vendas<td>________________________________________</tr>"
	cBody += "<tr><td>Analista<td>________________________________________</tr>"
	cBody += "<tr><td>Supervisor<td>________________________________________</tr>"
	cBody += "<tr><td>Gte Adm/Financeiro<td>________________________________________</tr>"
	cBody += "<tr><td>Diretor Geral<td>________________________________________</tr>"         
	cBody += "</table>"

cBody += "<hr>Att,<br> Sistema de aprovacao de proposta de credito</p>"
cBody += "</body></html>"
Private cTitulo1   := "Aprovacao de credito - "+AllTrim(cRz)
                                                       
CONNECT SMTP SERVER cServMail ACCOUNT cOrigem PASSWORD "1234"
SEND MAIL FROM cOrigem TO cDestino SUBJECT cTitulo1 BODY cBody
SEND MAIL FROM cOrigem TO cOrigem SUBJECT cTitulo1 BODY cBody
DISCONNECT SMTP SERVER

//limpando as variaveis
ccli := space(14)
cRz := space(50)
nValor := 0 
cTipoCli := space(1) 
cTel := space(50)    
NRisco := 0         
NumeroParcela := 0
MsgAlert("Mensagem enviada com sucesso")
return
