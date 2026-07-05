# Como contribuir

Obrigado pelo interesse no **bash-moderno**. Este é um projeto de **documentação
e ferramental leve** (guias, exemplos e scripts pequenos), não um software. As
contribuições mais valiosas são correções, esclarecimentos e guias para sistemas
que ainda não foram testados.

## Antes de abrir um PR

- Para dúvidas, erros ou sugestões, abra uma **issue** descrevendo o caso.
- Para mudanças de conteúdo, abra um **pull request** (veja o fluxo abaixo).

## Fluxo de pull request

A branch `main` é protegida: recebe alterações apenas via PR aprovado. Qualquer
pessoa pode abrir um PR a partir de um fork.

1. Faça um **fork** do repositório.
2. Crie uma **branch** a partir da `main` (ex.: `docs/ajuste-macos`).
3. Faça os commits com a mudança.
4. Abra o **PR** apontando para a `main` deste repositório.
5. O mantenedor revisa; após a aprovação, o merge é feito.

Apenas o mantenedor tem permissão de aprovar e fazer o merge na `main`.

## Padrões do projeto

- **Idioma**: português do Brasil na prosa (títulos, textos, comentários).
- **Acentuação**: acentue corretamente todas as palavras. Nada de "nao",
  "funcao" ou "versao" sem acento.
- **Charset**: apenas ASCII e letras acentuadas do português. Sem emojis, sem
  ícones, sem setas Unicode (use `->`, `<-`), sem travessão longo (use `-`) e
  sem aspas tipográficas (use `"` e `'` retos).
- **Termos técnicos** em inglês (ble.sh, fzf, prompt, shell, etc.) permanecem na
  forma original; não force traduções.
- **Mensagens de commit**: estilo conventional em português, sem escopo entre
  parênteses (ex.: `docs: corrigir caminho do fzf no Fedora`).

## Conteúdo por plataforma

O único sistema validado na prática é o openSUSE (ver `docs/opensuse.md`). Guias
para outras plataformas (Debian/Ubuntu, Fedora, Arch, macOS, Windows) são muito
bem-vindos, mas deixe claro no texto e em `VALIDACAO.md` que **não foram
testados** pelo autor - marque-os como "documentado, não testado".

## Escopo

Mantenha o foco: documentação clara e exemplos pequenos e verificáveis. Este
repositório não pretende virar um framework ou instalador automatizado - a
proposta é justamente que cada pessoa entenda e monte o seu ambiente peça por
peça.
