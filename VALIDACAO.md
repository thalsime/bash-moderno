# Matriz de validação

Este projeto é mantido como referência pessoal e pública. Nem tudo foi testado
em todas as plataformas. A tabela abaixo diz o que foi de fato exercitado.

| Sistema | ble.sh | Starship | fzf | atuin | zoxide | eza/bat/fd | Status geral |
|---|---|---|---|---|---|---|---|
| openSUSE Tumbleweed / Slowroll | sim | sim | sim | sim | sim | sim | Validado |
| Debian / Ubuntu | - | - | - | - | - | - | Documentado, não testado |
| Fedora | - | - | - | - | - | - | Documentado, não testado |
| Arch | - | - | - | - | - | - | Documentado, não testado |
| macOS (Apple Silicon / Intel) | - | - | - | - | - | - | Documentado, não testado |
| Windows (WSL2) | - | - | - | - | - | - | Documentado (segue guia da distro) |
| Windows (MSYS2 / Git Bash) | - | - | - | - | - | - | Documentado, suporte parcial |

## O que foi exercitado no openSUSE (sob terminal real / pty)

- ble.sh anexa em shell interativo e em login shell (ble-attach uma única vez,
  apesar da cadeia /etc/profile -> .bashrc + .bash_profile -> .profile).
- Starship integrado via blehook PRECMD do ble.sh (detecta BLE_VERSION sozinho).
- fzf com os binds do contrib do ble.sh: C-t (arquivos) e M-c (cd).
- atuin com o C-r e a seta-cima (reassumidos sobre o fzf via idle-task); histórico
  do bash importado com `atuin import auto`.
- zoxide ativo (comando `j`/`ji`).
- bat como `cat` interativo e como MANPAGER; fd disponível.
- Aliases portados do oh-my-zsh carregados; funções auxiliares (git_main_branch,
  git_develop_branch, git_current_branch) definidas.
- pyenv ativo no PATH em login e interativo; eza ativo.

## Verificação que depende de olho humano

- autosuggestions (sugestão em cinza) e realce de sintaxe: conferir ao abrir um
  terminal novo (não dá para automatizar de forma confiável).
