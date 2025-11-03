# 🍺 OMEGA Language Homebrew Tap

Official Homebrew tap for [OMEGA Language](https://github.com/Rafael2022-prog/omega-lang) - The universal blockchain programming language.

## 🚀 Installation

### Method 1: Direct Installation (Recommended)
```bash
# Add the tap
brew tap Rafael2022-prog/omega-lang

# Install OMEGA
brew install omega-lang
```

### Method 2: Install from URL
```bash
# Install directly from formula URL
brew install https://raw.githubusercontent.com/Rafael2022-prog/homebrew-omega-lang/main/Formula/omega-lang.rb
```

### Method 3: Build from Source
```bash
# Clone this repository
git clone https://github.com/Rafael2022-prog/homebrew-omega-lang.git
cd homebrew-omega-lang

# Install from local formula
brew install --build-from-source ./Formula/omega-lang.rb
```

## 📋 Requirements

- **macOS**: 10.15+ (Catalina or later)
- **Linux**: Ubuntu 18.04+, CentOS 7+, or equivalent
- **Dependencies**: Make (automatically installed by Homebrew). Node.js optional (for IDE/LSP). No Rust dependency.

## ✅ Verification

After installation, verify OMEGA is working:

```bash
# Check version
omega --version

# Initialize a test project
omega init test-project --template basic
cd test-project

# Build the project
omega build

# Run tests
omega test
```

## 🔧 Configuration

OMEGA configuration files are installed at:
- **Global config**: `/opt/homebrew/etc/omega/omega.toml` (Apple Silicon) or `/usr/local/etc/omega/omega.toml` (Intel)
- **User config**: `~/.omega/config.toml`

## 📚 Documentation

After installation, documentation is available at:
- **Language Specification**: `$(brew --prefix)/share/doc/omega/LANGUAGE_SPECIFICATION.md`
- **Compiler Architecture**: `$(brew --prefix)/share/doc/omega/COMPILER_ARCHITECTURE.md`
- **Examples**: `$(brew --prefix)/share/omega/examples/`

## 🛠️ Development

### Updating the Formula

1. **Update version and hash**:
   ```bash
   # Run the update script
   ./update_formula_hash.ps1 -Version "1.3.0"
   ```

2. **Test the formula**:
   ```bash
   # Test installation
   brew install --build-from-source ./Formula/omega-lang.rb
   
   # Test functionality
   brew test omega-lang
   
   # Audit the formula
   brew audit --strict omega-lang
   ```

3. **Commit and release**:
   ```bash
   git add Formula/omega-lang.rb
   git commit -m "Update OMEGA to v1.3.0"
   git push origin main
   ```

### Formula Structure

The formula includes:
- **Main binary**: `omega` compiler
- **Standard library**: Core OMEGA modules
- **Examples**: Sample contracts and projects
- **Documentation**: Complete language documentation
- **Configuration**: Default settings and templates

## 🧪 Testing

The formula includes comprehensive tests:
- Version check
- Basic compilation test
- Output verification
- Configuration validation

Run tests manually:
```bash
brew test omega-lang
```

## 🔄 Uninstallation

```bash
# Remove OMEGA
brew uninstall omega-lang

# Remove the tap (optional)
brew untap Rafael2022-prog/omega-lang
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Rafael2022-prog/omega-lang/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Rafael2022-prog/omega-lang/discussions)
- **Documentation**: [OMEGA Docs](https://github.com/Rafael2022-prog/omega-lang/wiki)

## 📄 License

This Homebrew tap is licensed under the [MIT License](LICENSE), same as OMEGA Language.

## 🙏 Contributing

Contributions are welcome! Please:
1. Fork this repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request

---

**Created for OMEGA Language v1.2.1+**

*"Bridging blockchain ecosystems, one brew at a time."* 🍺⛓️