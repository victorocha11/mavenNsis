; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "testeMaven"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Rocha Software, Ltda."
!define PRODUCT_WEB_SITE "http://www.minhacompania.com.br"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\testeMaven.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\llama-grey.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

Name "Maven Test Installer"
;OutFile "testeMaven.exe"

!include MUI.nsh
!include Sections.nsh

##===========================================================================
## Modern UI Pages
##===========================================================================

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

!insertmacro MUI_PAGE_WELCOME

!define MUI_PAGE_CUSTOMFUNCTION_PRE SelectFilesCheck
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE ComponentsLeave
!insertmacro MUI_PAGE_COMPONENTS

## Aqui fica o título da página de diretorio
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(MUI_DIRECTORYPAGE_TEXT_TOP_A)"

!define MUI_PAGE_CUSTOMFUNCTION_PRE SelectFilesA
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

## Aqui fica o título da segunda página de diretorio
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(MUI_DIRECTORYPAGE_TEXT_TOP_B)"

!define MUI_PAGE_CUSTOMFUNCTION_PRE SelectFilesB
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DeleteSectionsINI
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "PortugueseBR"

##===========================================================================
## Language strings
##===========================================================================

##linhas que serão trocadas no arquivo
LangString LineToBeChangedSer ${LANG_PORTUGUESEBR} "alo"
LangString LineToBeChangedCli ${LANG_PORTUGUESEBR} "alo"

##linhas que serão escritas
LangString NewLineSer ${LANG_PORTUGUESEBR} "trocou"
LangString NewLineCli ${LANG_PORTUGUESEBR} "trocou"

##Arquivos que serão manipulados
LangString FileSer ${LANG_PORTUGUESEBR} "C:\Users\Administrador\Desktop\SomeFile.txt"
LangString FileCli ${LANG_PORTUGUESEBR} "C:\Users\Administrador\Desktop\SomeFile.txt"

LangString NoSectionsSelected ${LANG_PORTUGUESEBR} "Selecione algo para instalar!"

LangString MUI_DIRECTORYPAGE_TEXT_TOP_A ${LANG_PORTUGUESEBR} "Setup vai instalar \
a pasta servidor no seguinte diretório..."
LangString MUI_DIRECTORYPAGE_TEXT_TOP_B ${LANG_PORTUGUESEBR} "Setup vai instalar \
a pasta cliente no seguinte diretório..."

##===========================================================================
## Seções
##===========================================================================

## Sections Group 1
SectionGroup /e "SERVER" PROG1
Section "Server" SEC1

  SetOutPath "$INSTDIR\server"
  SetOverwrite ifnewer
   File "C:\Users\Administrador\Desktop\Maven\server\part4-0.0.1-SNAPSHOT.jar"
  CreateDirectory "$SMPROGRAMS\testeMaven\server"
  CreateShortCut "$SMPROGRAMS\testeMaven\testeMaven.lnk" "$INSTDIR\instalador.exe"  "" "${NSISDIR}\Contrib\Graphics\Icons\llama-blue.ico"
  CreateShortCut "$DESKTOP\testeMaven.lnk" "$INSTDIR\instalador.exe" "" "${NSISDIR}\Contrib\Graphics\Icons\llama-blue.ico"

;messagebox mb_ok "instalando primeira parte do servidor"

  FileOpen $4 "$DESKTOP\SomeFile.txt" a
  FileSeek $4 0 END
  FileWrite $4 "$\r$\n" ; we write a new line
  FileWrite $4 "$INSTDIR\server"
  FileWrite $4 "$\r$\n" ; we write an extra line
  FileClose $4 ; and close the file

SectionEnd

Section "atualizar caminho da pasta" SEC2

;messagebox mb_ok "instalando segunda parte do servidor"

