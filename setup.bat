@echo off
@REM encoding Shift-JIS
setlocal

@REM Windows�̃p�X��wsl�̃p�X�ɕϊ�����ۂ̕��������΍� (UTF-8�֕ύX)
chcp 65001

@REM main�֐����s
call :MAIN
pause
goto :EOF

@REM main�֐�
:MAIN
    @REM pdf2svg��wsl�ɃC���X�g�[��
    wsl sudo apt install pdf2svg
    call :ERROR_CHECK %errorlevel%

    @REM @REM �t�H���g�ݒ�C���X�g�[��
    @REM wsl sudo apt install fontconfig
    @REM call :ERROR_CHECK %errorlevel%

    @REM @REM �t�H���g���[�J���ݒ�t�@�C���쐬
    @REM wsl bash make_localconf.sh
    @REM call :ERROR_CHECK %errorlevel%

    @REM @REM �t�H���g���[�J���ݒ�K�p
    @REM wsl fc-cache -fv
    @REM call :ERROR_CHECK %errorlevel%

    exit /b 0

    :ERROR_END
        exit /b 1

    endlocal
goto :EOF

:ERROR_CHECK
    setlocal
    if %1 neq 0 (
        echo ERROR!!!
        goto :ERROR_END
    )
    endlocal
goto :EOF

