#!/usr/bin/env bash
# Faz backup dos dotfiles do bash antes de qualquer modificacao.
# Uso: bash scripts/backup-dotfiles.sh
set -euo pipefail

ts=$(date +%Y%m%d-%H%M%S)
dest="$HOME/.dotfiles-backup-$ts"
mkdir -p "$dest"

arquivos=(.bashrc .bash_profile .profile .inputrc .alias .bash_aliases .bash_aliases_omz)
n=0
for f in "${arquivos[@]}"; do
  if [ -e "$HOME/$f" ]; then
    cp -a "$HOME/$f" "$dest/"
    echo "backup: $f"
    n=$((n + 1))
  fi
done

echo
echo "$n arquivo(s) salvos em: $dest"
echo "Rollback: copie os arquivos de volta de '$dest' para \$HOME."
