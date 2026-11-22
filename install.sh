REPO_URL="https://github.com/lrnzxsa/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "=== 1. Aggiornamento sistema e installazione dipendenze base ==="
sudo pacman -Syu --noconfirm --needed git base-devel

echo "=== 2. Clonazione del Bare Repository ==="
# Clona il bare repo
git clone --bare "$REPO_URL" "$DOTFILES_DIR"

# Funzione temporanea equivalente all'alias 'dot'
function dot {
   /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" "$@"
}

# Tenta il checkout dei file. Se ci sono conflitti (es. .bashrc già esistente),
# sposta i file preesistenti in una cartella di backup.
mkdir -p "$HOME/.dotfiles-backup"
if ! dot checkout; then
    echo "Rilevati file di configurazione preesistenti. Spostamento in ~/.dotfiles-backup..."
    dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"
    dot checkout
fi

# Nasconde i file non tracciati
dot config --local status.showUntrackedFiles no

echo "=== 3. Installazione pacchetti ufficiali (pacman) ==="
if [ -f "$HOME/.pkglist/pacman.txt" ]; then
    sudo pacman -S --noconfirm --needed - < "$HOME/.pkglist/pacman.txt"
else
    echo "File pacman.txt non trovato, salto questo passaggio."
fi

echo "=== 4. Verifica e installazione AUR Helper (yay) ==="
if ! command -v yay &> /dev/null; then
    echo "Installazione di yay in corso..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

echo "=== 5. Installazione pacchetti AUR ==="
if [ -f "$HOME/.pkglist/aur.txt" ] && [ -s "$HOME/.pkglist/aur.txt" ]; then
    yay -S --noconfirm --needed - < "$HOME/.pkglist/aur.txt"
else
    echo "Nessun pacchetto AUR da installare."
fi

echo "=== Ripristino completato! Riavvia la sessione per applicare tutte le modifiche. ==="
