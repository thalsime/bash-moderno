# bash-moderno

Documentação e ferramental para transformar o **bash** num ambiente interativo
moderno - com a mesma experiência de um zsh turbinado por oh-my-zsh + Starship,
porém por ajustes manuais e transparentes, sem instalar um framework.

Não é um software: é um conjunto de **guias, arquivos de exemplo e scripts
auxiliares pequenos**. Você lê, entende cada peça e copia o que fizer sentido -
nada de "mágica" escondida atrás de um framework.

## Por que não oh-my-bash

O oh-my-bash resolve o problema no estilo do oh-my-zsh, mas é um framework
pesado e menos ativo. As duas features que realmente importam - autosuggestions
(sugestão em cinza estilo fish) e realce de sintaxe - são entregues de forma
mais sofisticada pelo **ble.sh**, que reescreve a linha de comando do bash em
puro bash, sem dependência de runtime. O resto (prompt, histórico, cd
inteligente, ls/cat modernos) vem de ferramentas dedicadas que você combina.

## As peças

| Papel | Ferramenta | Observação |
|---|---|---|
| Autosuggestions + realce de sintaxe + menu de completion | **ble.sh** | Substitui a Readline; cobre 3 plugins do oh-my-zsh de uma vez |
| Prompt | **Starship** | O mesmo prompt do zsh, idêntico entre shells |
| Busca fuzzy (arquivos e cd) | **fzf** | Integrado pelo contrib do ble.sh (C-t arquivos, M-c cd) |
| Histórico melhor (busca, sync opcional) | **atuin** | Assume o C-r e a seta-cima; requer ble.sh para os hooks corretos |
| cd inteligente (tipo z/autojump) | **zoxide** | Comando configurável |
| ls / cat / find modernos | **eza / bat / fd** | Aliases opcionais |
| Aliases git/git-flow/gerenciador de pacotes | portados do oh-my-zsh | Ver `docs/paridade-oh-my-zsh.md` |

## Status de validação

Ver `VALIDACAO.md` para a matriz completa.

| Sistema | Status |
|---|---|
| openSUSE Tumbleweed / Slowroll | Validado (passo a passo em `docs/opensuse.md`) |
| Outras distros Linux (Debian/Ubuntu, Fedora, Arch) | Documentado, não testado |
| macOS | Documentado, não testado |
| Windows (WSL2 / Git Bash) | Documentado, não testado |

## Índice

- `docs/conceitos.md` - o que cada peça faz e como se encaixam
- `docs/opensuse.md` - guia validado (openSUSE), passo a passo
- `docs/startup-e-pyenv.md` - a cadeia de inicialização do bash e o pyenv
- `docs/fzf-e-blesh.md` - integração fzf + ble.sh e o conflito de C-r com o atuin
- `docs/paridade-oh-my-zsh.md` - mapeamento dos plugins do oh-my-zsh
- `docs/outras-distros-linux.md`, `docs/macos.md`, `docs/windows.md`
- `docs/troubleshooting.md`
- `exemplos/` - dotfiles de referência (anonimizados)
- `scripts/` - `backup-dotfiles.sh`, `instalar-blesh.sh`

## Aviso

Mexer nos dotfiles do shell pode deixar o terminal inutilizável se algo der
errado. **Sempre faça backup antes** (há um script para isso) e teste em um
terminal novo, mantendo o atual aberto como rede de segurança.
