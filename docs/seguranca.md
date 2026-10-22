# Segurança

## 1. Procurar apps suspeitos

Apps de sistema com permissões perigosas:
```bash
for p in $(adb -s $P shell pm list packages -s | sed 's/package://'); do
  perms=$(adb -s $P shell dumpsys package $p | grep 'granted=true' \
    | grep -oE 'INSTALL_PACKAGES|DELETE_PACKAGES|READ_LOGS|RECORD_AUDIO|WRITE_SECURE_SETTINGS' | sort -u | tr '\n' ' ')
  [ -n "$perms" ] && echo "$p: $perms"
done
```
Desconfie de apps com **nomes genéricos** (`com.abc.*`, `com.mbox.*`, `com.fb`) que rodam com uid 1000 (`system`) e pedem essas permissões. Para ver o uid:
```bash
adb -s $P shell dumpsys package <pacote> | grep -E 'userId|codePath'
```

Conexões de rede ativas por app:
```bash
P=$P scripts/conexoes.sh
```

## 2. Limpeza do sistema (nível 4)

Use isso quando os apps suspeitos **voltam sozinhos** depois de reiniciar. Remover direto da partição do sistema também faz o Projectivy abrir ao ligar.

### Requisitos
```bash
adb -s $P shell getprop ro.build.type          # precisa ser userdebug
adb -s $P shell getprop ro.boot.flash.locked   # precisa ser 0 (bootloader desbloqueado)
```

### ⚠️ Riscos
- `disable-verity` desliga a verificação de integridade do sistema. A partir daí, alterações no sistema (inclusive as de um malware) não são mais detectadas.
- Remover o app errado pode impedir o projetor de ligar. O ADB costuma continuar funcionando, então dá para desfazer.
- **O próprio usuário deve rodar o passo A**, de preferência com `! comando` dentro do Claude Code.

### A. Desligar o verity (o usuário roda)
```bash
adb -s $P root && sleep 5 && adb connect $P && adb -s $P disable-verity && adb -s $P reboot
```

### B. Backup e remoção (o agente roda depois do reinício)
```bash
adb connect $P; adb -s $P root; sleep 5; adb connect $P
adb -s $P remount

mkdir -p backup
for d in NetFocus NetflixNinja HTCLauncher; do adb -s $P pull /system/app/$d backup/; done

adb -s $P shell "mkdir -p /system/disabled_apps && \
  mv /system/app/NetFocus /system/app/NetflixNinja /system/app/HTCLauncher /system/disabled_apps/"
adb -s $P reboot
```

> Mova as pastas para **fora** de `/system/app`. Apenas renomear a pasta dentro de `/system/app` não basta, porque o Android lê as subpastas.
> Só remova o `HTCLauncher` **depois** de confirmar que o Projectivy está instalado e funcionando.

### C. Verificar
```bash
adb connect $P
adb -s $P shell pm list packages | grep -E 'mbox|ninja|htclauncher' || echo removidos
adb -s $P shell "dumpsys activity activities | grep -m1 topResumedActivity"   # deve mostrar o Projectivy
```
Abra a Netflix e confira se funciona.

### Desfazer
```bash
adb -s $P root; adb -s $P remount
adb -s $P shell "mv /system/disabled_apps/* /system/app/"
adb -s $P enable-verity
adb -s $P reboot
```

## 3. Ao terminar
1. **Desligue a Depuração USB** no projetor (*Opções do desenvolvedor*).
2. Não faça login com contas importantes no projetor.
