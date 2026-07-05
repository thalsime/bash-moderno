#!/usr/bin/env bash
# Clona e instala o ble.sh em ~/.local/share/blesh (nao requer root).
# O ble.sh nao tem pacote na maioria das distros; este e o caminho padrao.
# Requisitos: git, make, gawk (GNU awk).
set -euo pipefail

for dep in git make gawk; do
  command -v "$dep" >/dev/null 2>&1 || {
    echo "erro: dependencia ausente: '$dep' (instale antes de continuar)." >&2
    exit 1
  }
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Clonando o ble.sh (branch de desenvolvimento, recomendado)..."
git clone --recursive --depth 1 --shallow-submodules \
  https://github.com/akinomyoga/ble.sh.git "$tmp/ble.sh"

echo "Compilando e instalando em ~/.local ..."
make -C "$tmp/ble.sh" install PREFIX="$HOME/.local"

echo
echo "ble.sh instalado em: $HOME/.local/share/blesh/ble.sh"
echo "Agora configure o ~/.bashrc conforme exemplos/bashrc.exemplo"
echo "(source no topo com --attach=none; ble-attach na ultima linha)."
