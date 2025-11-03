class OmegaLang < Formula
  desc "Universal blockchain programming language - Write Once, Deploy Everywhere"
  homepage "https://github.com/Rafael2022-prog/omega-lang"
  url "https://github.com/Rafael2022-prog/omega-lang/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "2f205aa5c4f6025eff143d1c8c850194459dcf11f45deb990b26525b07e40c7c"
  license "MIT"
  version "1.2.1"

  depends_on "make" => :build
  depends_on "node" => :build

  def install
    # Build OMEGA using native .mega compiler
    system "make", "build"
    
    # Install binary
    bin.install "omega"
    
    # Install standard library
    (lib/"omega").install Dir["src/std/*"]
    
    # Install examples and documentation
    (share/"omega/examples").install Dir["examples/*"]
    (share/"doc/omega").install Dir["docs/*"]
    
    # Install configuration files
    (etc/"omega").install "omega.toml"
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