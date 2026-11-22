cask "tessh" do
  version "1.0.0,30"
  sha256 "e4abc8f40d807fa2a70be66c0438876ac7645419d6e731712989e010f3340a8a"

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
