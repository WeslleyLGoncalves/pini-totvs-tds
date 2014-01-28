#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFDEF WINDOWS
    #DEFINE SAY PSAY
#ENDIF

User Function Rfatr34()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NORDEM,_NREG,M_PAG,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NOMEPROG")
SetPrvt("CPERG,NLASTKEY,WNREL,CSTRING,CCABEC1,CCABEC2")
SetPrvt("_ACAMPOS,_CARQ,NLIN,_CPREF,_NDUPL,_NTOTNF")
SetPrvt("_NTOTDUP,AREGS,I,J,mhora")

#IFDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>     #DEFINE SAY PSAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR34   �Autor: Roger Cangianeli       � Data:   21/09/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Relat�rio de Conferencia de Notas Emitidas x Duplicatas    � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI                                            � ��
������������������������������������������������������������������������Ĵ ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_cAlias := Alias()
_nOrdem := IndexOrd()
_nReg   := Recno()

//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Nota Inicial                 �
//�   mv_par02 = Nota Final                   �
//�   mv_par03 = Serie                        �
//���������������������������������������������
M_PAG    := 1
tamanho  := "P"
limite   := 80
titulo   := "FATURAMENTO X DUPLICATAS"
cDesc1   := "Este programa emite relat�rio de Notas Fiscais por Duplicatas"
cDesc2   := " "
cDesc3   := " "

aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "RFATR34"

cPerg    := "FATR34"
ValidPerg()

If !Pergunte(CPERG)
   Return
EndIf
nLastKey := 0
MHORA := TIME()
wnrel    := "RFATR34_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������

CSTRING  := "SF2"
cCabec1  := "N O T A   F I S C A L      DUPLICATA"
cCabec2  := "Ser/Numero  Valor          Valor"
//           XXX/999999  99,999,999.99  99,999,999.99

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
EndIf

#IFDEF WINDOWS
    Processa({||_RunProc()}, "Selecionando Notas ...")// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>     Processa({||Execute(_RunProc)}, "Selecionando Notas ...")
#ELSE
    _RunProc()
#ENDIF


dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoTo(_nReg)
Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function _RunProc
Static Function _RunProc()
//��������������������������������������������������������������Ŀ
//�  Prepara regua de impress�o                                  �
//����������������������������������������������������������������

_aCampos := {{"SERIE"   ,"C",06,0},;
             {"NUM"     ,"C",06,0},;
             {"VALNF"   ,"N",16,2},;
             {"VALDUP"  ,"N",16,2}}

_cArq := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cArq,"SERIE+NUM",,,"Selecionando registros .. ")

nLin   := 80

dbSelectArea("SF2")
dbSetOrder(1)
ProcRegua(RecCount())
dbSeek(xFilial("SF2")+MV_PAR01+MV_PAR03, .T.)
While !Eof() .and. SF2->F2_DOC <= MV_PAR02 .and. SF2->F2_FILIAL==xFilial("SF2")
    IncProc()

    If SF2->F2_SERIE #MV_PAR03
        dbSkip()
        Loop
    EndIf
** FALAR COM ROGER
    _cPref := ""
    dbSelectArea("SE1")
    dbSetOrder(2)
    If !dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC, .F.)
        If dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC, .F.)
            _cPref := SE1->E1_PREFIXO
        EndIf
    Else
        _cPref := "FAT"
    EndIf

    If !"P" $ SE1->E1_PEDIDO
        dbSelectArea("SC5")
        dbSetOrder(1)
        If dbSeek(xFilial("SC5")+SE1->E1_PEDIDO, .F.)
            If SC5->C5_DIVVEN #"PUBL"
                dbSelectArea("SF2")
                dbSkip()
                Loop
            EndIf
        Else
            dbSelectArea("SF2")
            dbSkip()
            Loop
        EndIf
    EndIf

    _nDupl := 0
    dbSelectArea("SE1")
    While !Eof() .and. SE1->E1_FILIAL == xFilial("SE1") .and.;
        SF2->F2_CLIENTE+SF2->F2_LOJA == SE1->E1_CLIENTE+SE1->E1_LOJA .and.;
        SE1->E1_NUM == SF2->F2_DOC .and. SE1->E1_PREFIXO == _cPref

        _nDupl := _nDupl + SE1->E1_VALOR

        dbSelectArea("SE1")
        dbSkip()
    End

    RecLock("TRB", .T.)
    TRB->SERIE  := SF2->F2_SERIE
    TRB->NUM    := SF2->F2_DOC
    TRB->VALNF  := SF2->F2_VALBRUT
    TRB->VALDUP := _nDupl
    msUnlock()

    dbSelectArea("SF2")
    dbSkip()

End

#IFDEF WINDOWS
    RptStatus({||_RunPrint()}, "Imprimindo Relacao de Notas...")// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>     RptStatus({||Execute(_RunPrint)}, "Imprimindo Relacao de Notas...")
#ELSE
    _RunPrint()
#ENDIF
Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function _RunPrint
Static Function _RunPrint()

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
EndIf

_nTotNF := 0
_nTotDup:= 0

DbSelectArea("TRB")
dbGoTop()
While !eof()

    If nLin > 58
       nLin     := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18)
       nLin     := nLin + 2
    Endif

    @ nLin,000 SAY AllTrim(TRB->SERIE)
    @ nLin,003 SAY "/"+TRB->NUM
    @ nLin,013 SAY TRB->VALNF   Picture "@E 99,999,999.99"
    @ nLin,028 SAY TRB->VALDUP  Picture "@E 99,999,999.99"
    nLin     := nLin + 1
    _nTotNF := _nTotNF + TRB->VALNF
    _nTotDup:= _nTotDup + TRB->VALDUP

    dbSkip()

End

nLin    := nLin + 1
@ nLin,000 SAY "========================================="
nLin    := nLin + 1
@ nLin,000 SAY "TOTAL  -> "
@ nLin,013 SAY _nTotNF  Picture "@E 99,999,999.99"
@ nLin,028 SAY _nTotDup Picture "@E 99,999,999.99"
Eject

dbCloseArea()
fErase(_cArq+".DBF")
fErase(_cArq+OrdBagExt())

Set Device to Screen
If aReturn[5] == 1
    Set Printer To
    ourspool(wnrel)
Endif

MS_FLUSH()

Return


/*/
���������������������������������������������������������������������
������������������������������������������������������������������Ŀ�
��Funcao    �VALIDPERG� Autor � Jose Renato July � Data � 25.01.99 ��
������������������������������������������������������������������Ĵ�
��Descricao � Verifica perguntas, incluindo-as caso nao existam.   ��
������������������������������������������������������������������Ĵ�
��Uso       � SX1                                                  ��
������������������������������������������������������������������Ĵ�
��Release   � 3.0i - Roger Cangianeli - 12/05/99.                  ��
�������������������������������������������������������������������ٱ
���������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function VALIDPERG
Static Function VALIDPERG()

   cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
   aRegs    := {}
   dbSelectArea("SX1")
   dbSetOrder(1)
   AADD(aRegs,{cPerg,"01","Nota Inicial       ?","mv_ch1","C",06,0,2,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Nota Final         ?","mv_ch2","C",06,0,2,"G","","mv_par02","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"03","Serie das Notas    ?","mv_ch3","C",03,0,2,"G","","mv_par03","","","","","","","","","","","","","","",""})
   For i := 1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j := 1 to FCount()
            If j <= Len(aRegs[i])
               FieldPut(j,aRegs[i,j])
            Endif
         Next
         MsUnlock()
      Endif
   Next

Return
