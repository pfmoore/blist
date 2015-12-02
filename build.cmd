@echo off
:: To build extensions for 64 bit Python 3, we need to configure environment
:: variables to use the MSVC 2010 C++ compilers from GRMSDKX_EN_DVD.iso of:
:: MS Windows SDK for Windows 7 and .NET Framework 4
::
:: More details at:
:: https://github.com/cython/cython/wiki/64BitCythonExtensionsOnWindows

IF "%DISTUTILS_USE_SDK%"=="1" (
    ECHO Configuring environment to build with MSVC on a 64bit architecture
    ECHO Using Windows SDK 7.1
    "C:\Program Files\Microsoft SDKs\Windows\v7.1\Setup\WindowsSdkVer.exe" -q -version:v7.1
    CALL "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64 /release
    SET MSSdk=1
) ELSE (
    ECHO Using default MSVC build environment
)

echo ----------------------------------------------------------------------
set
echo ----------------------------------------------------------------------
"%PYTHON%\python.exe" -c "from distutils.msvc9compiler import MSVCCompiler; print(MSVCCompiler().find_exe('cl.exe'))"
"%PYTHON%\python.exe" -c "import os; print('DISTUTILS_USE_SDK' in os.environ and 'MSSdk' in os.environ)"
echo ----------------------------------------------------------------------

set TOX_TESTENV_PASSENV=DISTUTILS_USE_SDK MSSdk INCLUDE LIB
CALL %*
