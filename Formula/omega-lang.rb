class OmegaLang < Formula
  desc "Universal blockchain programming language - Write Once, Deploy Everywhere"
  homepage "https://github.com/Rafael2022-prog/omega-lang"
  url "https://github.com/Rafael2022-prog/omega-lang/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256_HASH"
  license "MIT"
  version "1.2.0"

  depends_on "rust" => :build
  depends_on "node" => :build
  depends_on "make" => :build

  def install
    # Build OMEGA compiler from source
    system "cargo", "build", "--release", "--bin", "omega"
    
    # Install main binary
    bin.install "target/release/omega"
    
    # Install standard library
    (lib/"omega").install Dir["src/std/*"]
    
    # Install examples and templates
    (share/"omega/examples").install Dir["examples/*"]
    (share/"omega/contracts").install Dir["contracts/*"]
    
    # Install documentation
    (share/"doc/omega").install "README.md"
    (share/"doc/omega").install "LANGUAGE_SPECIFICATION.md"
    (share/"doc/omega").install "COMPILER_ARCHITECTURE.md"
    (share/"doc/omega").install Dir["docs/*"]
    
    # Install man pages (if available)
    # man1.install "docs/omega.1" if File.exist?("docs/omega.1")
    
    # Create configuration directory
    (etc/"omega").mkpath
    
    # Install default configuration
    (etc/"omega").install "omega.toml" if File.exist?("omega.toml")
  end

  def post_install
    # Create user configuration directory
    (var/"omega").mkpath
    
    # Set up initial configuration if it doesn't exist
    unless (etc/"omega/omega.toml").exist?
      (etc/"omega/omega.toml").write <<~EOS
        # OMEGA Language Configuration
        [compiler]
        optimization_level = 2
        target_dir = "build"
        
        [targets]
        evm = true
        solana = true
        cosmos = false
        
        [security]
        strict_mode = true
        audit_mode = false
        
        [development]
        debug_symbols = true
        verbose_output = false
      EOS
    end
  end

  test do
    # Test basic functionality
    system "#{bin}/omega", "--version"
    
    # Test compilation of a simple contract
    (testpath/"test.omega").write <<~EOS
      blockchain SimpleTest {
          state {
              uint256 value;
          }
          
          constructor() {
              value = 42;
          }
          
          function get_value() public view returns (uint256) {
              return value;
          }
      }
    EOS
    
    # Test compilation
    system "#{bin}/omega", "build", "test.omega"
    
    # Verify output files exist
    assert_predicate testpath/"build", :exist?
  end

  def caveats
    <<~EOS
      OMEGA Language has been installed successfully!
      
      Getting Started:
        1. Initialize a new project: omega init my-project
        2. Write your smart contracts in .omega files
        3. Compile: omega build
        4. Deploy: omega deploy --target evm --network testnet
      
      Documentation:
        - Language Specification: #{share}/doc/omega/LANGUAGE_SPECIFICATION.md
        - Compiler Architecture: #{share}/doc/omega/COMPILER_ARCHITECTURE.md
        - Examples: #{share}/omega/examples/
      
      Configuration:
        - Global config: #{etc}/omega/omega.toml
        - User config: ~/.omega/config.toml
      
      For more information, visit: https://github.com/Rafael2022-prog/omega-lang
    EOS
  end
end