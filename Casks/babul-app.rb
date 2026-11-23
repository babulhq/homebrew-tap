# The Babul desktop app, from its release: built files only (the source stays private).
cask "babul-app" do
  version "0.2.19"
  sha256 "45b9cf74fff85cef4d44ba8b5402ed708ed6bcffde566701aeac684d3bea15bb"

  url "https://github.com/babulhq/homebrew-tap/releases/download/app-v#{version}/Babul-#{version}-arm64.zip"
  name "Babul"
  desc "Company knowledge kept in sync for every AI tool"
  homepage "https://babul.dev/"

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Babul.app"

  # shortcut: the app is not yet signed with an Apple Developer ID, so macOS would refuse to open
  # it after download; drop this once releases are signed and notarized
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Babul.app"]
  end

  zap trash: [
    "~/Library/Application Support/dev.babul.desktop",
    "~/Library/WebKit/dev.babul.desktop",
  ]

  caveats <<~EOS
    Babul runs its tasks with Claude Code on this Mac:
      brew install --cask claude-code
  EOS
end
