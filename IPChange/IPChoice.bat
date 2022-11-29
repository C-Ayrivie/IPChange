@echo off
setlocal ENABLEDELAYEDEXPANSION

REM connection en admin
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
exit /b
)
cd /d %1

TITLE ClientTech© IPChoice by Clement.A
@echo ClientTech© IPChoice :
set parametres=parametres.IPChoice
if EXIST %parametres% ( REM Verification de la presence du fichier de parametres.
  goto parametresFichier
) else (
  goto ParametresDefaut
)

:parametresFichier
REM Recuperation des parametres du fichier "parametres.IPChoice" en ligne a ligne
for /f "skip=1 delims=" %%a in (%parametres%) do (
    set %%a)
set #1.ethernet=%#1.ethernet%

for /f "skip=2 delims=" %%a in (%parametres%) do (
    set %%a)
set #2.eadrfixe=%#2.eadrfixe%

for /f "skip=3 delims=" %%a in (%parametres%) do (
    set %%a)
set #3.emasque=%#3.emasque%

for /f "skip=4 delims=" %%a in (%parametres%) do (
    set %%a)
set #4.wifi=%#4.wifi%

for /f "skip=5 delims=" %%a in (%parametres%) do (
    set %%a)
set #5.wadrfixe=%#5.wadrfixe%

for /f "skip=6 delims=" %%a in (%parametres%) do (
    set %%a)
set #6.wmasque=%#6.wmasque%

rem Echo %#1.ethernet%
rem Echo %#2.eadrfixe%
rem Echo %#3.emasque%
rem Echo %#4.wifi%
rem Echo %#5.wadrfixe%
rem Echo %#6.wmasque%

goto CARTEchoix

:ParametresDefaut
REM Definition des parametres si aucun fichier n'est present
echo pas de fichier parametres par defaut:
set #1.ethernet="Ethernet"
set #2.eadrfixe=192.168.1.220
set #3.emasque=255.255.255.0
set #4.wifi="WI-FI"
set #5.wadrfixe=192.168.1.221
set #6.wmasque=255.255.255.0

:CARTEchoix
REM Choix de la carte
SET /P interface=Choix de la carte:   1/"%#1.ethernet%"   2/"%#4.wifi%"    3/DEFINIR IP    Tapez: (1/2/3)? :
if %interface%==1 set carte=%#1.ethernet% & set adrfixe=%#2.eadrfixe% & set masque=%#3.emasque% & goto question
if %interface%==2 set carte=%#4.wifi% & set adrfixe=%#5.wadrfixe% & set masque=%#6.wmasque% & goto question
if %interface%==3 goto DEFINIR
goto CARTEchoix

:question
REM Choix du protocole
SET /P lan=Choix adressage IP:   1/DYNAMIQUE   2/FIXE    3/QUITTER   Tapez: (1/2/3)? :
if %lan%==1 goto IPDHCP
if %lan%==2 goto IPfixe
if %lan%==3 goto Nfin
goto question

:IPfixe
REM Confirmation IP Fixe
CLS
@echo ClientTech© IPChoice :
SET /P lan=Confirmer l'adressage en IP Fixe "%adrfixe% %masque%"  Tapez: (O/N)? :
if %lan%==o goto OKFixe
if %lan%==O goto OKFixe
if %lan%==0 goto OKFixe
if %lan%==n goto Nfin
if %lan%==N goto Nfin
goto IPfixe

:OKFixe
REM Execution de la commande netsh avec les arguments passees pour l'IP Fixe
netsh interface ip set address %carte% static %adrfixe% %masque%
goto Ofin

:IPDHCP
REM Confirmation IP Dynamique
CLS
@echo ClientTech© IPChoice :
SET /P lan=Confirmer l'adressage en IP Dynamique Tapez: (O/N)? :
if %lan%==o goto OKDHCP
if %lan%==O goto OKDHCP
if %lan%==n goto Nfin
if %lan%==N goto Nfin
goto IPDHCP

:OKDHCP
REM Execution de la commande netsh avec les arguments passees pour l'IP en Dynamique
netsh interface ip set address %carte% dhcp
goto Ofin

:DEFINIR
REM Execution de la commande netsh avec les arguments passees pour l'IP en MANUEL
SET /P cartemanu=Choix de la carte:   1/"%#1.ethernet%"   2/"%#4.wifi%": (1/2)? :
if %cartemanu%==1 set carte=%#1.ethernet%
if %cartemanu%==2 set carte=%#4.wifi%
CLS
@echo Carte selectionner: %carte%

SET /P adrfixemanu=Saisir l'ip:
set adrfixe=%adrfixemanu%

SET /P masquemanu=Saisir le masque reseau:
set masque=%masquemanu%

CLS
SET /P DEFINIRFIN=Apliquer les parametres "%carte%" "%adrfixe%" "%masque%": (O/N)? :
if %DEFINIRFIN%==N goto Nfin
if %DEFINIRFIN%==n goto Nfin
netsh interface ip set address %carte% static %adrfixe% %masque%
goto Ofin

:Nfin
REM fin sans modifications
@echo Aucune modification appliquee
@echo -
@echo Allez Sylvain ne laisse pas tomber !
@echo -
SET /P lan=appuyez sur [ENTREE] pour quitter
goto fin

:Ofin
REM fin avec modifications
@echo La nouvelle configuration appliquee
@echo -
SET /P lan=appuyer sur [ENTREE] pour quitter
goto fin

:fin