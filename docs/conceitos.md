# Conceitos: o que cada peca faz e como se encaixam

O objetivo é ter no bash a experiência de um zsh moderno (oh-my-zsh + Starship)
sem depender de um framework. Cada recurso vem de uma ferramenta dedicada.

## ble.sh - o coração

O ble.sh (Bash Line Editor) substitui a Readline do bash por um editor de linha
escrito em puro bash. É ele que entrega, de uma vez, o que no zsh vem de três
plugins separados:

- **Autosuggestions**: sugestão em cinza a partir do histórico (estilo fish /
  zsh-autosuggestions). Ativada com `bleopt complete_auto_complete=1`.
- **Realce de sintaxe** em tempo real (estilo zsh-syntax-highlighting): comando
  válido em uma cor, inválido em outra, strings e operadores destacados.
- **Menu de completion** navegável com as setas, filtrando enquanto digita.

Não tem pacote na maioria das distros - instala-se por git + make (ver
`scripts/instalar-blesh.sh`). Como reescreve a linha de comando, exige duas
regras de ouro no `.bashrc`:

1. Carregar no topo com `--attach=none` (carrega o motor sem assumir o terminal).
2. Chamar `ble-attach` na ÚLTIMA linha (assume o terminal só depois que todo o
   resto - prompt, fzf, aliases - já foi configurado).

Se algo rodar depois do `ble-attach`, o prompt corrompe ou os keybindings
conflitam.

## Starship - o prompt

Prompt rápido e igual entre shells. Basta `eval "$(starship init bash)"`. Quando
detecta o ble.sh (variável `BLE_VERSION`), o Starship registra seus hooks no
sistema do ble.sh automaticamente, em vez de usar o `PROMPT_COMMAND` do bash -
por isso deve vir antes do `ble-attach`, mas não exige nenhuma configuração
extra.

## fzf - busca fuzzy

Busca interativa (arquivos, histórico, cd). Sob o ble.sh, NÃO se usa o
`fzf --bash` direto: usa-se a integração "contrib" do próprio ble.sh, que liga
os atalhos sem conflito. Resulta em: `C-t` (colar caminho de arquivo), `C-r`
(histórico), `M-c` (cd para subpasta). Detalhes em `fzf-e-blesh.md`.

## atuin - histórico melhor

Guarda o histórico em um banco SQLite, com busca rica e sincronização opcional
(criptografada) entre máquinas. Assume o `C-r`. Com o ble.sh, registra os hooks
corretamente; sem ele, depende do bash-preexec (que tem limitações). Como o
`C-r` também é reivindicado pelo fzf, há uma ordem de carga a respeitar - ver
`fzf-e-blesh.md`.

## zoxide - cd inteligente

Aprende os diretórios que você mais visita e permite saltar por fragmento do
nome (equivalente ao z / autojump). Neste projeto usamos `--cmd j` (comandos `j`
e `ji`) para não colidir com um eventual alias `z`.

## eza, bat, fd - substitutos modernos

- **eza**: `ls` moderno (cores, ícones, integração git).
- **bat**: `cat` com realce de sintaxe; também serve de pager colorido para o
  `man` (via `MANPAGER`).
- **fd**: alternativa mais simples e rápida ao `find`.

Todos entram como aliases/variáveis opcionais, protegidos por `command -v`.

## Por que não oh-my-bash

O oh-my-bash imita o oh-my-zsh, mas é um framework mais pesado e menos ativo. As
duas features que fazem diferença - autosuggestions e realce de sintaxe - o
ble.sh entrega de forma tecnicamente superior. O resto é melhor resolvido por
ferramentas dedicadas. O resultado é um `.bashrc` que você entende linha a
linha, sem camadas de abstração.
