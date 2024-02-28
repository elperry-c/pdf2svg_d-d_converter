@echo off
@REM encoding Shift-JIS
setlocal

@REM Windows�̃p�X��wsl�̃p�X�ɕϊ�����ۂ̕��������΍� (UTF-8�֕ύX)
chcp 65001


@REM �h���b�O�A���h�h���b�v���ꂽ�t�@�C���̏����擾
set filepath=%1
set dirpath=%~dp1
set filename=%~n1
set extention=%~x1

@REM main�֐����s
call :MAIN
pause
goto :EOF

@REM main�֐�
:MAIN 
    @REM �t�@�C���̑��݃`�F�b�N
    if not exist %filepath% (
        echo [ERROR] %filepath% NOT found.
        echo.
        pause
        exit /b 1
    )

    @REM �g���q�`�F�b�N
    if %extention%==.pdf (
        echo [INFO] extention OK: pdf
    ) else if %extention%==.PDF (
        echo [INFO] extention OK: PDF
    ) else (
        echo [ERROR] The extention of the file is NOT "pdf" or "PDF" 
        echo.
        pause
        exit /b 1
    )

    @REM SVG�t�@�C���ۑ���f�B���N�g���쐬
    set outdirpath="%dirpath%\%filename%_svg"
    echo [INFO] outdirpath: %outdirpath%
    if not exist %outdirpath% (
        echo [INFO] Making an output directory...
        md %outdirpath%
    ) else (
        echo [INFO] The output directory already exists.
    )

    @REM �t�@�C���p�X�ϊ�����
    for /f "usebackq delims=" %%a in (`wsl wslpath -a %filepath:\=/%`) do (
        set wsl_filepath=%%a
    )
    for /f "usebackq delims=" %%a in (`wsl wslpath -a %outdirpath:\=/%`) do (
        set wsl_outdirpath=%%a
    )

    @REM pdf2svg�R�}���h���s
    set page=1
    :PDF2SVG_LOOP
        set wsl_outpath=%wsl_outdirpath%/%page%.svg
        wsl pdf2svg %wsl_filepath% %wsl_outpath% %page%
        if %errorlevel% equ 252 (
            echo [INFO] Finish!
            exit /b 0
        )
        if %errorlevel% neq 0 (
            echo [ERROR] errrorlevel: %errrorlevel%
            exit /b 1
        )
        echo [INFO] svg_out %page%: %wsl_outpath%
        set /a page=page+1
        goto :PDF2SVG_LOOP
    endlocal
