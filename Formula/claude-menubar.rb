class ClaudeMenubar < Formula
  desc "macOS menu bar app showing running Claude Code chats (running/waiting/finished)"
  homepage "https://github.com/kavicka/claude-menubar"
  url "https://github.com/kavicka/claude-menubar/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "2bb532f45adaa3ab72533328006ef7175ed64313aef2e67ab0baa0bcaa37fdb6"
  license "MIT"

  # Builds from source on the user's machine (no Developer ID / notarization needed).
  # Requires Xcode Command Line Tools for `swift` (xcode-select --install).
  depends_on "jq"
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    ENV["SKIP_BUILD"] = "1"
    system "./scripts/bundle-app.sh", buildpath
    prefix.install "ClaudeMenuBar.app"
    bin.install "scripts/claude-menubar"
  end

  def caveats
    <<~EOS
      Finish setup — wires Claude Code status hooks into ~/.claude/settings.json
      (with a backup) and registers a Login Item, then starts the app:

        claude-menubar setup

      Undo any time with:  claude-menubar remove
    EOS
  end

  test do
    assert_predicate prefix/"ClaudeMenuBar.app/Contents/MacOS/ClaudeMenuBar", :exist?
  end
end
