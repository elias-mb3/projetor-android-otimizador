#!/bin/bash
# Diagnóstico do projetor. Uso: P=192.168.0.28:5555 scripts/diagnostico.sh
: "${P:?Defina P=<ip>:5555}"
D="timeout 30 adb -s $P shell"

echo "== Sistema"
echo "Modelo:      $($D getprop ro.product.model)"
echo "Android:     $($D getprop ro.build.version.release)"
echo "Build:       $($D getprop ro.build.type)"
echo "Arquitetura: $($D getprop ro.product.cpu.abilist)"
$D wm size; $D wm density
echo; echo "== Memória e armazenamento"
$D "grep -E 'MemTotal|MemAvailable' /proc/meminfo"
$D "df -h /data | tail -1"
echo; echo "== Configurações de desempenho"
for k in window_animation_scale transition_animation_scale animator_duration_scale activity_manager_constants; do
  echo "$k = $($D settings get global $k)"
done
echo; echo "== Launcher atual"
$D cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME | tail -1
echo; echo "== Root"
$D "which su" || echo "sem su"
echo; echo "== Apps de terceiros"
$D pm list packages -3 | sed 's/package://'
echo; echo "== Maiores consumidores de RAM"
$D dumpsys meminfo | sed -n '/Total PSS by process/,/^$/p' | head -15
