# Instalação no macOS

Este guia é uma referência curada, ainda não testada pelo autor no macOS - o único
sistema validado na prática é openSUSE Tumbleweed/Slowroll, documentado separadamente.

## Pré-requisito crítico: bash moderno

O bash que vem no macOS é a versão 3.2, presa por incompatibilidade de licença (GPL v3).
O ble.sh e diversas funcionalidades descritas neste repositório exigem bash >= 4
(idealmente bash 5+).

Instale o bash moderno via Homebrew antes de qualquer outra coisa:

```bash
brew install bash
```

Após a instalação, adicione o novo bash à lista de shells válidos e mude o shell padrão:

```bash
# Apple Silicon (M1/M2/M3): Homebrew instala em /opt/homebrew
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash

# Intel: Homebrew instala em /usr/local
echo /usr/local/bin/bash | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
```

Confirme após reabrir o terminal:

```bash
bash --version   # deve mostrar 5.x
```

## Instalação das ferramentas via Homebrew

Uma vantagem do macOS é que o Homebrew tem a fórmula `blesh`, dispensando a compilação
manual necessária no Linux:

```bash
brew install blesh starship fzf atuin zoxide bat fd eza
```

O ble.sh instalado pelo Homebrew fica em:

```bash
$(brew --prefix)/share/blesh/ble.sh
```

Ative no `.bashrc` normalmente:

```bash
[[ $- == *i* ]] && source "$(brew --prefix)/share/blesh/ble.sh" --attach=none
```

## Diferença entre .bash_profile e .bashrc no macOS

No macOS, o Terminal.app abre uma **login shell** por padrão (diferente do comportamento
típico em Linux, onde terminais gráficos abrem shells interativas não-login). Isso
significa que o `.bash_profile` é lido, mas o `.bashrc` não é lido automaticamente.

No openSUSE (e em muitas distribuições Linux), o `/etc/profile` já faz a ponte e carrega
o `.bashrc`. No macOS isso não acontece por padrão.

A solução recomendada é **fazer o `.bash_profile` carregar o `.bashrc`**. Adicione ao
`~/.bash_profile`:

```bash
# macOS: bash_profile carrega bashrc (terminal de login chama bash_profile, nao bashrc)
[[ -r ~/.bashrc ]] && . ~/.bashrc
```

Mantenha toda a sua configuração (incluindo o ble-attach) dentro do `~/.bashrc`. O
`.bash_profile` serve apenas como ponte.

Estrutura do `~/.bashrc` com ble.sh no macOS:

```bash
# 1. Ativa o ble.sh sem anexar ainda
[[ $- == *i* ]] && source "$(brew --prefix)/share/blesh/ble.sh" --attach=none

# 2. Inicializa ferramentas
eval "$(starship init bash)"
eval "$(atuin init bash)"
eval "$(zoxide init bash)"

# 3. Configuração do fzf (ver abaixo)
_ble_contrib_fzf_base="$(brew --prefix)/opt/fzf/shell"
ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings

# 4. Aliases e demais configurações
alias ls='eza --icons=auto'
alias cat='bat'

# 5. ble-attach SEMPRE por ultimo
ble-attach
```

## Scripts do fzf via Homebrew

O Homebrew instala os scripts de integração do fzf em:

```bash
$(brew --prefix)/opt/fzf/shell/
```

Aponte `_ble_contrib_fzf_base` para esse diretório:

```bash
_ble_contrib_fzf_base="$(brew --prefix)/opt/fzf/shell"
```

Para detectar automaticamente (útil em dotfiles compartilhados entre macOS e Linux):

```bash
if command -v brew >/dev/null 2>&1; then
    _ble_contrib_fzf_base="$(brew --prefix)/opt/fzf/shell"
fi
```

## ITerm2 e Terminal.app

Ambos os terminais funcionam bem com ble.sh. O iTerm2 oferece melhor suporte a cores
true color e integração com shell. Em ambos, certifique-se de que o perfil do terminal
está configurado para abrir como login shell (é o padrão) para que o `.bash_profile`
seja lido e, por consequência, o `.bashrc`.
