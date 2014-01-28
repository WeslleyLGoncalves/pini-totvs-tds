#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EPFAT033  � Autor � Rodolfo  Vacari    � Data �  03/10/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Faz a importaccao dos arquivos TXT e grava os registros em ���
���          � tabela.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Editora Pini                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function EPFAT034()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd
Local aStru := {}
Local aPerg := {}
Local aRet	:= {}
//Local cMes := Space(4)
//Local cAno := Space(4)
Local cArquivo := Space(100)

Private OkLeTxt
Private cString := "SF2"

dbSelectArea(cString)
aStru := dbStruct()

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento e Parametros.                     �
//�����������������������������������������������������������������������
//aAdd( aPerg ,{1,"Dia + Mes: ",cMes,"@!",'!Empty(mv_par01)',,'.T.',20,.T.})
//aAdd( aPerg ,{1,"Ano      : ",cAno,"@!",'!Empty(mv_par02)',,'.T.',20,.T.})
aAdd( aPerg ,{6,"Buscar arquivo",cArquivo,"","!Empty(mv_par01) .And. FILE(mv_par01) ","",90,.T.,"Todos os arquivos (*.*) |*.*"})
aAdd( aPerg ,{9,"Informe o ARQUIVO para fazer a Importa��o!",120,24,.T.})

If Parambox(aPerg,"Importa��o NFSC",aRet)
	Processa({|| OkLeTxt()},"Aguarde...")
	Aviso(OemToAnsi("Confirma��o"),"Processo Finalizado",{"Ok"},1)
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � Rodolfo Vacari     � Data �  03/10/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt()

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local aConteudo := {}
Local aGrvCFD := {}
Local CPERVEN := "" 
Local nRec	  := 0
Local lSeek

//VERIFICA SE O ARQUIVO SELECIONADO EXISTE NA PASTA, SE NAO EXISTIR NAO EXECUTA O PROGRAMA
If !File(AllTrim(mv_par01))
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!") 
    Return
Endif

//ABRE O ARQUIVO, MONTA A REGUA DE PROCESSAMENTO E INICIA A LEITURA
FT_FUSE(AllTrim(mv_par01))
ProcRegua(FT_FLASTREC())
dbGotop(FT_FGOTOP())
While ! FT_FEOF()
    
    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������
    IncProc()

	//FAZ A LEITURA DA LINHA DO TXT
	cBuffer := FT_FREADLN()
	
    nRec := FT_FRECNO()

	dbSelectArea(cString)
	dbSetOrder(10)
	
	// VALIDACAO PARA VERIFICAR SE O REGISTRO EXISTE...
    
	lSeek := !dbSeek(xFilial("SF2")+SUBSTR(cBuffer,98,06)+"   21",.F.)
	RecLock(cString,lSeek)
		SF2->F2_XCHNFSC := UPPER(SUBSTR(cBuffer,104,32))
		SF2->F2_FIMP    := "N"   
		
	MSUnLock()     
		
    //���������������������������������������������������������������������Ŀ
    //� Leitura da proxima linha do arquivo texto.                          �
    //�����������������������������������������������������������������������
    FT_FSKIP()  
    
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
FT_FUSE()

Return
