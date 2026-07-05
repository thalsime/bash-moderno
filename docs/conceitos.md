# Conceitos: o que cada peca faz e como se encaixam

O objetivo e ter no bash a experiencia de um zsh moderno (oh-my-zsh + Starship)
sem depender de um framework. Cada recurso vem de uma ferramenta dedicada.

## ble.sh - o coracao

O ble.sh (Bash Line Editor) substitui a Readline do bash por um editor de linha
escrito em puro bash. E ele que entrega, de uma vez, o que no zsh vem de tres
plugins separados:

- **Autosuggestions**: sugestao em cinza a partir do historico (estilo fish /
  zsh-autosuggestions). Ativada com `bleopt complete_auto_complete=1`.
- **Realce de sintaxe** em tempo real (estilo zsh-syntax-highlighting): comando
  valido em uma cor, invalido em outra, strings e operadores destacados.
- **Menu de completion** navegavel com as setas, filtrando enquanto digita.

Nao tem pacote na maioria das distros - instala-se por git + make (ver
`scripts/instalar-blesh.sh`). Como reescreve a linha de comando, exige duas
regras de ouro no `.bashrc`:

1. Carregar no topo com `--attach=none` (carrega o motor sem assumir o terminal).
2. Chamar `ble-attach` na ULTIMA linha (assume o terminal so' depois que todo o
   resto - prompt, fzf, aliases - ja foi configurado).

Se algo rodar depois do `ble-attach`, o prompt corrompe ou os keybindings
conflitam.

## Starship - o prompt

Prompt rapido e igual entre shells. Basta `eval "$(starship init bash)"`. Quando
detecta o ble.sh (variavel `BLE_VERSION`), o Starship registra seus hooks no
sistema do ble.sh automaticamente, em vez de usar o `PROMPT_COMMAND` do bash -
por isso deve vir antes do `ble-attach`, mas nao exige nenhuma configuracao
extra.

## fzf - busca fuzzy

Busca interativa (arquivos, historico, cd). Sob o ble.sh, NAO se usa o
`fzf --bash` direto: usa-se a integracao "contrib" do proprio ble.sh, que liga
os atalhos sem conflito. Resulta em: `C-t` (colar caminho de arquivo), `C-r`
(historico), `M-c` (cd para subpasta). Detalhes em `fzf-e-blesh.md`.

## atuin - historico melhor

Guarda o historico em um banco SQLite, com busca rica e sincronizacao opcional
(criptografada) entre maquinas. Assume o `C-r`. Com o ble.sh, registra os hooks
corretamente; sem ele, depende do bash-preexec (que tem limitacoes). Como o
`C-r` tambem e reivindicado pelo fzf, ha uma ordem de carga a respeitar - ver
`fzf-e-blesh.md`.

## zoxide - cd inteligente

Aprende os diretorios que voce mais visita e permite saltar por fragmento do
nome (equivalente ao z / autojump). Neste projeto usamos `--cmd j` (comandos `j`
e `ji`) para nao colidir com um eventual alias `z`.

## eza, bat, fd - substitutos modernos

- **eza**: `ls` moderno (cores, icones, integracao git).
- **bat**: `cat` com realce de sintaxe; tambem serve de pager colorido para o
  `man` (via `MANPAGER`).
- **fd**: alternativa mais simples e rapida ao `find`.

Todos entram como aliases/variaveis opcionais, protegidos por `command -v`.

## Por que nao oh-my-bash

O oh-my-bash imita o oh-my-zsh, mas e um framework mais pesado e menos ativo. As
duas features que fazem diferenca - autosuggestions e realce de sintaxe - o
ble.sh entrega de forma tecnicamente superior. O resto e melhor resolvido por
ferramentas dedicadas. O resultado e um `.bashrc` que voce entende linha a
linha, sem camadas de abstracao.
