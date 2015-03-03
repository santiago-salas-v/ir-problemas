@echo off
for %%i in (mclmcrrt7_16.dll) do if "%%~nxi"=="mclmcrrt7_16.dll" set p=%%~p$PATH:i
if defined p (
echo %p%
) else (
echo File not found
)
@echo on