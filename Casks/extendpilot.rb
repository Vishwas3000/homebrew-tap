cask "extendpilot" do
  version "1.0"
  sha256 "8062f790285b6bb4dba0e59f004028d974adafaba5f66f0f9d71848cbadf7d92"

  url "https://extendpilot.com/ExtendPilot-#{version}.dmg"
  name "ExtendPilot"
  desc "Share or extend a display to any device on the same Wi-Fi"
  homepage "https://extendpilot.com/"

  # How Homebrew notices a new release without being told.
  #
  # There is no releases feed and no version endpoint to point at — the site is
  # a static export whose download button reads its filename from one constant
  # (web/lib/content.ts). So the filename *is* the published version, and this
  # reads it off the homepage where that button renders it. Nothing extra to
  # maintain: bump the DMG and the site advertises the new number by itself.
  #
  # `brew audit --cask --new` requires this. Without it the audit fails with
  # "Version '1.0' differs from '' retrieved by livecheck" — the empty string
  # being livecheck finding no version at all, rather than finding a wrong one.
  livecheck do
    url :homepage
    regex(/ExtendPilot[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  # Sharing needs ScreenCaptureKit, and the extended desktop needs a display
  # API that only settled in this release. A bare symbol is the *minimum*
  # release, not an exact match — an array is what pins exact versions.
  depends_on macos: :sequoia

  app "ExtendPilot.app"

  # Everything the app leaves behind, so `brew uninstall --zap` is honest.
  #
  # The Keychain service is deliberately the old bundle id: the app was renamed
  # and kept the service name, because changing it would make every existing
  # install mint a fresh trust token and forget every device the user had
  # already approved. See apple/App/Shared/Trust.swift.
  #
  # Two of these belong to the crash reporter rather than to the app, and the
  # paths were read out of its own source rather than guessed. Worth knowing
  # that the app's Application Support directory is named for the app while the
  # reporter's is named for the bundle id, so removing one does not remove the
  # other.
  #
  # Deliberately NOT listed: the reporting vendor's shared directory under
  # Application Support. The analytics database may sit there, but that
  # directory belongs to every SDK from that vendor on the machine, and a zap
  # that removes another app's data is worse than one that leaves a database
  # behind.
  #
  # This file is published in a public tap, so it names no vendor in prose —
  # though one of the paths below is self-describing and there is no honest way
  # around that: dropping it would make --zap claim a completeness it does not
  # have. The privacy policy already discloses a third-party crash reporter.
  zap delete: "~/Library/HTTPStorages/com.vishwas3000.extendpilot",
      trash:  [
        "~/Library/Application Support/com.vishwas3000.extendpilot",
        "~/Library/Application Support/ExtendPilot",
        "~/Library/Caches/com.crashlytics.data/com.vishwas3000.extendpilot",
        "~/Library/Caches/com.vishwas3000.extendpilot",
        "~/Library/Preferences/com.vishwas3000.extendpilot.plist",
        "~/Library/Saved Application State/com.vishwas3000.extendpilot.savedState",
      ]

  caveats <<~EOS
    ExtendPilot needs Screen Recording to share a screen, and macOS only
    applies that grant to a process launched after it was given — so the
    first run will ask you to quit and reopen once.

    Handing pointer control to someone else additionally needs Accessibility.
    That is asked for at the moment you first grant control, never at launch,
    and nothing is injected until you have.

    Trusted devices are remembered in the Keychain under the service
    com.vishwas3000.deskpilot (the app's former name, kept so upgrades do not
    forget who you have already approved). `brew uninstall --zap` does not
    remove Keychain items; delete them in Keychain Access if you want them gone.
  EOS
end
