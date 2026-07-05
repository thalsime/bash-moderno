# Matriz de validacao

Este projeto e mantido como referencia pessoal e publica. Nem tudo foi testado
em todas as plataformas. A tabela abaixo diz o que foi de fato exercitado.

| Sistema | ble.sh | Starship | fzf | atuin | zoxide | eza/bat/fd | Status geral |
|---|---|---|---|---|---|---|---|
| openSUSE Tumbleweed / Slowroll | sim | sim | sim | pendente | pendente | eza sim | Validado (nucleo); extras em validacao |
| Debian / Ubuntu | - | - | - | - | - | - | Documentado, nao testado |
| Fedora | - | - | - | - | - | - | Documentado, nao testado |
| Arch | - | - | - | - | - | - | Documentado, nao testado |
| macOS (Apple Silicon / Intel) | - | - | - | - | - | - | Documentado, nao testado |
| Windows (WSL2) | - | - | - | - | - | - | Documentado (segue guia da distro) |
| Windows (MSYS2 / Git Bash) | - | - | - | - | - | - | Documentado, suporte parcial |

## O que "Validado (nucleo)" significa no openSUSE

Exercitado sob terminal real (pty), confirmado:

- ble.sh anexa em shell interativo e em login shell (ble-attach uma unica vez,
  apesar da cadeia /etc/profile -> .bashrc + .bash_profile -> .profile).
- Starship integrado via blehook PRECMD do ble.sh (detecta BLE_VERSION sozinho).
- fzf com os tres binds do contrib do ble.sh: C-t (arquivos), C-r (historico),
  M-c (cd).
- Aliases portados do oh-my-zsh carregados; funcoes auxiliares (git_main_branch,
  git_develop_branch, git_current_branch) definidas.
- pyenv ativo no PATH em login e interativo.
- eza ativo.

## Pendente de validacao (openSUSE)

- atuin: reassumir o C-r sobre o fzf, importacao do historico.
- zoxide: comando de salto.
- bat: como cat interativo e como MANPAGER.
- Verificacao visual de autosuggestions e realce de sintaxe (feita ao abrir um
  terminal novo).
