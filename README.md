# Vishwas3000's Homebrew tap

This repository holds the recipes Homebrew reads to fetch and verify releases.

## JPEG AI for Apple Silicon

```sh
brew install vishwas3000/tap/jpeg-ai-apple
jpeg-ai encode input.png output.bits --preset 75
jpeg-ai decode output.bits reconstructed.png
```

This is an experimental native Core ML simple-profile codec. Its source lives
in [ai_compression](https://github.com/Vishwas3000/ai_compression).

## ExtendPilot

```sh
brew tap vishwas3000/tap
brew install --cask extendpilot
```

The first line is needed once, ever. Afterwards the short name works for
everything — `brew upgrade --cask extendpilot`, `brew uninstall --cask
extendpilot`, and so on.

## What it installs

A notarised, Developer ID signed build of [ExtendPilot](https://extendpilot.com/),
downloaded from extendpilot.com and checked against the SHA-256 recorded in the
cask. Homebrew refuses the install if the bytes do not match, which is a
stronger guarantee than HTTPS alone — TLS tells you who served a file, not that
it is the file that was built.

## Uninstalling

```sh
brew uninstall --zap --cask extendpilot
```

`--zap` also removes the preferences, caches and saved state the app leaves
behind. It does not remove Keychain items: trusted devices are remembered under
the service `com.vishwas3000.deskpilot` (the app's former name, kept so upgrades
do not forget devices you have already approved). Delete those in Keychain
Access if you want them gone.