Push "$(LineToBeChangedSer)"                #-- line to be found
Push "$(NewLineSer)"                        #-- line to be added
Push "$(FileSer)"                           #-- file to be searched in

  Exch $0    ;file to replace in
  Exch
  Exch $1    ;line to be added
  Exch
  Exch 2
  Exch $2    ;line to be search
  Exch 2

  Push $R0   ;save data,then use to open file
  Push $R1   ;save data,then use to temp file
  Push $R2   ;save data,then use to tmpstring

  ClearErrors

  FileOpen $R0 "$0" a
  FileOpen $R1 temp.ini w

    FileRead $R0 $R2
    IfErrors +11
;search for a string
    StrCmp "$2" $R2 +4 0
    StrCmp "$2$\r$\n" "$R2" +4 0
;not found yet
    Filewrite $R1 $R2
    GOTO -5
;add a line
    Filewrite $R1 $R2
    Filewrite $R1 "$1$\r$\n"
    GOTO -8
    Filewrite $R1 $R2
    Filewrite $R1 "$1$\r$\n"
    GOTO -11
;done
    FileClose $R0
    FileClose $R1
  ;use the temp to replace the original file
  Delete "$0"
  CopyFiles temp.ini "$0"
  Delete "$OUTDIR\temp.ini"

  POP $R2  ;restore
  POP $R1  ;restore
  POP $R0  ;restore
  POP $0
  POP $1
  POP $2


SectionEnd


SectionGroupEnd

## Section Group 2
SectionGroup /e "CLIENT" PROG2

Section "Client" SEC3
 SetOutPath "$INSTDIR\client"
  SetOverwrite ifnewer
  File "C:\Users\Administrador\Desktop\Maven\server\part3-0.0.1-SNAPSHOT.jar"
  CreateDirectory "$SMPROGRAMS\testeMaven\client"
  CreateShortCut "$SMPROGRAMS\testeMaven\testeMaven.lnk" "$INSTDIR\instalador.exe"  "" "${NSISDIR}\Contrib\Graphics\Icons\llama-blue.ico"
  CreateShortCut "$DESKTOP\testeMaven.lnk" "$INSTDIR\instalador.exe" "" "${NSISDIR}\Contrib\Graphics\Icons\llama-blue.ico"

;messagebox mb_ok "Instalando as funções da sessão 3"

SectionEnd

Section "Instructions" SEC4

;messagebox mb_ok "Instalando as funções da sessão 4"

SectionEnd

SectionGroupEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\testeMaven\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\testeMaven.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\AppMainExe.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

##===========================================================================
## Settings
##===========================================================================
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC1} "Instalar as pastas referentes ao servidor"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC3} "Instalar as pastas referentes ao cliente"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

!define PROG1_InstDir    "C:\server"
!define PROG1_StartIndex ${PROG1}
!define PROG1_EndIndex   ${SEC2}

!define PROG2_InstDir "C:\client"
!define PROG2_StartIndex ${PROG2}
!define PROG2_EndIndex   ${SEC4}

###############################################################
###############################################################

## Cria $PLUGINSDIR
Function .onInit
 InitPluginsDir
FunctionEnd

## Tratamento de erros
Var IfBack
Function SelectFilesCheck
 StrCmp $IfBack 1 0 NoCheck
  Call ResetFiles
 NoCheck:
FunctionEnd

## Verificar se selecionou alguma seção!
Function ComponentsLeave
Push $R0
Push $R1

 Call IsPROG1Selected
  Pop $R0
 Call IsPROG2Selected
  Pop $R1
 StrCmp $R0 1 End
 StrCmp $R1 1 End
  Pop $R1
  Pop $R0
 MessageBox MB_OK|MB_ICONEXCLAMATION "$(NoSectionsSelected)"
 Abort

End:
Pop $R1
Pop $R0
FunctionEnd

Function IsPROG1Selected
Push $R0
Push $R1

 StrCpy $R0 ${PROG1_StartIndex} # Group 1 começa

  Loop:
   IntOp $R0 $R0 + 1
   SectionGetFlags $R0 $R1			# Get section flags
    IntOp $R1 $R1 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} 0 +3		# If section is selected, done
     StrCpy $R0 1
     Goto Done
    StrCmp $R0 ${PROG1_EndIndex} 0 Loop

 Done:
