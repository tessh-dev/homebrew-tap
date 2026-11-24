cask "tessh" do
  version "1.0.1,31"
  sha256 "adbdb6d7e3adef55485f44bb1255915687882980bbc4a090004747d59431c211"

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
