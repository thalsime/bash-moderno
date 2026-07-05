# Instalação em outras distribuições Linux

Este guia cobre Debian/Ubuntu, Fedora e Arch Linux. É uma referência curada, ainda
não testada pelo autor nessas plataformas - o único sistema validado na prática é
openSUSE Tumbleweed/Slowroll, documentado separadamente.

## Tabela de pacotes por distribuição

| Ferramenta | Debian/Ubuntu (apt) | Fedora (dnf) | Arch (pacman/AUR) |
|---|---|---|---|
| ble.sh | sem pacote - ver abaixo | sem pacote - ver abaixo | `aur/blesh` ou manual |
| Starship | sem pacote oficial - script | `starship` | `starship` |
| fzf | `fzf` | `fzf` | `fzf` |
| atuin | sem pacote estável - script | `atuin` (Fedora 38+) | `atuin` |
| zoxide | `zoxide` (Ubuntu 22.04+) | `zoxide` | `zoxide` |
| bat | `bat` | `bat` | `bat` |
| fd | `fd-find` (binário: `fdfind`) | `fd-find` | `fd` |
| eza | sem pacote antigo - ver abaixo | `eza` (Fedora 39+) | `eza` |

## ble.sh (todas as distribuições)

O ble.sh **nunca** tem pacote nas distribuições principais. Instale sempre a partir do
código-fonte:

```bash
git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
```

O `make install` coloca os arquivos em `~/.local/share/blesh/`. A linha de ativação no
`.bashrc` é:

```bash
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none
# ... resto da configuração ...
ble-attach
```

## Starship (quando não há pacote)

No Debian/Ubuntu e em versões antigas sem pacote, use o script oficial:

```bash
curl -sS https://starship.rs/install.sh | sh
```

O binário vai para `/usr/local/bin/starship` por padrão.

## fd no Debian/Ubuntu

O pacote chama-se `fd-find` e o binário instalado é `fdfind`. Adicione um alias no
`.bashrc` para usar `fd` normalmente:

```bash
# Debian/Ubuntu: fd-find instala como fdfind
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    alias fd=fdfind
fi
```

Alternativamente, crie um link simbólico:

```bash
ln -s "$(command -v fdfind)" ~/.local/bin/fd
```

## eza no Debian/Ubuntu antigo

Em versões anteriores ao Ubuntu 23.10/Debian 13, o `eza` não está no apt. Opções:

1. Instalar via Cargo (requer `cargo`):
   ```bash
   cargo install eza
   ```

2. Baixar o binário pré-compilado do GitHub Releases:
   ```bash
   EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
     | grep '"tag_name"' | head -1 | cut -d'"' -f4)
   curl -Lo /tmp/eza.tar.gz \
     "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_x86_64-unknown-linux-musl.tar.gz"
   tar -xzf /tmp/eza.tar.gz -C ~/.local/bin/
   ```

## atuin e zoxide sem pacote

Quando não houver pacote na distribuição ou a versão for muito antiga:

```bash
# atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

Ambos instalam em `~/.cargo/bin/` ou `~/.local/bin/` dependendo da versão.

## Localização dos scripts do fzf por distribuição

O ble.sh integra com o fzf via a variável `_ble_contrib_fzf_base`, que deve apontar
para o diretório que contém os arquivos `key-bindings.bash` e `completion.bash`.

| Distribuição | Caminho dos scripts do fzf |
|---|---|
| Debian/Ubuntu | `/usr/share/doc/fzf/examples/` |
| Fedora | `/usr/share/fzf/shell/` |
| Arch | `/usr/share/fzf/` |

Configure no `.bashrc` **antes** de carregar o ble.sh ou dentro do bloco de
configuração do ble.sh:

```bash
# Detecta o diretório dos scripts do fzf automaticamente
for _fzf_dir in \
    /usr/share/doc/fzf/examples \
    /usr/share/fzf/shell \
    /usr/share/fzf; do
    if [[ -f "$_fzf_dir/key-bindings.bash" ]]; then
        _ble_contrib_fzf_base="$_fzf_dir"
        break
    fi
done
unset _fzf_dir
```

## Guardas no .bashrc de exemplo

O `.bashrc` de exemplo deste repositório usa guardas `command -v` em torno de cada
configuração:

```bash
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons=auto'
fi
```

Isso significa que peças não instaladas são simplesmente ignoradas sem causar erros.
Instale apenas o que quiser e o restante da configuração continua funcionando.
