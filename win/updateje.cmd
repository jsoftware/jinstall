@rem update the J engine
@rem run from the J install directory
@cd /d %~dp0
@bin\jconsole.exe -js "exit je_update_jpacman_ load 'pacman'"
@bin\jconsole.exe -js "exit echo JVERSION"
@pause
