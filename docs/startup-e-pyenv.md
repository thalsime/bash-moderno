# A cadeia de inicialização do bash (e onde entra o pyenv)

Entender qual arquivo o bash lê em cada situação evita o erro mais comum: o
`ble-attach` rodar duas vezes (prompt corrompido) ou os PATHs ficarem
inconsistentes.

## Quem lê o que

- **Login shell** (login no console, ssh, `bash -l`): lê `/etc/profile` e, do
  usuário, o PRIMEIRO que existir entre `~/.bash_profile`, `~/.bash_login`,
  `~/.profile`.
- **Shell interativo não-login** (abrir uma aba no terminal): lê `~/.bashrc`.
- **Shell não-interativo** (script): não lê nenhum desses (usa `$BASH_ENV` se
  definido).

## O detalhe do openSUSE

No openSUSE, o `/etc/profile` termina carregando o `~/.bashrc`. Ou seja, num
login shell o `~/.bashrc` (onde está o `ble-attach`) JÁ é carregado por essa via.

Consequência: o `~/.bash_profile` NÃO deve carregar o `~/.bashrc` de novo. Ele
apenas encadeia o `~/.profile`:

```bash
# ~/.bash_profile (openSUSE)
[ -f ~/.profile ] && . ~/.profile
```

E o `~/.profile` carrega o `/etc/profile` uma única vez (guardado por
`$PROFILEREAD`), que por sua vez carrega o `~/.bashrc`. Resultado: `ble-attach`
roda exatamente uma vez.

Em sistemas que NÃO carregam o `.bashrc` no login (ex.: macOS), faça o oposto: o
`~/.bash_profile` carrega o `~/.bashrc` (`[ -r ~/.bashrc ] && . ~/.bashrc`). A
regra invariante é: o `~/.bashrc` roda UMA vez por sessão e `ble-attach` é a sua
última linha.

## pyenv dividido em dois pontos

Para o pyenv funcionar tanto em login quanto em shells interativos sem duplicar
trabalho:

- No `~/.profile` (login, uma vez): só o PATH, com `eval "$(pyenv init --path)"`.
  Sintaxe POSIX, porque o `~/.profile` pode ser lido por `/bin/sh`.
- No `~/.bashrc` (interativo): o restante, com `eval "$(pyenv init - bash)"` e
  `eval "$(pyenv virtualenv-init -)"`.

Assim os shims entram no PATH cedo (login) e as funções/completions do pyenv são
carregadas só onde importam (interativo). Ver `exemplos/profile-pyenv.exemplo`.
