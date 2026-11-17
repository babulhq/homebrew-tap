# Babul from its release: a built copy, never the source (the source stays private).
# Anyone can install it; jobs start on a license key once the 14-day trial ends.
class Babul < Formula
  desc "Product factory that starts from facts and earns its freedom"
  homepage "https://babul.dev"
  url "https://github.com/babulhq/homebrew-tap/releases/download/v0.1.12/babul-0.1.12.tar.gz"
  sha256 "48c11a6ad2f8bf98f30873b2092dce474c79ca86f724340647baef2bdc345496"

  depends_on "gh"
  depends_on "lychee"
  depends_on "node"
  depends_on "pnpm"

  def install
    libexec.install Dir["*"], Dir[".[!.]*"] - [".brew_home"]
    (bin/"babul").write_env_script libexec/"bin/babul", PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  def caveats
    <<~EOS
      Babul also needs Archon and Claude Code:
        brew tap coleam00/archon && brew install coleam00/archon/archon
        brew install --cask claude-code
      Then, once on this computer and again after each upgrade:
        babul setup
      It links the workflows into Archon and starts the scheduler and the app
      (http://localhost:4100) at login. Your data stays in ~/.babul.
      Jobs start once your license key is in: Settings > Plan in the app, or
        babul license <key>
    EOS
  end

  test do
    assert_equal opt_libexec.to_s, shell_output("#{bin}/babul root").strip
    assert_match "usage: babul", shell_output("#{bin}/babul 2>&1", 2)
  end
end
