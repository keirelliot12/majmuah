# Build APK Script for PowerShell
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   AN-NIBROS APK BUILD SCRIPT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "C:\Users\PC\StudioProjects\majmuah"
Set-Location $projectPath

Write-Host "[1/3] Membersihkan build cache..." -ForegroundColor Yellow
flutter clean
Write-Host ""

Write-Host "[2/3] Menginstall dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

Write-Host "[3/3] Building APK Release..." -ForegroundColor Yellow
Write-Host "Ini memakan waktu 5-10 menit. Harap tunggu..." -ForegroundColor Cyan
flutter build apk --release

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    Write-Host "✅ BUILD BERHASIL!" -ForegroundColor Green
    Write-Host ""
    Write-Host "File APK tersimpan di:" -ForegroundColor Green
    Write-Host "  $apkPath" -ForegroundColor White
    Write-Host ""

    $apkFile = Get-Item $apkPath
    $sizeMB = [math]::Round($apkFile.Length / 1MB, 2)

    Write-Host "Informasi File:" -ForegroundColor Cyan
    Write-Host "  Nama: $($apkFile.Name)" -ForegroundColor White
    Write-Host "  Ukuran: $sizeMB MB" -ForegroundColor White
    Write-Host "  Dibuat: $($apkFile.LastWriteTime)" -ForegroundColor White
    Write-Host ""

    Write-Host "Transfer file ini ke device Android untuk install & test." -ForegroundColor Yellow
} else {
    Write-Host "❌ BUILD GAGAL!" -ForegroundColor Red
    Write-Host "Silakan cek error di atas." -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tekan Enter untuk keluar..."
$null = Read-Host
