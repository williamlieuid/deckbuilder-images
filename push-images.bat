@echo off
cd /d "%~dp0"
echo Checking for new or changed files in %cd% ...
git add .

git diff --cached --quiet
if %errorlevel% equ 0 (
    echo Nothing new to push.
    pause
    exit /b 0
)

echo.
echo Files staged for push:
git diff --cached --name-only

git commit -m "Update images"
if errorlevel 1 (
    echo Commit failed - see message above.
    pause
    exit /b 1
)

echo.
echo Pushing to GitHub...
git push
if errorlevel 1 (
    echo Push failed - see message above.
    pause
    exit /b 1
)

echo.
echo Done! New files are live within a few minutes.
pause
