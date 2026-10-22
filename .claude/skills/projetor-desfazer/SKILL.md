---
name: projetor-desfazer
description: Reverte as mudanças feitas no projetor (reinstala apps removidos, restaura animações, volta o launcher de fábrica, restaura apps do sistema). Use quando algo parou de funcionar ou o usuário quiser voltar atrás.
---

# Desfazer mudanças

Pergunte o que o usuário quer desfazer e use o comando correspondente:

| O que desfazer | Comando |
|---|---|
| App removido com `--user 0` | `adb -s $P shell cmd package install-existing <pacote>` |
| Animações | `settings put global <window/transition/animator>_scale 1.0` |
| Limite de apps em segundo plano | `adb -s $P shell settings delete global activity_manager_constants` |
| Projectivy | `adb -s $P shell pm uninstall com.spocky.projengmenu`, depois `cmd package set-home-activity` com o launcher de fábrica |
| Apps do sistema (nível 4) | `adb root; adb remount; adb shell "mv /system/disabled_apps/* /system/app/"; adb reboot` |
| Verity | `adb -s $P enable-verity; adb -s $P reboot` |

Para ver o que foi removido, compare `pm list packages -u` (todos, inclusive os desinstalados para o usuário) com `pm list packages`.

Reinicie e verifique depois de desfazer.
