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

Como o fzf carrega via `ble-import -d` (apos o attach) e o `eval "$(atuin init
bash)"` roda ainda no corpo do `.bashrc`, a ordem final de quem fica com o `C-r`
depende de como o atuin registra o atalho sob o ble.sh. Se apos configurar tudo
o `C-r` ainda abrir o fzf, force o atuin a reassumir empilhando o bind como uma
tarefa ociosa posterior. Um caminho robusto e re-ligar o `C-r` ao widget do
atuin numa `blehook`/idle-task que rode depois da carga do fzf. Verifique o que
o `atuin init bash` gera no seu sistema (o nome do widget) e ajuste.

Diagnostico: `ble-bind -d | grep -iE 'C-r|atuin|fzf'` mostra a quem o `C-r` esta
ligado no momento.
