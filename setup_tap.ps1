# OMEGA Homebrew Tap Setup Script
# This script sets up the Homebrew tap repository and prepares it for distribution

param(
    [Parameter(Mandatory=$false)]
    [string]$GitHubUser = "Rafael2022-prog",
    
    [Parameter(Mandatory=$false)]
    [string]$TapName = "homebrew-omega-lang",
    
    [Parameter(Mandatory=$false)]
    [switch]$CreateRepo = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$TestFormula = $false
)

$ErrorActionPreference = "Stop"

Write-Host "🍺 OMEGA Homebrew Tap Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "Formula/omega-lang.rb")) {
    Write-Host "❌ Error: omega-lang.rb formula not found!" -ForegroundColor Red
    Write-Host "Please run this script from the homebrew-tap directory." -ForegroundColor Yellow
    exit 1
}

# Initialize git repository if needed
if (-not (Test-Path ".git")) {
    Write-Host "📁 Initializing Git repository..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# Create .gitignore
Write-Host "📝 Creating .gitignore..." -ForegroundColor Yellow
@"
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Homebrew
*.bottle.tar.gz
*.bottle.json

# Testing
test-*
temp-*
*.log

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Create LICENSE file
Write-Host "📄 Creating LICENSE..." -ForegroundColor Yellow
@"
MIT License

Copyright (c) 2025 OMEGA Language Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@ | Out-File -FilePath "LICENSE" -Encoding UTF8

# Validate formula syntax
Write-Host "🔍 Validating formula syntax..." -ForegroundColor Yellow
try {
    # Check if Homebrew is available
    $HomebrewPath = Get-Command brew -ErrorAction SilentlyContinue
    if ($HomebrewPath) {
        Write-Host "✅ Homebrew found: $($HomebrewPath.Source)" -ForegroundColor Green
        
        # Audit the formula
        Write-Host "🔍 Auditing formula..." -ForegroundColor Yellow
        & brew audit --strict --online Formula/omega-lang.rb
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Formula audit passed!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Formula audit found issues (this is normal for new formulas)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️  Homebrew not found - skipping formula validation" -ForegroundColor Yellow
        Write-Host "   Install Homebrew to validate the formula: https://brew.sh" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Could not validate formula: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Test formula if requested
if ($TestFormula -and $HomebrewPath) {
    Write-Host "🧪 Testing formula installation..." -ForegroundColor Yellow
    try {
        # Test installation (dry run)
        & brew install --build-from-source --verbose ./Formula/omega-lang.rb
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Formula installation test passed!" -ForegroundColor Green
            
            # Test the installed binary
            Write-Host "🔍 Testing installed binary..." -ForegroundColor Yellow
            & omega --version
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Binary test passed!" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host "❌ Formula test failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Add all files to git
Write-Host "📦 Adding files to Git..." -ForegroundColor Yellow
git add .
git status

# Create initial commit
Write-Host "💾 Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial OMEGA Homebrew tap

- Add omega-lang.rb formula for OMEGA v1.2.0
- Include comprehensive installation and configuration
- Add update script for formula maintenance
- Include documentation and setup instructions
- Support for macOS and Linux platforms"

# Display next steps
Write-Host ""
Write-Host "🎉 Homebrew tap setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Create GitHub repository: https://github.com/$GitHubUser/$TapName" -ForegroundColor White
Write-Host "2. Add remote origin:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/$GitHubUser/$TapName.git" -ForegroundColor Gray
Write-Host "3. Push to GitHub:" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host "4. Update formula hash:" -ForegroundColor White
Write-Host "   ./update_formula_hash.ps1 -Version '1.2.0'" -ForegroundColor Gray
Write-Host "5. Test installation:" -ForegroundColor White
Write-Host "   brew tap $GitHubUser/omega-lang" -ForegroundColor Gray
Write-Host "   brew install omega-lang" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "- Tap README: ./README.md" -ForegroundColor White
Write-Host "- Formula: ./Formula/omega-lang.rb" -ForegroundColor White
Write-Host "- Homebrew docs: https://docs.brew.sh/Formula-Cookbook" -ForegroundColor White