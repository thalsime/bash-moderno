# Paridade com o oh-my-zsh

O oh-my-zsh entrega valor por duas vias: (1) melhorias de interface (sugestao,
realce, busca) e (2) aliases/funcoes dos plugins. A tabela abaixo mostra de onde
vem cada coisa no bash moderno.

## Interface

| Recurso do oh-my-zsh | Equivalente no bash |
|---|---|
| zsh-autosuggestions | ble.sh (`bleopt complete_auto_complete=1`) |
| zsh-syntax-highlighting | ble.sh (ativo por padrao) |
| history-substring-search | ble.sh (busca por prefixo com as setas) |
| tema (ex.: robbyrussell, agnoster) | Starship |
| plugin `colored-man-pages` | `MANPAGER` com `bat`, ou variaveis `LESS_TERMCAP_*` |
| busca de historico (C-r) | fzf e/ou atuin |
| `z` / autojump | zoxide |

## Aliases dos plugins

O arquivo `exemplos/bash_aliases_omz.exemplo` porta, para bash, os aliases dos
plugins que o autor usa no oh-my-zsh. A conversao e quase 1:1, porque a maioria
dos aliases e da forma `alias x='git ...'`, identica nos dois shells. O que exige
cuidado:

- **Funcoes auxiliares**: aliases como `gcm` (`git checkout $(git_main_branch)`)
  dependem de funcoes do plugin git (`git_main_branch`, `git_develop_branch`,
  `git_current_branch`). Elas foram reescritas em bash no proprio arquivo (o zsh
  usa `${ref:t}`, que em bash vira `${ref##*/}`).
- **Sintaxe so'-zsh**: uns poucos aliases usam recursos que nao existem em bash -
  `noglob`, `&!` (disown), `${$(cmd)#prefixo}`. Esses foram reescritos como
  funcao (ex.: os atalhos `*c` do git-flow que operam sobre a branch atual).
- **Colisao de nomes**: o plugin `suse` define `z='sudo zypper'`, que colide com
  o `z` do zoxide. Aqui o zoxide usa `j` e o zypper ganha um alias `zyp`, alem
  dos demais (`zin`, `zup`, `zref`, ...).

## Plugins que viram ferramenta, nao alias

Alguns plugins do oh-my-zsh sao so' conveniencia de completion e nao precisam de
port: o bash-completion cobre git, docker, ssh, systemd, etc. Para linguagens/
gerenciadores (node, npm, pyenv), use a inicializacao propria da ferramenta no
`.bashrc` (ex.: `pyenv init - bash`), como o oh-my-zsh faz por baixo dos panos.

## Como gerar o seu

Liste os plugins do seu `~/.zshrc` (o array `plugins=(...)`) e, para cada um,
abra `~/.oh-my-zsh/plugins/<nome>/<nome>.plugin.zsh`. Os `alias` puros migram
direto; funcoes e sintaxe zsh precisam de adaptacao. Sourcele o resultado apenas
no `.bashrc` (no zsh os plugins nativos ja cobrem tudo).
