# Guia validado: openSUSE (Tumbleweed / Slowroll)

Passo a passo exercitado em openSUSE Tumbleweed-Slowroll, bash 5.3. E a unica
plataforma testada pelo autor. Em outras distros o roteiro e parecido, mudando o
gerenciador de pacotes e o caminho dos scripts do fzf.

Particularidade do openSUSE: o `/etc/profile` ja carrega o `~/.bashrc` em login
shells. Isso muda como estruturamos `~/.bash_profile` e `~/.profile` (abaixo).

## 0. Backup (sempre primeiro)

```bash
bash scripts/backup-dotfiles.sh
# guarda ~/.bashrc, ~/.profile, etc. em ~/.dotfiles-backup-<timestamp>/
```

## 1. Pacotes

Ja costumam estar presentes: `starship`, `fzf`, `bash-completion`, `git`,
`make`, `gawk`, `eza`. Instale os que faltarem e os extras modernos:

```bash
sudo zypper install atuin zoxide bat fd
```

## 2. ble.sh (sem pacote no openSUSE)

```bash
bash scripts/instalar-blesh.sh
# equivale a: git clone --recursive --depth 1 --shallow-submodules \
#   https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
# make -C /tmp/ble.sh install PREFIX=~/.local  -> ~/.local/share/blesh/ble.sh
```

## 3. Dotfiles

- `~/.bashrc`: use `exemplos/bashrc.exemplo` como base. No openSUSE o caminho dos
  scripts do fzf e `/usr/share/fzf/shell`, ja e o valor do exemplo.
- `~/.bash_profile`: use `exemplos/bash_profile.exemplo` na variante openSUSE (so'
  encadeia o `~/.profile`; NAO re-soura o `~/.bashrc`, senao o `ble-attach`
  rodaria duas vezes).
- `~/.profile`: acrescente o trecho do pyenv de `exemplos/profile-pyenv.exemplo`
  (pyenv "so' PATH" no login; o `init - bash` completo fica no `~/.bashrc`).
- `~/.bash_aliases_omz`: copie `exemplos/bash_aliases_omz.exemplo`.

Detalhes da cadeia de inicializacao em `startup-e-pyenv.md`.

## 4. Conflito do fzf global

O pacote do fzf no openSUSE ativa `fzf --bash` via `/etc/profile.d/fzf-bash.sh`.
Sob o ble.sh isso e inofensivo na pratica: o ble.sh substitui a Readline, entao
os binds do `fzf --bash` ficam inertes e vale a integracao do contrib do ble.sh.
Nao e preciso mexer em arquivo de sistema; se aparecer conflito de teclas, veja
`fzf-e-blesh.md`.

## 5. Testar

O ble.sh so' ativa em terminal real; `bash -ic 'comando'` o desativa. Portanto:

- Abra um terminal NOVO (mantendo o atual aberto como rede de seguranca).
- Confira: sugestao em cinza ao digitar; realce de sintaxe; TAB abre menu;
  `C-t`/`C-r`/`M-c` chamam o fzf/atuin; `j <pasta>` (zoxide); `ls` e `eza`;
  aliases git (`gst`, `glog`) e zypper respondem; o prompt Starship aparece.
- Diagnostico rapido: `echo $BLE_VERSION` (vazio = ble.sh nao anexou);
  `ble-bind -d | grep fzf` (lista os binds do fzf).

## Rollback

Copie os arquivos de `~/.dotfiles-backup-<timestamp>/` de volta para `$HOME` e,
se quiser remover o motor, apague `~/.local/share/blesh`. Como o shell padrao
continua sendo o bash, nao ha `chsh` a desfazer.
