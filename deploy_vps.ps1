$server = "72.61.215.223"
$user = "root"
$remotePath = "/root/artepix-backend"

Write-Host "🚀 Memulai Deployment ke $server..."

# 1. Upload Backend
Write-Host "📦 Mengupload file backend..."
Write-Host "⚠️  Masukkan password jika diminta (@ARTEPIX2025juara@)"
scp -r "d:\Documents\ARTEPIX\ARTEPIX_APPS\ARTEPIX APPS SMART PACKAGING\backend" "${user}@${server}:/root/"

# 2. Execute Deploy Script
Write-Host "🔧 Menjalankan script deployment di VPS..."
ssh "${user}@${server}" "cd ${remotePath} && chmod +x deploy.sh && ./deploy.sh"

Write-Host "✅ Proses Deployment Selesai!"
Write-Host "🌐 API Anda seharusnya aktif di http://${server}:8000"
