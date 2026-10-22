#!/bin/bash
# Automação da interface do projetor via ADB.
# Uso:
#   P=192.168.0.28:5555 scripts/ui.sh dump              # textos visíveis na tela
#   P=... scripts/ui.sh tap "Texto do item"             # toca no item (aceita regex)
#   P=... scripts/ui.sh focused                         # texto do item com foco
#   P=... scripts/ui.sh key DPAD_DOWN [DPAD_CENTER ...] # teclas do controle remoto
set -e
: "${P:?Defina P=<ip>:5555}"
D="timeout 30 adb -s $P shell"

xml(){ $D "uiautomator dump /sdcard/ui.xml >/dev/null; cat /sdcard/ui.xml"; }

case $1 in
  dump)
    xml | grep -oE 'text="[^"]+"' ;;
  tap)
    b=$(xml | grep -oE "text=\"$2\"[^>]*bounds=\"[^\"]+\"" | head -1 | grep -oE 'bounds="[^"]+"' | grep -oE '[0-9]+')
    set -- $b
    [ -z "$1" ] && { echo "item não encontrado"; exit 1; }
    $D input tap $(( ($1+$3)/2 )) $(( ($2+$4)/2 )); sleep 2 ;;
  focused)
    xml | python3 -c "
import sys, xml.etree.ElementTree as E
for n in E.fromstring(sys.stdin.read()).iter('node'):
    if n.get('focused') == 'true':
        print([m.get('text') for m in n.iter('node') if m.get('text')][:2]); break" ;;
  key)
    shift; for k in "$@"; do $D input keyevent "$k"; sleep 0.5; done ;;
  *)
    sed -n '2,7p' "$0"; exit 1 ;;
esac
