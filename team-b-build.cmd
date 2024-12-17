@REM 文字コード設定
chcp 65001 > nul

@REM 環境変数の定義
set UNITY_VERSION=2022.3.48f1
set UNITY_EDITOR_PATH=c:\Program Files\Unity\Hub\Editor\
set PROJECT_PATH=c:\Users\vantan\Desktop\TeamB
set EXPORT_PATH="G:\その他のパソコン\マイ コンピュータ\Artifacts\Team2024\TeamB"
set LOG_FILE="C:\Users\vantan\Desktop\GitHubActions\UnityBuildCommands\log\TeamB.log"
set GAS_URI="https://script.google.com/macros/s/AKfycbz8goqh4NBZpD6v-mp4WCSoEZlPHuhOC2Yz5gq884ykcD0eP7lfBhVapedfLMUhzzAqjw/exec?folder=U2FsdGVkX1/ierC9UJRzXur8wFbb1HDCi8NrAerh06MO3ubM3FZ+HrmCKnuaCxui5VxGzucci/kr0FxqOdXzZQ==&team=B"
@REM 出力フォルダを処理のたびに削除する
if exist "%PROJECT_PATH%\Build" (
	rmdir /s /q "%PROJECT_PATH%\Build"
)

@REM プロジェクト更新
cd %PROJECT_PATH%
git pull https://github.com/VGA-Team2024/TeamB.git

if not %errorlevel% == 0 (
	exit /b 1
)

@REM Unityビルドコマンドを実行する
"%UNITY_EDITOR_PATH%%UNITY_VERSION%\Editor\Unity.exe" -batchmode -quit -team "TeamB2024" -projectPath "%PROJECT_PATH%" -executeMethod BuildCommand.Build -logfile %LOG_FILE% -platform Windows -devmode true -outputPath "%PROJECT_PATH%\Build"

@REM ビルドエラー時にコンソールにログを表示する
if not %errorlevel% == 0 (
	type %LOG_FILE%
	exit /b 1
)

@REM ビルドファイルの圧縮してGoogleDriveへ配置
powershell -NoProfile -ExecutionPolicy Unrestricted Compress-Archive -Path "%PROJECT_PATH%\Build" -DestinationPath "TeamB.zip" -Force

if not %errorlevel% == 0 (
	exit /b 1
)

move /Y "%PROJECT_PATH%\TeamB.zip" %EXPORT_PATH%
if not %errorlevel% == 0 (
	exit /b 1
)

curl %GAS_URI%

pause