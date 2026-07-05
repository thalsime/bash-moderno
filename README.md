# bash-moderno

Documentacao e ferramental para transformar o **bash** num ambiente interativo
moderno - com a mesma experiencia de um zsh turbinado por oh-my-zsh + Starship,
porem por ajustes manuais e transparentes, sem instalar um framework.

Nao e um software: e um conjunto de **guias, arquivos de exemplo e scripts
auxiliares pequenos**. Voce le, entende cada peca e copia o que fizer sentido -
nada de "magica" escondida atras de um framework.

## Por que nao oh-my-bash

O oh-my-bash resolve o problema no estilo do oh-my-zsh, mas e um framework
pesado e menos ativo. As duas features que realmente importam - autosuggestions
(sugestao em cinza estilo fish) e realce de sintaxe - sao entregues de forma
mais sofisticada pelo **ble.sh**, que reescreve a linha de comando do bash em
puro bash, sem dependencia de runtime. O resto (prompt, historico, cd
inteligente, ls/cat modernos) vem de ferramentas dedicadas que voce combina.

## As pecas

| Papel | Ferramenta | Observacao |
|---|---|---|
| Autosuggestions + realce de sintaxe + menu de completion | **ble.sh** | Substitui a Readline; cobre 3 plugins do oh-my-zsh de uma vez |
| Prompt | **Starship** | O mesmo prompt do zsh, identico entre shells |
| Busca fuzzy (arquivos, cd, historico) | **fzf** | Integrado pelo contrib do ble.sh (C-t, C-r, M-c) |
| Historico melhor (busca, sync opcional) | **atuin** | Assume o C-r; requer ble.sh para os hooks corretos |
| cd inteligente (tipo z/autojump) | **zoxide** | Comando configuravel |
| ls / cat / find modernos | **eza / bat / fd** | Aliases opcionais |
| Aliases git/git-flow/gerenciador de pacotes | portados do oh-my-zsh | Ver `docs/paridade-oh-my-zsh.md` |

## Status de validacao

Ver `VALIDACAO.md` para a matriz completa.

| Sistema | Status |
|---|---|
| openSUSE Tumbleweed / Slowroll | Validado (passo a passo em `docs/opensuse.md`) |
| Outras distros Linux (Debian/Ubuntu, Fedora, Arch) | Documentado, nao testado |
| macOS | Documentado, nao testado |
| Windows (WSL2 / Git Bash) | Documentado, nao testado |

## Indice

- `docs/conceitos.md` - o que cada peca faz e como se encaixam
- `docs/opensuse.md` - guia validado (openSUSE), passo a passo
- `docs/startup-e-pyenv.md` - a cadeia de inicializacao do bash e o pyenv
- `docs/fzf-e-blesh.md` - integracao fzf + ble.sh e o conflito de C-r com o atuin
- `docs/paridade-oh-my-zsh.md` - mapeamento dos plugins do oh-my-zsh
- `docs/outras-distros-linux.md`, `docs/macos.md`, `docs/windows.md`
- `docs/troubleshooting.md`
- `exemplos/` - dotfiles de referencia (anonimizados)
- `scripts/` - `backup-dotfiles.sh`, `instalar-blesh.sh`

## Aviso

Mexer nos dotfiles do shell pode deixar o terminal inutilizavel se algo der
errado. **Sempre faca backup antes** (ha um script para isso) e teste em um
terminal novo, mantendo o atual aberto como rede de seguranca.
