# A cadeia de inicializacao do bash (e onde entra o pyenv)

Entender qual arquivo o bash le em cada situacao evita o erro mais comum: o
`ble-attach` rodar duas vezes (prompt corrompido) ou os PATHs ficarem
inconsistentes.

## Quem le o que

- **Login shell** (login no console, ssh, `bash -l`): le `/etc/profile` e, do
  usuario, o PRIMEIRO que existir entre `~/.bash_profile`, `~/.bash_login`,
  `~/.profile`.
- **Shell interativo nao-login** (abrir uma aba no terminal): le `~/.bashrc`.
- **Shell nao-interativo** (script): nao le nenhum desses (usa `$BASH_ENV` se
  definido).

## O detalhe do openSUSE

No openSUSE, o `/etc/profile` termina carregando o `~/.bashrc`. Ou seja, num
login shell o `~/.bashrc` (onde esta o `ble-attach`) JA e carregado por essa via.

Consequencia: o `~/.bash_profile` NAO deve carregar o `~/.bashrc` de novo. Ele
apenas encadeia o `~/.profile`:

```bash
# ~/.bash_profile (openSUSE)
[ -f ~/.profile ] && . ~/.profile
```

E o `~/.profile` carrega o `/etc/profile` uma unica vez (guardado por
`$PROFILEREAD`), que por sua vez carrega o `~/.bashrc`. Resultado: `ble-attach`
roda exatamente uma vez.

Em sistemas que NAO carregam o `.bashrc` no login (ex.: macOS), faca o oposto: o
`~/.bash_profile` carrega o `~/.bashrc` (`[ -r ~/.bashrc ] && . ~/.bashrc`). A
regra invariante e: o `~/.bashrc` roda UMA vez por sessao e `ble-attach` e a sua
ultima linha.

## pyenv dividido em dois pontos

Para o pyenv funcionar tanto em login quanto em shells interativos sem duplicar
trabalho:

- No `~/.profile` (login, uma vez): so' o PATH, com `eval "$(pyenv init --path)"`.
  Sintaxe POSIX, porque o `~/.profile` pode ser lido por `/bin/sh`.
- No `~/.bashrc` (interativo): o restante, com `eval "$(pyenv init - bash)"` e
  `eval "$(pyenv virtualenv-init -)"`.

Assim os shims entram no PATH cedo (login) e as funcoes/completions do pyenv sao
carregadas so' onde importam (interativo). Ver `exemplos/profile-pyenv.exemplo`.
