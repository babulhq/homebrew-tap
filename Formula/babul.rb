# Babul from its git tag. babulhq/babul is private for now, so Homebrew clones it over
# SSH with your own GitHub key: only people with access can install. Public: use https.
class Babul < Formula
  desc "Product factory that starts from facts and earns its freedom"
  homepage "https://babul.dev"
  url "git@github.com:babulhq/babul.git",
      using:    :git,
      tag:      "v0.1.3",
      revision: "1303f6a0bec9adb5d9fb6199757c0297f0ad1dcc"
  head "git@github.com:babulhq/babul.git", branch: "main", using: :git

  depends_on "gh"
  depends_on "lychee"
  depends_on "node"
  depends_on "pnpm"

  def install
    # build where it will run: next build writes absolute paths into .next
    libexec.install Dir["*"], Dir[".[!.]*"] - [".git", ".brew_home"]
    # a copy from Homebrew is a customer's: it starts jobs only on a valid license key
    inreplace libexec/"apps/cli/src/polar.ts", "PACKAGED = false", "PACKAGED = true"
    cd libexec do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "--filter", "web", "build"
      # the build tools (TypeScript, Biome, Vitest, Playwright) are not needed to run
      system "pnpm", "prune", "--prod"
    end
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
        babul license <your GitHub org> <key>
    EOS
  end

  test do
    assert_equal opt_libexec.to_s, shell_output("#{bin}/babul root").strip
    assert_match "usage: babul", shell_output("#{bin}/babul 2>&1", 2)
  end
end
