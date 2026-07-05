# Diagnóstico e resolução de problemas

## (a) Prompt corrompido ou atalhos de teclado estranhos

**Sintoma**: o prompt exibe sequências de escape visíveis, caracteres extras, ou
atalhos como Ctrl+A/Ctrl+E não funcionam corretamente.

**Causa mais comum**: o `ble-attach` não é a última linha do `.bashrc`, ou há código
sendo executado após ele.

```bash
# ERRADO - codigo apos ble-attach
ble-attach
export MINHA_VAR=valor   # isso causa problemas

# CORRETO - ble-attach e sempre a ultima linha
export MINHA_VAR=valor
ble-attach
```

Verifique se não há nada após o `ble-attach` no `.bashrc`, incluindo blocos
condicionais, funções ou outras inicializações.

## (b) Travar ao executar `source ~/.bashrc` em sessão ativa

**Sintoma**: o terminal trava ou exibe comportamento errático ao re-sourçar o `.bashrc`
com o Starship ativo.

**Causa**: re-inicializar o Starship (`eval "$(starship init bash)"`) numa sessão já
ativa com ble.sh pode causar conflito de hooks.

**Solução**: abra um terminal novo em vez de re-sourçar. O `.bashrc` foi projetado para
ser carregado uma vez, na inicialização da sessão.

## (c) Ctrl+R abre fzf em vez do atuin

**Sintoma**: pressionar Ctrl+R abre o fzf em vez da interface do atuin.

**Causa**: o fzf registra o Ctrl+R antes do atuin, ou o atuin não reassumiu o atalho
após a integração do fzf.

**Solução**: a ordem de inicialização importa. O atuin deve ser inicializado **depois**
da integração do fzf. Além disso, use `ble-import -d` (modo deferido) para o fzf, para
que o atuin possa sobrescrever o Ctrl+R:

```bash
# Ordem correta no .bashrc
_ble_contrib_fzf_base="/caminho/para/scripts/fzf"
ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings   # modo deferido: -d

# atuin APOS o fzf para reassumir o Ctrl+R
eval "$(atuin init bash)"
```

## (d) fzf não ativa Ctrl+T, Ctrl+R ou Alt+C

**Sintoma**: os atalhos do fzf não funcionam após a configuração.

Causa 1 - `_ble_contrib_fzf_base` apontando para diretório errado:

```bash
# Verifique se o arquivo existe no caminho configurado
ls "$_ble_contrib_fzf_base/key-bindings.bash"
```

Causa 2 - fzf carregado de forma síncrona antes do `ble-attach`. Não use
`source "$_ble_contrib_fzf_base/key-bindings.bash"` diretamente; use sempre:

```bash
ble-import -d integration/fzf-key-bindings
```

O `-d` (deferido) garante que a integração ocorra após o ble.sh estar completamente
inicializado.

## (e) ble.sh não ativa ao testar com `bash -ic`

**Sintoma**: ao testar com `bash -ic 'echo $BLE_VERSION'`, o resultado está vazio.

**Causa**: o ble.sh detecta que não está conectado a um terminal real (pty) e não se
inicializa. Esse comportamento é intencional - o ble.sh é projetado para terminais
interativos reais.

**Solução**: teste sempre em um terminal real. Para testes automatizados, use uma
biblioteca que simule um pty, como `pexpect` (Python) ou o utilitário `script`:

```bash
# Simular sessão com pty via script (Unix)
script -q -c 'bash -i' /dev/null
```

## (f) PIPESTATUS não disponível ou com valor incorreto

**Sintoma**: `$PIPESTATUS` não reflete os status corretos em pipelines sob o ble.sh.

**Causa**: o ble.sh substitui o mecanismo de controle de pipelines e usa sua própria
variável.

**Solução**: use `$BLE_PIPESTATUS` em vez de `$PIPESTATUS`:

```bash
# Em vez de:
echo $PIPESTATUS

# Use:
echo $BLE_PIPESTATUS
```

## (g) Conflito entre bash-preexec e ble.sh

**Sintoma**: hooks do atuin ou Starship disparam duas vezes, ou o histórico é
duplicado.

**Causa**: `bash-preexec` (usado por algumas configurações do atuin e do Starship) e o
ble.sh implementam mecanismos de hook incompatíveis. Usar os dois juntos duplica
os hooks `preexec` e `precmd`.

**Solução**: não carregue o `bash-preexec` quando usar ble.sh. O ble.sh já fornece
um mecanismo de hook nativo compatível com o atuin e o Starship. Remova qualquer linha
que carregue `bash-preexec.sh` do seu `.bashrc`.

## Como diagnosticar problemas gerais

Verifique se o ble.sh está ativo:

```bash
echo $BLE_VERSION   # vazio = ble.sh nao anexou; valor = versao instalada
```

Verifique os atalhos registrados pelo fzf:

```bash
ble-bind -d | grep fzf
```

Verifique se as ferramentas estão no PATH:

```bash
command -v starship
command -v atuin
command -v zoxide
command -v fzf
command -v bat
command -v fd      # ou fdfind no Debian/Ubuntu
command -v eza
```

Verifique a versão do bash (deve ser 4+ para ble.sh, recomendado 5+):

```bash
bash --version
```
