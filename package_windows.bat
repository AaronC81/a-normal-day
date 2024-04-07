@echo off

md "%0\..\build" 2> nul
if exist "%0\..\build\windows" del "%0\..\build\windows"
md "%0\..\build\windows"

ocra ./src/main.rb res --windows --output "%0\..\build\windows\A Normal Day in the Killer Robot Factory.exe"
