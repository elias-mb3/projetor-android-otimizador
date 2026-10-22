# Instruções para o agente

Este repositório serve para otimizar projetores Android genéricos (ex.: ELT300-PRO, Amlogic) via ADB pela rede. O usuário fala português do Brasil: responda em PT-BR, em linguagem simples, e explique cada mudança antes de fazer.

## Regras
- **Sempre use `-s <IP>:5555`** em todo comando `adb`, para não mexer em outro aparelho conectado. Guarde o IP na variável `P` em cada comando.
- **Leia antes de mudar.** Faça o diagnóstico (`/projetor-conectar`) antes de qualquer alteração.
- **Peça confirmação** antes de remover apps. Mostre a lista e pergunte o que o usuário usa (streaming, AirPlay, player local, busca por voz, navegador).
- **Remova com `pm uninstall --user 0`**, nunca com `pm disable-user`. O firmware desses projetores reativa apps desativados ao reiniciar. Toda remoção é reversível com `cmd package install-existing <pacote>`.
- **Nunca remova** pacotes essenciais: `android`, `com.android.systemui`, `com.android.providers.*`, `com.android.tv.settings`, `com.droidlogic.tvinput`, `com.android.vending`, `com.google.android.gms`, `com.google.android.gsf`, `com.android.webview`, `com.android.networkstack*`, `com.android.permissioncontroller`, `com.android.packageinstaller`, `com.google.android.leanback.ime`, nem o launcher em uso antes de haver outro funcionando.
- **Reinicie e verifique** depois de cada nível: confira se as mudanças continuam valendo após o reinício.
- **Nunca rode comandos que enfraquecem a segurança** (`adb root`, `adb disable-verity`, `adb remount`) sem antes explicar o risco ao usuário. Prefira que **o próprio usuário** rode `disable-verity` (via `! comando`).
- Antes de mexer em `/system`, faça **backup** com `adb pull` para `./backup/`.
- No fim, lembre o usuário de **desligar a Depuração USB**.

## Ferramentas
- `scripts/ui.sh`: automação da interface pelo controle remoto virtual (dump da tela, toque por texto, teclas do controle). As telas leanback do Android TV às vezes ignoram `input tap` nos switches; nesse caso navegue com `DPAD_UP`/`DPAD_DOWN` e confirme com `DPAD_CENTER`.
- `scripts/diagnostico.sh`: coleta informações do sistema.
- `scripts/conexoes.sh`: lista conexões TCP ativas por app.

## Documentação
- `docs/pacotes.md`: pacotes do ELT300-PRO e o que cada um faz.
- `docs/apps-e-launcher.md`: instalação de apps e configuração do Projectivy.
- `docs/seguranca.md`: apps suspeitos e remoção na partição do sistema.
