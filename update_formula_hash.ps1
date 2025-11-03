# Update Homebrew Formula SHA256 Hash
# This script calculates the SHA256 hash of the release archive and updates the formula

param(
    [Parameter(Mandatory=$true)]
    [string]$Version = "1.2.0",
    
    [Parameter(Mandatory=$false)]
    [string]$ArchiveUrl = "https://github.com/Rafael2022-prog/omega-lang/archive/refs/tags/v$Version.tar.gz"
)

Write-Host "🔄 Updating Homebrew Formula for OMEGA v$Version" -ForegroundColor Cyan

# Download the archive to calculate hash
$TempFile = [System.IO.Path]::GetTempFileName() + ".tar.gz"
$FormulaFile = "Formula/omega-lang.rb"

try {
    Write-Host "📥 Downloading archive from: $ArchiveUrl" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $ArchiveUrl -OutFile $TempFile -UseBasicParsing
    
    # Calculate SHA256 hash
    Write-Host "🔐 Calculating SHA256 hash..." -ForegroundColor Yellow
    $Hash = Get-FileHash -Path $TempFile -Algorithm SHA256
    $Sha256 = $Hash.Hash.ToLower()
    
    Write-Host "✅ SHA256: $Sha256" -ForegroundColor Green
    
    # Update formula file
    if (Test-Path $FormulaFile) {
        Write-Host "📝 Updating formula file..." -ForegroundColor Yellow
        
        $Content = Get-Content $FormulaFile -Raw
        $UpdatedContent = $Content -replace 'sha256 "PLACEHOLDER_SHA256_HASH"', "sha256 `"$Sha256`""
        $UpdatedContent = $UpdatedContent -replace 'version "[\d\.]+"', "version `"$Version`""
        $UpdatedContent = $UpdatedContent -replace 'url "https://github\.com/Rafael2022-prog/omega-lang/archive/refs/tags/v[\d\.]+\.tar\.gz"', "url `"$ArchiveUrl`""
        
        Set-Content -Path $FormulaFile -Value $UpdatedContent -Encoding UTF8
        
        Write-Host "✅ Formula updated successfully!" -ForegroundColor Green
        Write-Host "📋 Updated values:" -ForegroundColor Cyan
        Write-Host "   Version: $Version" -ForegroundColor White
        Write-Host "   URL: $ArchiveUrl" -ForegroundColor White
        Write-Host "   SHA256: $Sha256" -ForegroundColor White
    } else {
        Write-Host "❌ Formula file not found: $FormulaFile" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    # Clean up temp file
    if (Test-Path $TempFile) {
        Remove-Item $TempFile -Force
    }
}

Write-Host ""
Write-Host "🎉 Homebrew formula ready for v$Version!" -ForegroundColor Green
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Test the formula: brew install --build-from-source ./Formula/omega-lang.rb" -ForegroundColor White
Write-Host "   2. Commit and push to homebrew tap repository" -ForegroundColor White
Write-Host "   3. Create a pull request to homebrew-core (optional)" -ForegroundColor White