Pop $R1
Exch $R0
FunctionEnd

Function IsPROG2Selected
Push $R0
Push $R1

 StrCpy $R0 ${PROG2_StartIndex}    # Group 2 começa

  Loop:
   IntOp $R0 $R0 + 1
   SectionGetFlags $R0 $R1			# Get section flags
    IntOp $R1 $R1 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} 0 +3		# If section is selected, done
     StrCpy $R0 1
     Goto Done
    StrCmp $R0 ${PROG2_EndIndex} 0 Loop

 Done:
Pop $R1
Exch $R0
FunctionEnd

## selecionando a primeira secao para instalar

Function SelectFilesA

 # If user clicks Back now, we will know to reselect Group 2's sections
 # pagina de componentes
 StrCpy $IfBack 1

 # salvar o estado das seções do grupo 2 para proxima pagina de instalação

Push $R0
Push $R1

 StrCpy $R0 ${PROG2_StartIndex} # Group 2 começa

  Loop:
   IntOp $R0 $R0 + 1
   SectionGetFlags $R0 $R1				    # Get section flags
    WriteINIStr "$PLUGINSDIR\sections.ini" Sections $R0 $R1 # Save state
    !insertmacro UnselectSection $R0			    # Then unselect it
    StrCmp $R0 ${PROG2_EndIndex} 0 Loop

 # nao instalar prog 1?
 Call IsPROG1Selected
 Pop $R0
 StrCmp $R0 1 +4
  Pop $R1
  Pop $R0
  Abort

 # define o atual $INSTDIR para PROG1_InstDir
 StrCpy $INSTDIR "${PROG1_InstDir}"

Pop $R1
Pop $R0
FunctionEnd

## Aqui vamos deselecionar as seções do Group 1

Function SelectFilesB
Push $R0
Push $R1

 StrCpy $R0 ${PROG1_StartIndex}    # Group 1 começa

  Loop:
   IntOp $R0 $R0 + 1
    !insertmacro UnselectSection $R0		# Unselect it
    StrCmp $R0 ${PROG1_EndIndex} 0 Loop

 Call ResetFiles

 # não instalar prog 2?
 Call IsPROG2Selected
 Pop $R0
 StrCmp $R0 1 +4
  Pop $R1
  Pop $R0
  Abort

 # define o atual $INSTDIR para PROG2_InstDir 
 StrCpy $INSTDIR "${PROG2_InstDir}"

Pop $R1
Pop $R0
FunctionEnd

## setar as sections pro padrão original

Function ResetFiles
Push $R0
Push $R1

 StrCpy $R0 ${PROG2_StartIndex}    # Group 2 start

  Loop:
   IntOp $R0 $R0 + 1
   ReadINIStr "$R1" "$PLUGINSDIR\sections.ini" Sections $R0 # Get sec flags
    SectionSetFlags $R0 $R1				  # Re-set flags for this sec
    StrCmp $R0 ${PROG2_EndIndex} 0 Loop

Pop $R1
Pop $R0
FunctionEnd

## Aqui nós estamos apagando o arquivo temp INI no final da instalação
Function DeleteSectionsINI
 FlushINI "$PLUGINSDIR\Sections.ini"
 Delete "$PLUGINSDIR\Sections.ini"
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) foi removido com sucesso do seu computador."
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Tem certeza que quer remover completamente $(^Name) e todos os seus componentes?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\server\part4-0.0.1-SNAPSHOT.jar"
  Delete "$INSTDIR\client\part3-0.0.1-SNAPSHOT.jar"

  Delete "$SMPROGRAMS\testeMaven\testeMaven.lnk"
  Delete "$SMPROGRAMS\testeMaven\Uninstall.lnk"
  Delete "$DESKTOP\testeMaven.lnk"

  RMDir "$INSTDIR\server"
  RMDir "$INSTDIR\client"
  RMDir "$SMPROGRAMS\testeMaven\server"
  RMDir "$SMPROGRAMS\testeMaven\client"
  RMDir "$SMPROGRAMS\testeMaven"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd