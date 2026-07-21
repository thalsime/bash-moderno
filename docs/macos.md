# Instalação no macOS

Validado na prática em **macOS 26.5.2 (build 25F84), Mac Intel**, em 2026-07-21, com
Homebrew em `/usr/local`. Os trechos específicos de Apple Silicon (`/opt/homebrew`)
seguem marcados, mas não foram exercitados.

## Pré-requisito crítico: bash moderno

O bash que vem no macOS é a versão 3.2.57, presa por incompatibilidade de licença
(GPL v3). O ble.sh e diversas funcionalidades descritas neste repositório exigem
bash >= 4 (idealmente bash 5+).

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

O `chsh` pode responder `chsh: no changes made` e ainda assim ter funcionado (por
exemplo, se a linha já estava em `/etc/shells` de uma tentativa anterior). Confira o
resultado real em vez da mensagem:

```bash
dscl . -read /Users/"$USER" UserShell
```

### O que o bash moderno NÃO resolve

Trocar o shell de login **não** afeta scripts com shebang `#!/bin/bash`: o shebang é
caminho absoluto e o kernel o obedece, ignorando o `PATH` e o shell de login. Um script
com esse shebang continuará rodando no bash 3.2 mesmo com o bash 5 instalado e definido
como padrão.

Se você mantém scripts próprios que usam recursos de bash 4+ (`local -n`, `mapfile`,
arrays associativos), troque o shebang deles para `#!/usr/bin/env bash`, que resolve o
interpretador pelo `PATH`. É a forma portável e não muda nada no Linux, onde
`/bin/bash` já é 5.x.

## Instalação das ferramentas via Homebrew

**Não existe fórmula `blesh` no Homebrew** (verificado em 2026-07-21: `brew info blesh`
responde `No available formula with the name "blesh"`). O ble.sh precisa ser compilado
a partir do fonte também no macOS, exatamente como no Linux.

Instale primeiro o que existe como fórmula:

```bash
brew install starship fzf bat fd eza atuin zoxide
```

Atenção: o `brew install` valida **todos** os nomes antes de instalar qualquer um. Se
você incluir `blesh` na lista, o comando aborta inteiro e nada é instalado.

### ble.sh: compilação a partir do fonte

Use o script deste repositório:

```bash
bash scripts/instalar-blesh.sh
```

Ele exige `git`, `make` e **`gawk`**. O macOS traz `git` e `make` com as Command Line
Tools, mas o `awk` do sistema é o do BSD, não o GNU. Instale o `gawk` antes:

```bash
brew install gawk
```

O ble.sh é instalado no diretório do usuário, sem root:

```bash
~/.local/share/blesh/ble.sh
```

Ative no `.bashrc`:

```bash
[[ -r ~/.local/share/blesh/ble.sh ]] && source -- ~/.local/share/blesh/ble.sh --attach=none
```

### bash-completion

O macOS não traz o bash-completion do bash 5. Sem ele, o bash fica bem atrás do zsh em
completions -- que é justamente o que este repositório busca equiparar:

```bash
brew install bash-completion@2
```

Carregue no `.bashrc` (o caminho difere do `/usr/share/bash-completion/bash_completion`
usado no Linux):

```bash
[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . /usr/local/etc/profile.d/bash_completion.sh
```

Em Apple Silicon, troque `/usr/local` por `/opt/homebrew`.

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
[[ -r ~/.profile ]] && . ~/.profile
[[ -r ~/.bashrc ]] && . ~/.bashrc
```

Mantenha toda a sua configuração (incluindo o ble-attach) dentro do `~/.bashrc`. O
`.bash_profile` serve apenas como ponte.

Estrutura do `~/.bashrc` com ble.sh no macOS:

```bash
# 1. Ativa o ble.sh sem anexar ainda
[[ -r ~/.local/share/blesh/ble.sh ]] && source -- ~/.local/share/blesh/ble.sh --attach=none

# 2. bash-completion do Homebrew
[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . /usr/local/etc/profile.d/bash_completion.sh

# 3. Configuração do fzf (ver abaixo), sempre com -d (delayed)
if [[ -n ${BLE_VERSION-} && -d /usr/local/opt/fzf/shell ]]; then
  _ble_contrib_fzf_base=/usr/local/opt/fzf/shell
  ble-import -d integration/fzf-completion
  ble-import -d integration/fzf-key-bindings
fi

# 4. Aliases e demais configurações
alias ls='eza --icons=auto'
alias cat='bat --paging=never'

# 5. Starship (detecta o BLE_VERSION e se integra via blehook sozinho)
eval "$(starship init bash)"

# 6. ble-attach SEMPRE por ultimo
[[ ! ${BLE_VERSION-} ]] || ble-attach
```

Verificado nesta ordem: o Starship registra `blehook PRECMD='starship_precmd'` em vez de
disputar o `PROMPT_COMMAND` com o ble.sh.

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

## Comandos BSD que se comportam como esperado

Nem toda diferença entre macOS e Linux exige adaptação. Verificados em 2026-07-21:

- `diff --color=auto` **funciona**: o `diff` da Apple é baseado no FreeBSD e aceita a
  opção. O alias do `exemplos/bashrc.exemplo` vale sem alteração.
- `mktemp -d "/tmp/prefixo-XXXXXXXX"` **funciona** com template explícito.

## Como testar o ble.sh

O ble.sh se desliga sozinho quando não há TTY, então `bash -ic '...'` **não** serve para
testá-lo -- ele reporta ausência de `BLE_VERSION` mesmo estando bem configurado. O
`script -qec` do macOS também falha quando o processo pai não tem terminal
(`tcgetattr/ioctl: Operation not supported on socket`).

Use um pty real. Em Python, o shell grava o resultado num arquivo e a leitura acontece
fora do pty, já que o stdout vem poluído pelo redesenho da linha:

```python
import os, pty, time
pid, fd = pty.fork()
if pid == 0:
    os.environ["TERM"] = "xterm-256color"
    os.execv("/usr/local/bin/bash", ["bash", "-l"])
time.sleep(6)                                    # espera o ble-attach
os.write(fd, b'printf "BLE=%s\\n" "${BLE_VERSION:-AUSENTE}" > /tmp/ble.txt\n')
time.sleep(3)
os.write(fd, b"exit\n")
```

## iTerm2 e Terminal.app

Ambos os terminais funcionam bem com ble.sh. O iTerm2 oferece melhor suporte a cores
true color e integração com shell. Em ambos, certifique-se de que o perfil do terminal
está configurado para abrir como login shell (é o padrão) para que o `.bash_profile`
seja lido e, por consequência, o `.bashrc`.
