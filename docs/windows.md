# Instalação no Windows

Este guia é uma referência curada, ainda não testada pelo autor no Windows - o único
sistema validado na prática é openSUSE Tumbleweed/Slowroll, documentado separadamente.

## Via WSL2 (recomendado)

O WSL2 (Windows Subsystem for Linux) é a via recomendada para usar este ambiente no
Windows. Dentro do WSL2 você tem um Linux completo e pode seguir o guia da sua
distribuição normalmente:

- Ubuntu no WSL2 -> siga `outras-distros-linux.md` (seção Debian/Ubuntu)
- openSUSE no WSL2 -> siga o guia principal do repositório

Para instalar o WSL2 com Ubuntu:

```powershell
# Rodar no PowerShell como Administrador
wsl --install
```

Para instalar com openSUSE Tumbleweed:

```powershell
wsl --install -d openSUSE-Tumbleweed
```

Dentro do WSL2, todos os recursos funcionam normalmente: ble.sh, Starship, fzf, atuin,
zoxide, bat, fd, eza. O desempenho de I/O é melhor quando os arquivos ficam no sistema
de arquivos Linux (`~/` dentro do WSL), não na montagem do Windows (`/mnt/c/`).

Terminais recomendados para usar com WSL2:

- Windows Terminal (recomendado, suporta true color e ligaduras)
- VS Code com extensão "Remote - WSL"

## Via MSYS2 (nativo no Windows)

O MSYS2 é um ambiente Unix-like nativo no Windows, com gerenciador de pacotes `pacman`
(o mesmo do Arch Linux). É a melhor opção se você quiser ble.sh funcionando sem WSL2.

O ble.sh tem suporte declarado ao MSYS2, embora com possíveis diferenças de desempenho
e de integração em relação ao Linux nativo.

Instalação do MSYS2: https://www.msys2.org/

Após instalar, no terminal MSYS2:

```bash
# Atualiza o sistema base
pacman -Syu

# Instala as ferramentas disponíveis
pacman -S fzf starship zoxide bat fd

# ble.sh: sem pacote no MSYS2, instalar manualmente
git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local

# atuin: verificar disponibilidade; senão, usar o script oficial
# https://setup.atuin.sh (pode ter suporte limitado no MSYS2)

# eza: sem pacote oficial; baixar binário do GitHub Releases para Windows
```

Configure o `.bashrc` normalmente após a instalação. O caminho do `ble.sh` será
`~/.local/share/blesh/ble.sh`, igual ao Linux.

Caveats do MSYS2:

- Desempenho do ble.sh pode ser inferior ao Linux nativo (overhead de emulação POSIX)
- Alguns atalhos de teclado podem conflitar com o terminal do Windows
- Integração com processos Windows nativos tem limitações
- atuin pode ter suporte parcial ou instável

## Git Bash (uso limitado)

O Git Bash (MinGW) é mais limitado que o MSYS2. O ble.sh não tem suporte oficial ao
Git Bash puro. Starship e fzf funcionam, mas a experiência completa descrita neste
repositório não é viável nesse ambiente.

Se você já usa Git Bash e quer apenas Starship e fzf básicos, adicione ao
`~/.bash_profile` do Git Bash:

```bash
eval "$(starship init bash)"
```

Para a experiência completa no Windows sem WSL2, prefira MSYS2 ao Git Bash.

## Resumo: qual caminho escolher

| Situação | Recomendação |
|---|---|
| Quer a experiência completa, sem restrições | WSL2 |
| Precisa de shell nativo (sem VM) | MSYS2 |
| Já usa Git Bash, quer só o básico | Git Bash + Starship |

O suporte nativo ao Windows é o menos maduro desta pilha de ferramentas. Para uso
profissional, WSL2 é a escolha mais confiável.
