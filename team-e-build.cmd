@REM 文字コード設定
chcp 65001 > nul

@REM 環境変数の定義
set UNITY_VERSION=2022.3.48f1
set UNITY_EDITOR_PATH=c:\Program Files\Unity\Hub\Editor\
set PROJECT_PATH=c:\Users\vantan\Desktop\TeamE
set EXPORT_PATH="G:\その他のパソコン\マイ コンピュータ\Artifacts\Team2024"
set LOG_FILE="C:\Users\vantan\Desktop\GitHubActions\UnityBuildCommands\log\TeamE.log"
set GAS_URI="https://script.google.com/macros/s/AKfycbwFE95eSPBTax07d3mrhXX1FKK8uWJnbdqLZM_8toC07dVhlV23yaAWeb8NCFeVa56Q/exec?folder=U2FsdGVkX18ZLxH8c+lDvgtWaKeBYB4Y/gYft7IOJcg1zDRQXqmq3/RHTSRQSqfRqQBZ2I52jfKeR9n1O1FxLg==&team=E"

@REM 出力フォルダを処理のたびに削除する
if exist "%PROJECT_PATH%\Build" (
	rmdir /s /q "%PROJECT_PATH%\Build"
)

@REM プロジェクト更新
cd %PROJECT_PATH%
git pull https://github.com/VGA-Team2024/TeamE.git

if not %errorlevel% == 0 (
	exit /b 1
)

@REM Unityビルドコマンドを実行する
"%UNITY_EDITOR_PATH%%UNITY_VERSION%\Editor\Unity.exe" -batchmode -quit -projectPath "%PROJECT_PATH%" -executeMethod BuildCommand.Build -logfile %LOG_FILE% -platform Windows -devmode true -outputPath "%PROJECT_PATH%\Build"

@REM ビルドエラー時にコンソールにログを表示する
if not %errorlevel% == 0 (
	type %LOG_FILE%
	exit /b 1
)

@REM ビルドファイルの圧縮してGoogleDriveへ配置
powershell -NoProfile -ExecutionPolicy Unrestricted Compress-Archive -Path "%PROJECT_PATH%\Build" -DestinationPath "TeamE.zip" -Force

if not %errorlevel% == 0 (
	exit /b 1
)

move "%PROJECT_PATH%\TeamE.zip" "%EXPORT_PATH%"

PowerShell -Command "Invoke-WebRequest -Method GET -Uri %GAS_URI%"

pause