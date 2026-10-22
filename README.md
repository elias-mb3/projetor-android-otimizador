# Otimizador de Projetor Android com Claude Code

Passo a passo e um agente pronto do [Claude Code](https://claude.com/claude-code) para **otimizar projetores Android genéricos** (como o **ELT300-PRO** e outros com chip Amlogic) pela rede, usando ADB.

O agente se conecta ao projetor, analisa o sistema e faz as mudanças por você. Ele sempre pede confirmação antes de mexer em algo.

> Testado em: **ELT300-PRO**, Android TV 13, chip Amlogic T950S (`t950s_be311`), 2 GB de RAM, 720p.
> Outros projetores Android genéricos costumam ser muito parecidos, mas os nomes dos apps podem mudar.

---

## O que dá para fazer

| Nível | O que faz | Risco |
|---|---|---|
| **1. Otimizar** | Animações mais rápidas, menos apps em segundo plano, remoção de bloatware | Baixo, tudo reversível |
| **2. Launcher** | Instala LocalSend, Stremio e o **Projectivy Launcher** e configura o launcher para ficar leve | Baixo |
| **3. Segurança** | Procura apps suspeitos de fábrica e conexões de rede estranhas | Só leitura |
| **4. Limpeza do sistema** | Remove de vez os apps de fábrica que se reinstalam sozinhos e faz o Projectivy abrir ao ligar | **Médio**: exige desligar o dm-verity |

Você pode parar em qualquer nível. Para a maioria das pessoas, o nível 1 já deixa o projetor bem mais leve.

---

## Antes de começar

### No PC (Linux, macOS ou Windows com WSL)
1. Instale o **Claude Code**: https://claude.com/claude-code
2. Instale o **ADB**:
   - Fedora: `sudo dnf install android-tools`
   - Ubuntu/Debian: `sudo apt install adb`
   - macOS: `brew install android-platform-tools`
3. Clone este repositório e entre na pasta:
   ```bash
   git clone <url-deste-repo> projetor-android-otimizador
   cd projetor-android-otimizador
   ```

### No projetor: ativar o modo desenvolvedor
1. Abra **Configurações → Sistema → Sobre**. Em alguns modelos fica em *Configurações → Sobre* ou *Informações do dispositivo*.
2. Clique **7 vezes** em **Número da versão** (*Build number*) até aparecer "Você agora é um desenvolvedor".
3. Volte e abra **Opções do desenvolvedor**.
4. Ative a **Depuração USB**.
   - Se existir **Depuração por rede** ou **ADB por Wi-Fi**, ative também.
   - Se não existir, tudo bem: na maioria desses projetores o ADB por rede já vem ligado na porta 5555.
5. Anote o **IP do projetor** em *Configurações → Rede → Wi-Fi → (sua rede)*. Exemplo: `192.168.0.28`.

> O projetor e o PC precisam estar **na mesma rede Wi-Fi**.

---

## Usando o agente

Dentro da pasta do repositório, rode:

```bash
claude
```

E peça, por exemplo:

```
Meu projetor está no IP 192.168.0.28. Conecte nele e otimize.
```

O agente conhece as skills abaixo e escolhe a certa sozinho. Você também pode chamar cada uma direto:

| Comando | O que faz |
|---|---|
| `/projetor-conectar 192.168.0.28` | Testa a rede, conecta pelo ADB e mostra um diagnóstico do projetor |
| `/projetor-otimizar` | Nível 1: animações, apps em segundo plano e remoção de bloatware |
| `/projetor-apps` | Nível 2: instala LocalSend, Stremio e Projectivy e configura o launcher |
| `/projetor-seguranca` | Nível 3: procura apps suspeitos e conexões de rede |
| `/projetor-sistema` | Nível 4: remove de vez os apps que voltam sozinhos |
| `/projetor-desfazer` | Reverte qualquer mudança |

Na primeira conexão, vai aparecer na tela do projetor a pergunta **"Permitir depuração USB?"**. Marque **"Sempre permitir deste computador"** e confirme.

---

## O passo a passo manual (sem o agente)

Use a variável `P` com o IP do seu projetor:

```bash
export P=192.168.0.28:5555
adb connect $P
adb -s $P shell getprop ro.product.model
```

### Nível 1: Otimizar
```bash
# Animações em 0.5x
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  adb -s $P shell settings put global $k 0.5
done

# No máximo 8 apps em cache na RAM
adb -s $P shell settings put global activity_manager_constants max_cached_processes=8

# Ver o que está instalado
adb -s $P shell pm list packages -3          # apps de terceiros
adb -s $P shell pm list packages             # todos

# Remover um app (só para o usuário; pode ser desfeito)
adb -s $P shell pm uninstall --user 0 <pacote>
# Desfazer:
adb -s $P shell cmd package install-existing <pacote>
```

> Use `pm uninstall --user 0` em vez de `pm disable-user`. Nesses projetores, um app de fábrica **reativa sozinho** os apps desativados a cada reinício.

A lista de apps que foram removidos com segurança no ELT300-PRO está em [`docs/pacotes.md`](docs/pacotes.md).

### Nível 2: Apps e Projectivy
Veja [`docs/apps-e-launcher.md`](docs/apps-e-launcher.md).

### Níveis 3 e 4: Segurança e sistema
Veja [`docs/seguranca.md`](docs/seguranca.md).

---

## Resultados no ELT300-PRO

| | Antes | Depois |
|---|---|---|
| RAM livre | cerca de 870 MB | cerca de 1,1 a 1,3 GB |
| Animações | 1.0x | 0.5x |
| Apps em cache | padrão (cerca de 32) | 8 |
| Launcher | HTC (com o Projectivy só ao apertar Home) | Projectivy ao ligar |
| Apps de sistema suspeitos | 2 rodando como `system` | removidos |

---

## ⚠️ Segurança: leia isto

- Esses projetores costumam vir com **root aberto** e **apps de sistema com permissões excessivas**: instalar apps em silêncio, gravar áudio, ver localização e ler registros. Esse é o padrão de malware de fábrica conhecido como *BadBox*.
- **Não faça login** no projetor com contas importantes, como banco ou e-mail principal. Netflix e Prime Video não têm problema.
- **Quando terminar, desligue a Depuração USB.** Com ela ligada, qualquer aparelho na sua Wi-Fi pode controlar o projetor.

## Licença
MIT
