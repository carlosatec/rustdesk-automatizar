@echo off
setlocal

:: Define o caminho do executável do RustDesk
echo Define o caminho do executavel do RustDesk
set "rustdeskExePath=%ProgramFiles%\Rustdesk\RustDesk.exe"

:: Define o caminho do instalador do RustDesk na rede
echo Define o caminho do instalador do RustDesk na rede
set "rustdeskInstallerPath=\\caminho para exe do Rustdesk\rustdesk-host='IP-DO-RUST',key='CHAVE-DO-RUSTDEKS'=,..exe"

:: Verifica se o executável do RustDesk existe e instala
if not exist "%rustdeskExePath%" (
    echo Instalando o RustDesk a partir do caminho de rede...

    :: Verifica se o instalador existe no caminho de rede
    if not exist "%rustdeskInstallerPath%" (
        echo Erro: Instalador do RustDesk nao encontrado no caminho de rede.
        exit /b 1
    )

    :: Instala o RustDesk silenciosamente
    start /wait "" "%rustdeskInstallerPath%" --silent-install

    :: Verifica se a instalação foi concluída com sucesso
    ping 127.0.0.1 -n 21 >nul
    if not exist "%rustdeskExePath%" (
        echo Erro: Falha na instalacao do RustDesk.
        exit /b 1
    )

    echo RustDesk instalado com sucesso.
) else (
    echo RustDesk ja esta instalado.
)

:: Define a senha permanente no RustDesk
echo Definindo senha permanente no RustDesk...
"%rustdeskExePath%" --password "SENHA-PERMANENTE"

:: Configura RustDesk para iniciar com o Windows
echo Configurando RustDesk para iniciar com o Windows...
set "startupFolderPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "shortcutPath=%startupFolderPath%\RustDesk.lnk"

:: Cria um atalho na pasta de inicializacao
if not exist "%shortcutPath%" (
    powershell.exe -Command "$wshell = New-Object -ComObject WScript.Shell; $shortcut = $wshell.CreateShortcut('%shortcutPath%'); $shortcut.TargetPath = '%rustdeskExePath%'; $shortcut.Save()"
    echo Atalho criado em %startupFolderPath%.
) else (
    echo Atalho ja existe em %startupFolderPath%.
)

endlocal
echo Script finalizado com sucesso
exit /b 0