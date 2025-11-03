# OMEGA Homebrew Formula Testing Script
# Comprehensive testing for the OMEGA Homebrew formula

param(
    [Parameter(Mandatory=$false)]
    [switch]$FullTest = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$CleanInstall = $false,
    
    [Parameter(Mandatory=$false)]
    [string]$TestDir = "homebrew-test-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
)

$ErrorActionPreference = "Stop"

Write-Host "🧪 OMEGA Homebrew Formula Testing" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host "🔍 Checking prerequisites..." -ForegroundColor Yellow

# Check if Homebrew is installed
$HomebrewPath = Get-Command brew -ErrorAction SilentlyContinue
if (-not $HomebrewPath) {
    Write-Host "❌ Homebrew not found!" -ForegroundColor Red
    Write-Host "Please install Homebrew first: https://brew.sh" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Homebrew found: $($HomebrewPath.Source)" -ForegroundColor Green

# Check if formula exists
if (-not (Test-Path "Formula/omega-lang.rb")) {
    Write-Host "❌ Formula not found: Formula/omega-lang.rb" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Formula found: Formula/omega-lang.rb" -ForegroundColor Green

# Create test directory
Write-Host "📁 Creating test directory: $TestDir" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $TestDir -Force | Out-Null
Set-Location $TestDir

try {
    # Test 1: Formula Syntax Validation
    Write-Host ""
    Write-Host "🔍 Test 1: Formula Syntax Validation" -ForegroundColor Cyan
    Write-Host "------------------------------------" -ForegroundColor Gray
    
    & brew audit --strict ../Formula/omega-lang.rb
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Formula syntax is valid" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Formula has audit warnings (may be acceptable)" -ForegroundColor Yellow
    }

    # Test 2: Formula Installation (Dry Run)
    Write-Host ""
    Write-Host "🔍 Test 2: Installation Dry Run" -ForegroundColor Cyan
    Write-Host "-------------------------------" -ForegroundColor Gray
    
    & brew install --build-from-source --verbose ../Formula/omega-lang.rb
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Formula installation successful" -ForegroundColor Green
        $InstallSuccess = $true
    } else {
        Write-Host "❌ Formula installation failed" -ForegroundColor Red
        $InstallSuccess = $false
    }

    if ($InstallSuccess) {
        # Test 3: Binary Functionality
        Write-Host ""
        Write-Host "🔍 Test 3: Binary Functionality" -ForegroundColor Cyan
        Write-Host "-------------------------------" -ForegroundColor Gray
        
        # Test version command
        Write-Host "Testing: omega --version" -ForegroundColor Yellow
        $VersionOutput = & omega --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Version command works: $VersionOutput" -ForegroundColor Green
        } else {
            Write-Host "❌ Version command failed: $VersionOutput" -ForegroundColor Red
        }

        # Test help command
        Write-Host "Testing: omega --help" -ForegroundColor Yellow
        & omega --help | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Help command works" -ForegroundColor Green
        } else {
            Write-Host "❌ Help command failed" -ForegroundColor Red
        }

        # Test 4: Project Creation and Compilation
        Write-Host ""
        Write-Host "🔍 Test 4: Project Creation and Compilation" -ForegroundColor Cyan
        Write-Host "-------------------------------------------" -ForegroundColor Gray
        
        # Create a test project
        Write-Host "Creating test project..." -ForegroundColor Yellow
        & omega init test-project --template basic 2>&1
        if ($LASTEXITCODE -eq 0 -and (Test-Path "test-project")) {
            Write-Host "✅ Project creation successful" -ForegroundColor Green
            
            Set-Location test-project
            
            # Test compilation
            Write-Host "Testing compilation..." -ForegroundColor Yellow
            & omega build 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Compilation successful" -ForegroundColor Green
            } else {
                Write-Host "❌ Compilation failed" -ForegroundColor Red
            }
            
            Set-Location ..
        } else {
            Write-Host "❌ Project creation failed" -ForegroundColor Red
        }

        # Test 5: Configuration Files
        Write-Host ""
        Write-Host "🔍 Test 5: Configuration Files" -ForegroundColor Cyan
        Write-Host "------------------------------" -ForegroundColor Gray
        
        $ConfigPath = "$(& brew --prefix)/etc/omega/omega.toml"
        if (Test-Path $ConfigPath) {
            Write-Host "✅ Global configuration found: $ConfigPath" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Global configuration not found: $ConfigPath" -ForegroundColor Yellow
        }

        # Test 6: Documentation Files
        Write-Host ""
        Write-Host "🔍 Test 6: Documentation Files" -ForegroundColor Cyan
        Write-Host "------------------------------" -ForegroundColor Gray
        
        $DocPath = "$(& brew --prefix)/share/doc/omega"
        if (Test-Path $DocPath) {
            Write-Host "✅ Documentation directory found: $DocPath" -ForegroundColor Green
            
            $DocFiles = @("README.md", "LANGUAGE_SPECIFICATION.md", "COMPILER_ARCHITECTURE.md")
            foreach ($DocFile in $DocFiles) {
                if (Test-Path "$DocPath/$DocFile") {
                    Write-Host "  ✅ $DocFile found" -ForegroundColor Green
                } else {
                    Write-Host "  ⚠️  $DocFile not found" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "⚠️  Documentation directory not found: $DocPath" -ForegroundColor Yellow
        }

        # Test 7: Examples and Templates
        Write-Host ""
        Write-Host "🔍 Test 7: Examples and Templates" -ForegroundColor Cyan
        Write-Host "---------------------------------" -ForegroundColor Gray
        
        $ExamplesPath = "$(& brew --prefix)/share/omega/examples"
        if (Test-Path $ExamplesPath) {
            Write-Host "✅ Examples directory found: $ExamplesPath" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Examples directory not found: $ExamplesPath" -ForegroundColor Yellow
        }

        # Test 8: Homebrew Test Suite
        Write-Host ""
        Write-Host "🔍 Test 8: Homebrew Test Suite" -ForegroundColor Cyan
        Write-Host "------------------------------" -ForegroundColor Gray
        
        & brew test omega-lang
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Homebrew test suite passed" -ForegroundColor Green
        } else {
            Write-Host "❌ Homebrew test suite failed" -ForegroundColor Red
        }
    }

    # Clean up if requested
    if ($CleanInstall) {
        Write-Host ""
        Write-Host "🧹 Cleaning up installation..." -ForegroundColor Yellow
        & brew uninstall omega-lang --force
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Cleanup successful" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Cleanup had issues" -ForegroundColor Yellow
        }
    }

} finally {
    # Return to original directory and clean up test directory
    Set-Location ..
    if (Test-Path $TestDir) {
        Remove-Item -Path $TestDir -Recurse -Force
        Write-Host "🧹 Test directory cleaned up" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "🎉 Testing completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Summary:" -ForegroundColor Cyan
Write-Host "- Formula syntax validation" -ForegroundColor White
Write-Host "- Installation testing" -ForegroundColor White
Write-Host "- Binary functionality testing" -ForegroundColor White
Write-Host "- Project creation and compilation testing" -ForegroundColor White
Write-Host "- Configuration and documentation verification" -ForegroundColor White
Write-Host "- Homebrew test suite execution" -ForegroundColor White
Write-Host ""
Write-Host "📚 Next steps:" -ForegroundColor Cyan
Write-Host "1. Review any warnings or errors above" -ForegroundColor White
Write-Host "2. Fix any issues in the formula" -ForegroundColor White
Write-Host "3. Re-run tests until all pass" -ForegroundColor White
Write-Host "4. Submit to Homebrew tap repository" -ForegroundColor White