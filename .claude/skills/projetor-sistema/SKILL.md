---
name: projetor-sistema
description: Remove de vez, da partição do sistema, os apps de fábrica que se reinstalam sozinhos, e faz o Projectivy abrir ao ligar. Exige desligar o dm-verity. Use só quando o usuário pedir e depois de explicar os riscos.
---

# Limpeza do sistema (nível 4)

Siga a seção 2 de `docs/seguranca.md` à risca.

1. **Requisitos:** `ro.build.type` igual a `userdebug` e `ro.boot.flash.locked` igual a `0`. Se não bater, pare e explique que não dá para fazer neste modelo.
2. **Explique os riscos** e confirme com AskUserQuestion:
   - O verity fica desligado.
   - Há um pequeno risco de o projetor não ligar.
   - Tudo é reversível pelo ADB.
3. **Confirme que o Projectivy está instalado e funcionando** antes de remover o launcher de fábrica.
4. **O usuário roda o passo A** (`disable-verity`). Mostre o comando pronto com o prefixo `!` e espere ele avisar que o projetor reiniciou.
5. **Passo B:** `adb root`, `adb remount`, backup em `./backup/` com `adb pull` e depois **mova** as pastas para `/system/disabled_apps/`. Não apague nada.
   - Confirme o caminho de cada pacote antes: `dumpsys package <pacote> | grep codePath`.
6. **Reinicie e verifique** (passo C): os pacotes sumiram, o launcher no topo é o Projectivy e a Netflix abre.
7. **No fim**, mostre ao usuário onde ficou o backup, como desfazer e reforce: **desligar a Depuração USB**, porque o adbd está como root e o verity está desligado.
