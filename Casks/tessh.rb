cask "tessh" do
  version "0.1.0,21"
  sha256 "f383991c85579953a3c14d0fe3e989ebf5d7af0bc4ff25ebe3ff9a49f1e2780c"

  url "https://tessh.dev/updates/mac/Tessh-#{version.csv.first}-#{version.csv.second}.dmg"
  name "Tessh"
  desc "SSH client with synced hosts, device keys and snippets"
  homepage "https://tessh.dev/"

  livecheck do
    skip "Updates itself with Sparkle; this cask follows the DMG on tessh.dev/download"
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Tessh.app"

  zap trash: [
    "~/Library/Application Support/Tessh",
    "~/Library/Caches/dev.tessh.app",
    "~/Library/HTTPStorages/dev.tessh.app",
    "~/Library/Preferences/dev.tessh.app.plist",
    "~/Library/Saved Application State/dev.tessh.app.savedState",
  ]
end
