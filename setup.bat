@echo off
@REM encoding Shift-JIS
setlocal

@REM Windowsのパスをwslのパスに変換する際の文字化け対策 (UTF-8へ変更)
chcp 65001

@REM main関数実行
call :MAIN
pause
goto :EOF

@REM main関数
:MAIN
    @REM pdf2svgをwslにインストール
    wsl sudo apt install pdf2svg
    call :ERROR_CHECK %errorlevel%

    @REM @REM フォント設定インストール
    @REM wsl sudo apt install fontconfig
    @REM call :ERROR_CHECK %errorlevel%

    @REM @REM フォントローカル設定ファイル作成
    @REM wsl bash make_localconf.sh
    @REM call :ERROR_CHECK %errorlevel%

    @REM @REM フォントローカル設定適用
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

