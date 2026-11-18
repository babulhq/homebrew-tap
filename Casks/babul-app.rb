# The Babul desktop app, from its release: built files only (the source stays private).
cask "babul-app" do
  version "0.2.0"
  sha256 "2d1f55296efb313aa0adec69c5dcb8585e00bf412ba316581d1fc9e5ab8a001c"

  url "https://github.com/babulhq/homebrew-tap/releases/download/app-v#{version}/Babul-#{version}-arm64.zip"
  name "Babul"
  desc "Company knowledge kept in sync for every AI tool"
  homepage "https://babul.dev"

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "Babul.app"

  # shortcut: the app is not yet signed with an Apple Developer ID, so macOS would refuse to open
  # it after download; drop this once releases are signed and notarized
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Babul.app"]
  end

  zap trash: [
    "~/Library/Application Support/dev.babul.desktop",
    "~/Library/WebKit/dev.babul.desktop",
  ]

  caveats <<~EOS
    Babul runs its tasks with Claude Code on this Mac:
      brew install --cask claude-code
    Your company's knowledge is kept as plain files in ~/Babul.
  EOS
end
