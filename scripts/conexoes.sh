#!/bin/bash
# Lista conexões TCP ativas por app (precisa de root no projetor).
# Uso: P=192.168.0.28:5555 scripts/conexoes.sh
: "${P:?Defina P=<ip>:5555}"
D="timeout 30 adb -s $P shell"

$D "su 0 cat /proc/net/tcp /proc/net/tcp6 2>/dev/null || cat /proc/net/tcp /proc/net/tcp6" \
  | awk 'NR>1 && $4=="01" {print $3, $8}' | sort -u | while read -r remoto uid; do
    pkg=$($D pm list packages --uid "$uid" 2>/dev/null | head -1 | sed -E 's/package:([^ ]+).*/\1/')
    [ "$uid" = 0 ] && pkg=root
    [ "$uid" = 1000 ] && pkg="system (uid 1000)"
    ip=$(python3 - "$remoto" <<'EOF'
import sys, ipaddress
h, port = sys.argv[1].split(':')
b = bytes.fromhex(h)
if len(b) == 4:
    ip = ipaddress.IPv4Address(b[::-1])
else:
    ip = ipaddress.IPv6Address(b''.join(b[i:i+4][::-1] for i in range(0, 16, 4)))
    ip = ip.ipv4_mapped or ip
print(f"{ip}:{int(port, 16)}")
EOF
)
    printf '%-40s %s\n' "$pkg" "$ip"
  done
echo
echo "Isso mostra só o momento atual. Repita algumas vezes ao longo do dia para ter uma visão melhor."
