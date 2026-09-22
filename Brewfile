# Clone of cat(1) with syntax highlighting and Git integration
brew "bat"
# Secrets scanner; the dotfiles pre-commit hook runs it on the staged diff
brew "betterleaks"
# Toolchain of the web
brew "biome"
# Resource monitor. C++ version and continuation of bashtop and bpytop
brew "btop"
# Cloudflare Tunnel client (formerly Argo Tunnel)
brew "cloudflared"
# GNU File, Shell, and Text utilities
brew "coreutils"
# More intuitive version of du in rust
brew "dust"
# Modern, maintained replacement for ls
brew "eza"
# Simple, fast and user-friendly alternative to find
brew "fd"
# Play, record, convert, and stream select audio and video codecs
brew "ffmpeg"
# Command-line fuzzy finder written in Go
brew "fzf"
# Interact with Google Gemini AI models from the command-line
brew "gemini-cli"
# GitHub command-line tool
brew "gh"
# Syntax-highlighting pager for git and diff output
brew "git-delta"
# Git extension for versioning large files
brew "git-lfs"
# Open source programming language to build simple/reliable/efficient software
brew "go"
# Colorize logfiles and command output
brew "grc"
# GNU grep, egrep and fgrep
brew "grep"
# Mac App Store command-line interface; installs the mas entries below
brew "mas"
# Modern and intuitive terminal-based text editor
brew "micro"
# Swiss-army knife of markup format conversion
brew "pandoc"
# Send macOS User Notifications from the command-line
brew "terminal-notifier"
# Official tldr client written in Rust
brew "tlrc"
# Terminal multiplexer
brew "tmux"
# Display directories as trees (with optional color/HTML output)
brew "tree"
# Extremely fast Python package installer and resolver, written in Rust
brew "uv"
# Internet file retriever
brew "wget"
# Process YAML, JSON, XML, CSV and properties documents from the CLI
brew "yq"
# Feature-rich command-line audio/video downloader
brew "yt-dlp"
# Shell extension to navigate your filesystem faster
brew "zoxide"
# Fish-like fast/unobtrusive autosuggestions for zsh
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh
brew "zsh-syntax-highlighting"
# Customise mouse behavior
cask "linearmouse"
# Quick Look generator for Markdown files
cask "qlmarkdown"
# Quick Look plugin for plaintext files without an extension
cask "qlstephen"
# Quick Look plugin for JSON files
cask "quicklook-json"
# Store SSH keys in the Secure Enclave
cask "secretive"
# Editors, terminals and dev tools
cask "claude"
cask "docker-desktop"
cask "ghostty"
cask "iterm2"
cask "lm-studio"
cask "sublime-text"
cask "tableplus"
cask "visual-studio-code"
# Browsers
cask "brave-browser"
cask "firefox@developer-edition"
cask "google-chrome"
# Utilities
cask "alt-tab"
cask "appcleaner"
cask "devcleaner"
cask "imageoptim"
cask "maccy"
cask "rectangle"
cask "spokenly"
cask "syntax-highlight"
cask "tailscale-app"
cask "the-unarchiver"
cask "upscayl"
# Media and communication
cask "discord"
cask "google-gemini"
cask "iina"
cask "obsidian"
cask "slack"
# Mac App Store: only where no cask exists. Installs need an App Store sign-in
# with the Apple ID that owns the app.
mas "Amphetamine", id: 937984704
mas "Gapplin", id: 768053424
mas "HextEdit", id: 1557247094
mas "Keynote", id: 409183694
mas "Lightweight PDF", id: 1450640351
mas "MuteKey", id: 1509590766
mas "Numbers", id: 409203825
mas "OpenVox", id: 6758789314
mas "Pages", id: 409201541
mas "Patterns", id: 429449079
mas "Shortery", id: 1594183810
mas "StopTheScript", id: 1588394487
mas "Webp Converter", id: 1527716894
mas "Xcode", id: 497799835
npm "@steipete/summarize"
npm "corepack"

# Machine profile: Brewfile.work or Brewfile.personal, picked by
# HOMEBREW_DOTFILES_PROFILE in ~/.zshenv.local. Homebrew drops environment
# variables without the HOMEBREW_ prefix before it reads this file.
profile = ENV["HOMEBREW_DOTFILES_PROFILE"]
unless %w[work personal].include?(profile)
  abort "Set HOMEBREW_DOTFILES_PROFILE to work or personal in ~/.zshenv.local"
end
instance_eval(File.read(File.expand_path("Brewfile.#{profile}", __dir__)))

# Untracked entries for this machine only
local = File.expand_path("Brewfile.local", __dir__)
instance_eval(File.read(local)) if File.exist?(local)
