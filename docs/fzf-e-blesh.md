# fzf + ble.sh (e o conflito de C-r com o atuin)

## Use a integracao do ble.sh, nao o fzf direto

Sem ble.sh, ativa-se o fzf com `eval "$(fzf --bash)"` (ou sourceando os scripts
do fzf). COM ble.sh, isso conflita: o ble.sh gerencia os keymaps, e os binds do
fzf via Readline nao se encaixam. A forma correta e a integracao "contrib" que
acompanha o ble.sh:

```bash
# no ~/.bashrc, depois do source do ble.sh com --attach=none
_ble_contrib_fzf_base=/usr/share/fzf/shell   # caminho dos scripts do fzf na sua distro
ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings
```

O `_ble_contrib_fzf_base` deve apontar para o diretorio que contem
`key-bindings.bash` e `completion.bash` do fzf. Ele varia por sistema:

- openSUSE / Fedora: `/usr/share/fzf/shell`
- Arch: `/usr/share/fzf`
- Debian / Ubuntu: `/usr/share/doc/fzf/examples`
- macOS (Homebrew): `$(brew --prefix)/opt/fzf/shell`

Resultado: `C-t` cola caminho de arquivo, `C-r` busca no historico, `M-c` faz cd
para uma subpasta.

## Por que `-d` (delayed) e obrigatorio

O modulo de key-bindings registra os atalhos com `ble-bind -m emacs -x C-r ...`,
o que exige os keymaps do ble.sh ja prontos - e eles so' existem DEPOIS do
`ble-attach`. Se voce importar de forma sincrona (sem `-d`), no meio do
`.bashrc`, os binds se perdem silenciosamente (os widgets ate existem, mas as
teclas ficam sem efeito). Com `-d`, a carga acontece na primeira ociosidade
apos o attach, com os keymaps prontos. Sintoma classico do erro: os widgets
`fzf-file-widget`/`fzf-history-widget` existem, mas `ble-bind -d | grep fzf` nao
lista bind nenhum.

## O conflito de C-r: fzf x atuin

Tanto o fzf quanto o atuin querem o `C-r`. Quando se usa o atuin, o desejavel e
que ele fique com o `C-r` (busca de historico melhor) e o fzf mantenha apenas
`C-t` e `M-c`. Para isso o atuin precisa registrar seu bind DEPOIS do fzf.

O `eval "$(atuin init bash)"` roda no corpo do `.bashrc` (sincrono), mas o fzf
carrega via `ble-import -d` (apos o attach) - ou seja, o fzf reivindica o `C-r`
DEPOIS e ganha. Sem tratamento, o `C-r` abre o fzf, nao o atuin.

A solucao verificada e reempilhar o bind do atuin como idle-task, que roda
depois da carga do fzf. Logo apos o `atuin init`, no `.bashrc`:

```bash
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init bash)"
  if [[ -n ${BLE_VERSION-} ]]; then
    _atuin_reclaim_cr() { atuin-bind -m emacs '\C-r' atuin-search-emacs 2>/dev/null; }
    ble/util/idle.push _atuin_reclaim_cr
  fi
fi
```

A funcao `atuin-bind` continua definida apos o `init`, entao a idle-task apenas
refaz o bind do `C-r` quando o fzf ja carregou. Resultado final (confirmado):
`C-r` e a seta-cima ficam com o atuin; `C-t` e `M-c` ficam com o fzf.

Diagnostico: `ble-bind -m emacs -d | grep -iE '\bC-r\b'` mostra a quem o `C-r`
esta ligado. Se aparecer `-x C-r fzf-history-widget`, o fzf ganhou; se aparecer
`-s C-r '\C-x...'`, o atuin ganhou (e o esperado).
