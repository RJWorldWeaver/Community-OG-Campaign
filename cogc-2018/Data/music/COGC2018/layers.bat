@echo off
echo.
echo.----------------------------------------------README---------------------------------------------
echo.
echo To use this script, copy it into the folder where the .ogg files for your layered song are stored.
echo ALL .ogg files in this folder will be included as a layer.
echo The order of the layers is the same as the order of the .ogg file names sorted alphabetically (A first, Z last).
echo To start the process, enter the name of the layered song below (can be anything, can't be nothing, I recommend a short letter sequence) and press enter.
echo You can delete the layers.bat file after completion (you should, in fact).
echo If you want to change the order of the files, just rename them and repeat the process. The .bat file will automatically overwrite the old layers.xml file if you enter the same name as before.
echo If you want to add/remove a layer, just add/remove an .ogg file from the folder and repeat the process.
echo.
SET /P Sngnm=Enter the name of your layered track:
if NOT "x%Sngnm: =%"=="x%Sngnm%" echo No spaces please. Will replace with underscores '_' thx & set Sngnm=%Sngnm: =_%
echo %Sngnm%

if exist %Sngnm%_layers.xml del %Sngnm%_layers.xml

>> %Sngnm%_layers.xml echo ^<?xml version="2.0" ?^>
>> %Sngnm%_layers.xml echo ^<Music version="1"^>
>> %Sngnm%_layers.xml echo ^<^!-- Created with layers.bat, ur favorite layer.xml file creation tool by MNG--^>

set layercounter=0
for %%I in (*.ogg) do Call :printpth "%%~pnxI" "%%~I" & echo.

set /a layercounter-=1
>> %Sngnm%_layers.xml echo.
>> %Sngnm%_layers.xml echo.
>> %Sngnm%_layers.xml echo 	^<Song name="%Sngnm%" type="layered"^>

for /l %%J in (0,1,%layercounter%) do CALL :prntsngrf %%J

>> %Sngnm%_layers.xml echo 	^</Song^>

echo Wow, what a success! Here's the string you need to input into the music parameter of the custom level hotspot:

for %%J in (%Sngnm%_layers.xml) do Call :settkn "%%~pnxJ"
echo It's been saved to the layers.xml file as well. If you move the layers.xml file to any other directory, the path will no longer be correct.
>> %Sngnm%_layers.xml echo ^</Music^>


pause
goto :eof







:settkn
set tkn=%1
set tkn=%tkn:\=/%

:Datalooop
	set tkn=%tkn:*/Data/="Data/%
if not x%tkn:/Data/=%==x%tkn% goto :Datalooop

>> %Sngnm%_layers.xml echo ^<^!-- Music parameter for the custom level hotspot:
>> %Sngnm%_layers.xml echo %tkn% %Sngnm%
>> %Sngnm%_layers.xml echo --^>

echo %tkn% %Sngnm%
goto :eof


:prntsngrf
set nr=%1
>> %Sngnm%_layers.xml echo 		^<SongRef name="%Sngnm%_layer_%nr%"/^>
goto :eof

rem __Function Print String formatted_____________________
rem Arguments: %1 %2
:printpth

set pth=%1
set flnm=%2

set name=%Sngnm%_layer_%layercounter%

echo layer: %layercounter% - %flnm%
set /A layercounter+=1

set pth=%pth:\=/%
if x%pth:/Data/=%==x%pth% echo %pth% & echo ERRRRRRORRRRR: Path doesn't contain /Data/, that's not gonna work. Put your music folder somewhere into your Mod directory and try again. & del %Sngnm%_layers.xml & pause & exit

:Dataloop
	set pth=%pth:*/Data/="Data/%
if not x%pth:/Data/=%==x%pth% goto :Dataloop

echo %pth%
>> %Sngnm%_layers.xml echo 	^<Song name="%name%" type="single" file_path=%pth%/^>


goto :eof


