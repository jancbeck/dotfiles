# ~/.zshenv — sourced by every zsh (login, interactive, non-interactive, scripts).
# Keep minimal and side-effect-free: essential env only, no slow init, no output.
# Avoid ORDER-sensitive PATH entries here: macOS /etc/zprofile runs path_helper
# after this on login shells and reorders PATH, so dirs that must precede system
# binaries belong in ~/.zprofile. A no-collision dir like ~/.local/bin is fine
# here, since only its presence matters.

# SSH agent: prefer Secretive's Secure Enclave agent when present.
# Guarded so it's a no-op on machines without Secretive (keeps the default agent).
_secretive_sock="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
[[ -S $_secretive_sock ]] && export SSH_AUTH_SOCK="$_secretive_sock"
unset _secretive_sock

# ~/.local/bin: PATH-resolvable wrapper scripts (e.g. `config`) for every shell,
# including non-interactive ones. Only presence matters here, so path_helper
# reordering on login is harmless.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Vite+ bin (https://viteplus.dev) — guarded so it's safe on devices without it.
[ -r "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# Device-local env (API keys, secrets) — not tracked; see ~/.gitignore.
[ -r "$HOME/.zshenv.local" ] && . "$HOME/.zshenv.local"
