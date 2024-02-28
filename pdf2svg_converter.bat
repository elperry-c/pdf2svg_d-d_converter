@echo off
@REM encoding Shift-JIS
setlocal

@REM Windowsのパスをwslのパスに変換する際の文字化け対策 (UTF-8へ変更)
chcp 65001


@REM ドラッグアンドドロップされたファイルの情報を取得
set filepath=%1
set dirpath=%~dp1
set filename=%~n1
set extention=%~x1

@REM main関数実行
call :MAIN
pause
goto :EOF

@REM main関数
:MAIN 
    @REM ファイルの存在チェック
    if not exist %filepath% (
        echo [ERROR] %filepath% NOT found.
        echo.
        pause
        exit /b 1
    )

    @REM 拡張子チェック
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

    @REM SVGファイル保存先ディレクトリ作成
    set outdirpath="%dirpath%\%filename%_svg"
    echo [INFO] outdirpath: %outdirpath%
    if not exist %outdirpath% (
        echo [INFO] Making an output directory...
        md %outdirpath%
    ) else (
        echo [INFO] The output directory already exists.
    )

    @REM ファイルパス変換処理
    for /f "usebackq delims=" %%a in (`wsl wslpath -a %filepath:\=/%`) do (
        set wsl_filepath=%%a
    )
    for /f "usebackq delims=" %%a in (`wsl wslpath -a %outdirpath:\=/%`) do (
        set wsl_outdirpath=%%a
    )

    @REM pdf2svgコマンド実行
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
