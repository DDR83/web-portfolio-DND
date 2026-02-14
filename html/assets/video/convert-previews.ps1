# Script per convertire tutti i *-preview.mp4 da H.265 a H.264
cd D:\sito\web-portfolio-DND\html\assets\video

# Trova tutti i file -preview.mp4
Get-ChildItem -Filter "*-preview.mp4" | ForEach-Object {
    $previewFile = $_.Name
    $baseName = $previewFile -replace '-preview\.mp4$', ''
    
    # Cerca il file full corrispondente per usarlo come sorgente
    $fullFile = "$baseName-full.mp4"
    
    if (Test-Path $fullFile) {
        Write-Host "Convertendo $previewFile da $fullFile..." -ForegroundColor Green
        
        # Backup del vecchio preview
        Move-Item $previewFile "$previewFile.old" -Force
        
        # Genera nuovo preview con H.264
        ffmpeg -i $fullFile -ss 00:00:02 -t 00:00:10 -vcodec libx264 -crf 28 -preset fast -an -vf scale=640:-2 $previewFile -y
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "OK $previewFile convertito con successo" -ForegroundColor Cyan
            Remove-Item "$previewFile.old"
        } else {
            Write-Host "ERRORE nella conversione di $previewFile" -ForegroundColor Red
            Move-Item "$previewFile.old" $previewFile -Force
        }
    } else {
        Write-Host "ATTENZIONE File sorgente $fullFile non trovato per $previewFile" -ForegroundColor Yellow
    }
}

Write-Host "Conversione completata!" -ForegroundColor Green