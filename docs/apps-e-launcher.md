# Apps e Projectivy Launcher

## 1. Descobrir a arquitetura
```bash
adb -s $P shell getprop ro.product.cpu.abilist
```
O ELT300-PRO é `armeabi-v7a` (32 bits). Baixe sempre a versão que bate com a arquitetura.

## 2. LocalSend (receber arquivos do PC)
Baixe pelo GitHub oficial:
```bash
mkdir -p apks
URL=$(curl -s https://api.github.com/repos/localsend/localsend/releases/latest \
  | grep -oE '"browser_download_url": "[^"]+android-arm32v7\.apk"' | cut -d'"' -f4)
curl -L -o apks/localsend.apk "$URL"
adb -s $P install apks/localsend.apk
```
- Para 64 bits, troque `arm32v7` por `arm64v8`.
- No PC: `flatpak install flathub org.localsend.localsend_app` ou https://localsend.org
- Os arquivos recebidos vão para a pasta *Downloads* do projetor e abrem no MX Player ou outro player.

## 3. Stremio
Baixe pelo site oficial (versão estável para Android TV):
```bash
curl -sL https://www.stremio.com/downloads | grep -oE 'https://[^"]+androidTV[^"]+armeabi-v7a\.apk' | sort -u
curl -L -o apks/stremio.apk "<link da versão estável, sem -rc>"
adb -s $P install apks/stremio.apk
```

## 4. Projectivy Launcher
Ele só está na Play Store. Abra a página dele no projetor e o usuário instala pelo controle:
```bash
adb -s $P shell am start -a android.intent.action.VIEW -d "market://details?id=com.spocky.projengmenu"
```

Depois de instalado, defina-o como tela inicial:
```bash
adb -s $P shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity
adb -s $P shell input keyevent HOME
```

### Configurações para deixar leve
Abra as configurações:
```bash
adb -s $P shell am start -n com.spocky.projengmenu/.ui.sidePanels.settings.SettingsActivity
```
(Se der erro de permissão e o projetor tiver root: `adb -s $P shell "su 0 am start -n ..."`.)

| Caminho | Configuração | Valor |
|---|---|---|
| Aparência → Fundo → Papel de parede do launcher | Fonte do papel de parede | **Papel de parede padrão** (o modo Reddit baixa imagens da internet) |
| Geral → Habilitar canais | Canais | **Desligado** (menos memória e início mais rápido) |
| Geral → Sobrepor o launcher atual | Interceptar o launcher de fábrica | **Ligado** |
| Geral | Análise de uso e relatórios de erro | Desligados (já vêm assim) |

Para ver se a mudança foi aplicada (precisa de root):
```bash
adb -s $P shell "su 0 cat /data/data/com.spocky.projengmenu/shared_prefs/com.spocky.projengmenu_preferences.xml"
```
Chaves úteis: `general_override_home`, `general_enable_tv_channels`.

A opção "Sobrepor" usa o serviço de acessibilidade do Projectivy:
```bash
adb -s $P shell settings put secure enabled_accessibility_services \
  com.spocky.projengmenu/com.spocky.projengmenu.services.ProjectivyAccessibilityService
adb -s $P shell settings put secure accessibility_enabled 1
```

> No ELT300-PRO o firmware **apaga essa permissão a cada reinício** e volta para o launcher HTC. A solução definitiva está em [seguranca.md](seguranca.md), na seção de limpeza do sistema.

### Consumo medido
| | Launcher HTC | Projectivy (leve) |
|---|---|---|
| RAM do launcher | cerca de 29 MB | cerca de 65 MB |

### Se ficar pesado
```bash
adb -s $P shell pm uninstall com.spocky.projengmenu
```
