# Babul from its git tag. babulhq/babul is private for now, so Homebrew clones it over
# SSH with your own GitHub key: only people with access can install. Public: use https.
class Babul < Formula
  desc "Product factory that starts from facts and earns its freedom"
  homepage "https://babul.dev"
  url "git@github.com:babulhq/babul.git",
      using:    :git,
      tag:      "v0.1.1",
      revision: "d9f4414eebf75a7c7fd904fdec2d1908771eb8d5"
  head "git@github.com:babulhq/babul.git", branch: "main", using: :git

  depends_on "coleam00/archon/archon"
  depends_on "gh"
  depends_on "lychee"
  depends_on "node"
  depends_on "pnpm"

  def install
    # build where it will run: next build writes absolute paths into .next
    libexec.install Dir["*"], Dir[".[!.]*"] - [".git", ".brew_home"]
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
      Babul also needs Claude Code: brew install --cask claude-code
      Then, once on this computer and again after each upgrade:
        babul setup
      It links the workflows into Archon and starts the scheduler and the app
      (http://localhost:4100) at login. Your data stays in ~/.babul.
    EOS
  end

  test do
    assert_match libexec.to_s, shell_output("#{bin}/babul root")
    assert_match "usage: babul", shell_output("#{bin}/babul 2>&1", 2)
  end
end
