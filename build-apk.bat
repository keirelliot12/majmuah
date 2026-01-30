@echo off
echo ========================================
echo   AN-NIBROS APK BUILD SCRIPT
echo ========================================
echo.
echo Memulai proses build APK...
echo.

cd /d C:\Users\PC\StudioProjects\majmuah

echo [1/3] Membersihkan build cache...
call flutter clean
echo.

echo [2/3] Menginstall dependencies...
call flutter pub get
echo.

echo [3/3] Building APK Release...
echo Ini memakan waktu 5-10 menit. Harap tunggu...
call flutter build apk --release

echo.
echo ========================================
if exist build\app\outputs\flutter-apk\app-release.apk (
    echo BUILD BERHASIL!
    echo.
    echo File APK tersimpan di:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    dir build\app\outputs\flutter-apk\app-release.apk
) else (
    echo BUILD GAGAL!
    echo Silakan cek error di atas.
)
echo ========================================
echo.
pause
