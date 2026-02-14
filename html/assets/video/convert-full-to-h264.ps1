# Converti tutti i *-full.mp4 da H.265 a H.264
Get-ChildItem -Filter "*-full.mp4" | ForEach-Object {
    $file = $_.Name
    
    # Controlla codec
    $codec = ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 $file 2>$null
    
    if ($codec -eq "hevc") {
        Write-Host "Convertendo $file da H.265 a H.264..." -ForegroundColor Yellow
        
        $tempFile = "$file.temp.mp4"
        
        # Converti a H.264
        ffmpeg -i $file -vcodec libx264 -crf 23 -preset medium -an $tempFile -y 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            Remove-Item $file
            Rename-Item $tempFile $file
            Write-Host "OK $file convertito" -ForegroundColor Green
        } else {
            Write-Host "ERRORE su $file" -ForegroundColor Red
            if (Test-Path $tempFile) { Remove-Item $tempFile }
        }
    } else {
        Write-Host "OK $file gia H.264" -ForegroundColor Cyan
    }
}

Write-Host "Conversione completata!" -ForegroundColor Green