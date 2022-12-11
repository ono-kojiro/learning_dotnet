@ECHO OFF
@SETLOCAL ENABLEDELAYEDEXPANSION

SET PATH=%SYSTEMROOT%\System32

SET PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin;%PATH%

SET PROJECT=myproject.csproj
SET TARGETFRAMEWORKVERSION=v4.7.2
SET CONFIGURATION=Debug

IF "x%1" == "x" (
	CALL :ALL
	REM disable echo because subroutine might enable echo
	@ECHO OFF
	IF NOT !ERRORLEVEL! == 0 (
		ECHO ERROR : ALL returned !ERRORLEVEL!
		EXIT /B !ERRORLEVEL!
	)
) else (
	FOR %%i IN (%*) DO (
		CALL :_CHECK_LABEL %%i
		IF !ERRORLEVEL! == 0 (
			CALL :%%i
			REM disable echo because subroutine might enable echo
			@ECHO OFF

			IF NOT !ERRORLEVEL! == 0 (
				ECHO ERROR : %%i returned !ERRORLEVEL!
				EXIT /B !ERRORLEVEL!
			)
		) ELSE (
			ECHO ERROR : no such label, "%%i"
			EXIT /B 1
		)
		
	)
)

ENDLOCAL & SET RETVAL=%ERRORLEVEL%
@EXIT /B !RETVAL!

REM ===============================
REM === All
REM ===============================
:ALL
CALL :BUILD
GOTO :EOF

REM ===============================
REM === Version
REM ===============================
:VERSION
msbuild.exe -version
GOTO :EOF

REM ===============================
REM === Restore
REM ===============================
:RESTORE
msbuild -t:restore -p:RestorePackagesConfig=true !PROJECT!
GOTO :EOF

REM ===============================
REM === Build
REM ===============================
:BUILD
MSBuild.exe -t:Build !PROJECT! ^
    -property:Configuration=!CONFIGURATION!;TargetFrameworkVersion=!TARGETFRAMEWORKVERSION!
GOTO :EOF

REM ===============================
REM === Clean
REM ===============================
:CLEAN
MSBuild.exe -t:Clean !PROJECT!
GOTO :EOF

REM ===============================
REM === Maintainer Clean
REM ===============================
:MCLEAN
CALL :CLEAN
RMDIR /S /Q obj bin packages
GOTO :EOF

REM ===============================
REM === Test
REM ===============================
:TEST
Bin\Debug\example.exe array.json object.json
GOTO :EOF

REM ===============================
REM === _CHECK_LABEL
REM ===============================
:_CHECK_LABEL
FINDSTR /I /R /C:"^[ ]*:%1\>" "%~f0" >NUL 2>NUL
GOTO :EOF

REM ===============================
REM === END
REM ===============================
:END
GOTO :EOF
