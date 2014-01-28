#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT046   �Autor: Fabio William          � Data:   18/11/99 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Cancela a AV                                               � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
������������������������������������������������������������������������Ĵ ��
���Objetivo : Cancelar a av programada.                                  � ��
������������������������������������������������������������������������Ĵ ��
���Release  : Roger Cangianeli, padronizacao e conv.Windows.04/02/00.    � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat046()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

Local aArea := GetArea()
SetPrvt("_CALIAS,_NINDEX,_NREG,CPERG,_CMSG,_MEDINIC")
SetPrvt("_MEDFIM,_MCONT,_CSTR,_CPARAMETRO,")
//��������������������������������������¿
//��   MV_PAR01  Numero Av.             ��
//��   MV_PAR02  Codigo do Cliente      ��
//��   MV_PAR03  Item da AV             ��
//��   MV_PAR04  Edicao Inicial         ��
//����������������������������������������
cPerg    := "ROTCAN"
If !Pergunte(CPERG)
   Return
EndIf

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Cancelamento Avs."
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("PFAT46")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>     @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa colocara Situacao Cancelado nas AVs definidas pelo parametro."
@ 33,14 SAY "   - Ok - Dispara a Geracao "
//   @ 43,14 SAY "   -ProcRegua() - Ajusta tamanho da regua"
//   @ 53,14 SAY "   -IncProc() - Incrementa posicao da regua"
Activate Dialog oDlg5
Return

RestArea(aArea)

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: okproc    �Autor: Fabio William          � Data:   18/11/99 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Chamada de processamento                                   � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
������������������������������������������������������������������������Ĵ ��
���Objetivo : Cancelar o av programada.                                  � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkProc()
DbSelectArea("SZS")

Close(oDlg5)
Processa( {|| RunProc() } )
ProcRegua(Reccount())

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: runproc   �Autor: Fabio William          � Data:   18/11/99 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Efetua o cancelamento                                      � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
������������������������������������������������������������������������Ĵ ��
���Objetivo : Cancelar o av programada.                                  � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunProc()

dbSelectArea("SZS")
dbSetOrder(1)  // Num av +  Item + Edicao
If !dbSeek( xFilial("SZS") + MV_PAR01 + MV_PAR03, .T. )
    Return
EndIf

If SZS->ZS_CODCLI #MV_PAR02
    _cMsg := "AV NAO PERTENCE A ESTE CLIENTE !"
    MsgAlert( _cMsg, "ATENCAO")
    Return
EndIf

dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial("SC5")+SZS->ZS_NUMAV, .F.)
    If SC5->C5_AVESP == "S"
        _cMsg := "Esta A.V. possui faturamento especial. Nao esqueca de exclui-la na rotina Faturamento Programado."
        MsgBox( _cMsg, "ATENCAO", "ALERT" )
    EndIf
EndIf

_medinic := ' '
_medfim  := ' '
_mcont   := 0

dbSelectArea("SZS")
While !Eof() .and. SZS->ZS_FILIAL == xFilial("SZS") .and. SZS->ZS_NUMAV+SZS->ZS_ITEM == MV_PAR01+MV_PAR03
    If SZS->ZS_EDICAO < MV_PAR04
        dbSkip()
        Loop
    EndIf
	
    If VAL(SZS->ZS_NFISCAL) <> 0
        _cMsg := "AV JA FATURADA !"
        MsgAlert( _cMsg, "ATENCAO")
        Return
    EndIf

    dbSelectArea("SZS")
    IncProc("Processando AV "+Alltrim(SZS->ZS_NUMAV))
	
    RecLock("SZS",.F.)
    SZS->ZS_SITUAC := "CC"
    SZS->(msunlock())
    if _mcont == 0
       _medinic := SZS->ZS_EDICAO    
    else
       _medfim  := SZS->ZS_EDICAO    
    endif
    _mcont++
    dbSkip()
End
//_CSTR := SPACE(13)+"Edi��o Inicial Cancelada   : " + STR(_medinic,4) + SPACE(23);
  //       + " Edi��o Final   Cancelada   : " + STR(_medfim,4) + SPACE(13);
    //     + "Total de Edi��es Canceldas : " + STR(_mcont,4)
//#IFDEF WINDOWS
  // MSGBOX(_CSTR,'Aten��o','ALERT')
//#ELSE
  // ALERT(_CSTR)
//#ENDIF
_cParametro := MV_PAR01+MV_PAR03

EXECBLOCK("RELAUT",.F.,.F.,_cParametro)
Return