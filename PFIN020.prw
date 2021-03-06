#include "rwmake.ch"
/*   Danilo C S Pala, solucao paleativa: relatorio 20050516
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN020	�Autor  �Danilo C S Pala     � Data �  20050419   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROCESSAR ARQUIVO DE RETORNO DO SISDEB 					  ���
���          �                     										  ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFIN020
// MONTAR TELA DE PARAMETROS                                        
Private CPATH := space(20)
Private DCPATH := space(20)
Private AteBordero := space(6)                                                    
PRIVATE NQTDREG := 0
PRIVATE NTOTALDEB := 0
PRIVATE COCOR := SPACE(10)
PRIVATE m_pag    := 1


@ 010,001 TO 150,300 DIALOG oDlg TITLE "PROCESSAR ARQUIVO DE RETORNO DO SISDEB"
@ 005,010 SAY "CAMINHO: \SIGA\IMPORTA\"
@ 020,010 SAY "ARQUIVO:"
@ 020,040 GET CPATH 
@ 055,010 BUTTON "Processar" SIZE 40,12 ACTION Processa({||PROC_RETSISDEB()})
@ 055,050 BUTTON "Fechar" SIZE 40,12 Action ( Close(oDlg) )
Activate Dialog oDlg CENTERED
RETURN             


STATIC FUNCTION PROC_RETSISDEB()
SetPrvt("_aCampos, _cnome, ncontador, ntotalreg")
ncontador := 0
ntotalreg := 0
                     
//20050516 da aki
SetPrvt("tamanho, limite, titulo, cDesc1, cDesc2")
SetPrvt("cDesc3, cNatureza, aReturn, SERNF, nomeprog")
SetPrvt("cPerg, nLastKey, lContinua, wnrel")
SetPrvt("mhora")


tamanho  := "p" // "G" 20080221
limite   := 132 // 220 20080221
titulo   := PADC("RETORNO DO SISDBE",74)
cDesc1   := PADC("Este mostra os titulos retornados pelo SISDEB ",74)
cDesc2   := PADC("para baixa manual paleativa.",74)
cDesc3   := ""
cNatureza:= ""

aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nomeprog := "FPIN020"
nLastKey := 0
lContinua:= .T.
MHORA      := TIME()
wnrel    := "PFIN020_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
cString:="SE1"
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"","",.F.)

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

LI:=0
LIN:=PROW()        
     
Lin := Cabec("RETORNO DO SISDBE","","",nomeprog,tamanho,15)  
Lin := Lin +2

@ LIN,005 PSAY "RETORNO DO PROCESSAMENTO DO SISDEB"
LIN++
LIN++           

ProcRegua(100)
 @ LIN,005 PSAY "SERIE"
 @ LIN,012 PSAY "NUMERO"
 @ LIN,020 PSAY "PARCELA"
 @ LIN,028 PSAY "VALOR"
 @ LIN,045 PSAY "DATA"
 @ LIN,056 PSAY "OCORRENCIA"
                                                  
 
 LIN++
 @ LIN,005 PSAY "-----"
 @ LIN,012 PSAY "------"
 @ LIN,020 PSAY "-------"
 @ LIN,028 PSAY "-------"
 @ LIN,045 PSAY "---------"
 @ LIN,056 PSAY "---------"
 
 // 20050516 ateh aki

_aCampos := {}
AADD(_aCampos,{"BRANCO1"   ,"C",73, 0})
AADD(_aCampos,{"DOCRET"    ,"C",15, 0})
AADD(_aCampos,{"BRANCO2" ,"C",46, 0})
AADD(_aCampos,{"NOSSONUM" ,"C",20, 0})
AADD(_aCampos,{"DTCOBRADA" ,"C",8, 0}) // DDMMAAAA
AADD(_aCampos,{"VLCOBRADO" ,"C",15, 0})
AADD(_aCampos,{"BRANCO3" ,"C",53, 0})
AADD(_aCampos,{"OCORRENC" ,"C",10, 0})
//AADD(_aCampos,{"" ,"C",1, 0})

DCPATH := "\SIGA\IMPORTA\" + CPATH

_cNome := CriaTrab(_aCampos,.t.)
MsAguarde({|| dbUseArea(.T.,, _cNome,"RETSISD",.F.,.F.)},"Criando arquivo temporario...")

DBSELECTAREA("RETSISD")
bBloco := "APPEND FROM &DCPATH SDF"
APPEND FROM &DCPATH SDF
MsAguarde({|| bBloco},"Apendando arquivo temporario...")
MSUNLOCK()
DBGOTOP()

        
DBSKIP() // header de arquivo
DBSKIP() // header de lote
ntotalreg := RecCount()
ProcRegua(RecCount() - 4 )
WHILE !EOF() .and. (ntotalreg - ncontador) > 4
    
	DBSELECTAREA("SE1")
	DBSETORDER(1)

	if DbSeek(xFilial("SE1")+rtrim(RETSISD->DOCRET))
		if e1_saldo > 0   
			COCOR := "BAIXADO, "
		else
			COCOR := ""
		endif
/*			Reclock("SE1",.F.)
			REPLACE E1_NUMBCO WITH SUBSTR( ALLTRIM(RETSISD->NOSSONUM),1,15)
			REPLACE E1_BAIXA WITH STOD( SUBSTR(RETSISD->DTCOBRADA,5,4) + SUBSTR(RETSISD->DTCOBRADA,3,2) + SUBSTR(RETSISD->DTCOBRADA,1,2) )
			REPLACE E1_SALDO WITH E1_SALDO - (VAL(RETSISD->VLCOBRADO) /100)
			REPLACE E1_HISTBX WITH "BAIXA POR RETORNO DE SISDEB"
			REPLACE E1_MOTIVO WITH "NOR"
			MSunlock()
			*/  //Danilo C S Pala solucao paleativa, gerar relatorio com os arquivos retornado pelo banco
			
		LIN++
	 	@ LIN,005 PSAY SUBSTR(RETSISD->DOCRET,1,3) // SERIE
		@ LIN,012 PSAY SUBSTR(RETSISD->DOCRET,4,6) // "NUMERO"
		@ LIN,020 PSAY SUBSTR(RETSISD->DOCRET,10,2)// "PARCELA"
		@ LIN,028 PSAY (VAL(RETSISD->VLCOBRADO) /100) //"VALOR"
	 	@ LIN,045 PSAY  SUBSTR(RETSISD->DTCOBRADA,1,2) + "/" +SUBSTR(RETSISD->DTCOBRADA,3,2) + "/"+ SUBSTR(RETSISD->DTCOBRADA,5,4)  //"DATA"
		@ LIN,056 PSAY RETSISD->OCORRENC //"OCORRENCIA"
		
	endif
    
	ncontador++
	dbselectarea("RETSISD")
	DBSKIP()
END                                                   

SET DEVICE TO SCREEN       //20050516

SETPRC(0,0)
	
SET DEVICE TO PRINTER
	
//SetPrc(0,0)        //20080221
                        
SET DEVICE TO SCREEN        
IF aRETURN[5] == 1
	Set Printer to
	//dbcommitAll() //20080221
	ourspool(WNREL)
ENDIF //20050516

DBSELECTAREA("RETSISD")
DBCLOSEAREA("RETSISD")

DBSELECTAREA("SE1")
DBCLOSEAREA("SE1")
RETURN