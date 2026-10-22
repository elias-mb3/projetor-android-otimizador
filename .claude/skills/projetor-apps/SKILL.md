---
name: projetor-apps
description: Instala LocalSend, Stremio e o Projectivy Launcher no projetor e configura o launcher para ficar leve. Use quando o usuário quiser instalar esses apps, trocar o launcher ou mandar filmes do PC para o projetor.
---

# Apps e launcher

Siga `docs/apps-e-launcher.md`. Resumo:

1. **Arquitetura:** `adb -s $P shell getprop ro.product.cpu.abilist`. Use APKs `armeabi-v7a`/`arm32v7` ou `arm64`, conforme o resultado.
2. **LocalSend:** baixe do GitHub oficial (`localsend/localsend`, último release) e instale com `adb install`. Baixe os APKs em `./apks/`.
3. **Stremio:** baixe a versão estável para Android TV de https://www.stremio.com/downloads (domínio `dl.strem.io`, sem `-rc`/`beta`) e instale com `adb install`.
4. **Projectivy:** só existe na Play Store. Abra a página no projetor:
   ```bash
   adb -s $P shell am start -a android.intent.action.VIEW -d "market://details?id=com.spocky.projengmenu"
   ```
   Peça ao usuário para clicar em **Instalar** e avisar quando terminar.
5. **Medir o launcher atual antes:**
   `adb -s $P shell dumpsys meminfo <launcher atual> | grep 'TOTAL PSS'` e `grep MemAvailable /proc/meminfo`.
6. **Definir como tela inicial:**
   ```bash
   adb -s $P shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity
   adb -s $P shell input keyevent HOME
   ```
7. **Configurar** pelo `scripts/ui.sh`, conforme a tabela em `docs/apps-e-launcher.md`: papel de parede padrão, canais desligados, "Sobrepor o launcher atual" ligado.
   - Os switches do leanback ignoram `input tap`. Navegue com `scripts/ui.sh key DPAD_UP/DPAD_DOWN`, confira com `scripts/ui.sh focused` e confirme com `DPAD_CENTER`.
   - Verifique pelo arquivo `shared_prefs` (precisa de root).
8. **Medir de novo.** Feche a Play Store antes (`am force-stop com.android.vending`) para não distorcer a medição. Se o Projectivy usar muito mais RAM ou deixar o projetor lento, **pergunte** se o usuário quer removê-lo e voltar ao launcher anterior.
9. **Reiniciar e conferir** se o projetor liga no Projectivy. Se voltar para o launcher de fábrica, explique o motivo (o firmware apaga a permissão de acessibilidade) e ofereça duas saídas: apertar Home ao ligar, ou `/projetor-sistema`.
10. Ensine o usuário a usar o LocalSend no PC (`flatpak install flathub org.localsend.localsend_app` ou https://localsend.org).
