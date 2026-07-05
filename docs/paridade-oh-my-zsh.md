# Paridade com o oh-my-zsh

O oh-my-zsh entrega valor por duas vias: (1) melhorias de interface (sugestão,
realce, busca) e (2) aliases/funções dos plugins. A tabela abaixo mostra de onde
vem cada coisa no bash moderno.

## Interface

| Recurso do oh-my-zsh | Equivalente no bash |
|---|---|
| zsh-autosuggestions | ble.sh (`bleopt complete_auto_complete=1`) |
| zsh-syntax-highlighting | ble.sh (ativo por padrão) |
| history-substring-search | ble.sh (busca por prefixo com as setas) |
| tema (ex.: robbyrussell, agnoster) | Starship |
| plugin `colored-man-pages` | `MANPAGER` com `bat`, ou variáveis `LESS_TERMCAP_*` |
| busca de histórico (C-r) | fzf e/ou atuin |
| `z` / autojump | zoxide |

## Aliases dos plugins

O arquivo `exemplos/bash_aliases_omz.exemplo` porta, para bash, os aliases dos
plugins que o autor usa no oh-my-zsh. A conversão é quase 1:1, porque a maioria
dos aliases é da forma `alias x='git ...'`, idêntica nos dois shells. O que exige
cuidado:

- **Funções auxiliares**: aliases como `gcm` (`git checkout $(git_main_branch)`)
  dependem de funções do plugin git (`git_main_branch`, `git_develop_branch`,
  `git_current_branch`). Elas foram reescritas em bash no próprio arquivo (o zsh
  usa `${ref:t}`, que em bash vira `${ref##*/}`).
- **Sintaxe só-zsh**: uns poucos aliases usam recursos que não existem em bash -
  `noglob`, `&!` (disown), `${$(cmd)#prefixo}`. Esses foram reescritos como
  função (ex.: os atalhos `*c` do git-flow que operam sobre a branch atual).
- **Colisão de nomes**: o plugin `suse` define `z='sudo zypper'`, que colide com
  o `z` do zoxide. Aqui o zoxide usa `j` e o zypper ganha um alias `zyp`, além
  dos demais (`zin`, `zup`, `zref`, ...).

## Plugins que viram ferramenta, não alias

Alguns plugins do oh-my-zsh são só conveniência de completion e não precisam de
port: o bash-completion cobre git, docker, ssh, systemd, etc. Para linguagens/
gerenciadores (node, npm, pyenv), use a inicialização própria da ferramenta no
`.bashrc` (ex.: `pyenv init - bash`), como o oh-my-zsh faz por baixo dos panos.

## Como gerar o seu

Liste os plugins do seu `~/.zshrc` (o array `plugins=(...)`) e, para cada um,
abra `~/.oh-my-zsh/plugins/<nome>/<nome>.plugin.zsh`. Os `alias` puros migram
direto; funções e sintaxe zsh precisam de adaptação. Source o resultado apenas
no `.bashrc` (no zsh os plugins nativos já cobrem tudo).
