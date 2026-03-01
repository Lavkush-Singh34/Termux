#!/data/data/com.termux/files/usr/bin/bash
set -e  # Exit on error

# ─────────────────────────────────────────────
#  Termux Bootstrap Setup Script
# ─────────────────────────────────────────────

echo ">>> Requesting storage permissions..."
termux-setup-storage
echo "Grant storage permissions in the popup, then press Enter to continue."
read -r

# ─── Package Sources & Update ───────────────
echo ">>> Configuring package source..."
echo "deb https://mirrors.ravidwivedi.in/termux/termux-main stable main" \
    > "$PREFIX/etc/apt/sources.list"

echo ">>> Updating packages..."
pkg update -y && pkg upgrade -y

# ─── Install Core Packages ──────────────────
echo ">>> Installing packages..."
pkg install -y git zsh zoxide eza fzf curl

# ─── Oh My Zsh ──────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> Installing Oh My Zsh..."
    RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo ">>> Oh My Zsh already installed, skipping."
fi

# ─── Set Zsh Theme ──────────────────────────
echo ">>> Setting Zsh theme to 'gnzh'..."
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="gnzh"/' "$HOME/.zshrc"

# ─── Nerd Font (JetBrains Mono) ─────────────
echo ">>> Downloading JetBrains Mono Nerd Font..."
mkdir -p "$HOME/.termux"
curl -fLo "$HOME/.termux/font.ttf" \
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Medium/JetBrainsMonoNerdFont-Medium.ttf"

# ─── Shell Config (.zshrc additions) ────────
ZSHRC="$HOME/.zshrc"
MARKER="# termux-bootstrap-additions"

if ! grep -Fq "$MARKER" "$ZSHRC"; then
    echo ">>> Appending shell config to .zshrc..."
    cat >> "$ZSHRC" << 'EOF'

# termux-bootstrap-additions
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias la="eza -a --icons"
EOF
else
    echo ">>> Shell config already present in .zshrc, skipping."
fi

# ─── Set Zsh as Default Shell ───────────────
echo ">>> Setting Zsh as default shell..."
chsh -s zsh 2>/dev/null || \
    echo "chsh failed — run 'chsh -s zsh' manually if needed."

# ─── Reload Termux Settings ─────────────────
echo ">>> Reloading Termux font/settings..."
termux-reload-settings 2>/dev/null || true

# ─── Done ────────────────────────────────────
echo ""
echo "✓ Setup complete!"
echo "  • Close and reopen Termux to start using Zsh with all changes."
echo "  • If the font looks wrong, restart Termux or check ~/.termux/font.ttf"