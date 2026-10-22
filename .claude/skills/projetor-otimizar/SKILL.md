---
name: projetor-otimizar
description: Otimiza o desempenho do projetor Android (animações, limite de apps em segundo plano, remoção de bloatware). Use quando o usuário pedir para otimizar, deixar mais rápido ou limpar apps do projetor.
---

# Otimizar o projetor

Precisa estar conectado (`/projetor-conectar`). Use `P=<ip>:5555` e `adb -s $P` em todos os comandos.

## 1. Medir antes
```bash
adb -s $P shell grep MemAvailable /proc/meminfo
```

## 2. Perguntar o uso
Liste os apps (`pm list packages -3` e os de fábrica conhecidos em `docs/pacotes.md`) e use AskUserQuestion para perguntar:
- Quais apps de streaming o usuário usa (Netflix, YouTube, Prime Video, Apple TV, Stremio etc.)
- Se usa AirPlay ou Miracast para espelhar a tela, e player local (MX Player)
- Se usa a busca por voz do controle (pacote `com.google.android.katniss`)
- Se usa o navegador (Chrome)

## 3. Aplicar
```bash
# Animações
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  adb -s $P shell settings put global $k 0.5
done
# Apps em segundo plano
adb -s $P shell settings put global activity_manager_constants max_cached_processes=8
# Remover apps (lista combinada com o usuário)
for p in <pacotes>; do echo -n "$p: "; adb -s $P shell pm uninstall --user 0 $p; done
```
Use **`pm uninstall --user 0`**, não `disable-user`: o firmware reativa os desativados. Consulte `docs/pacotes.md` para ver o que é seguro e respeite a lista "Nunca remova" do `CLAUDE.md`.

## 4. Reiniciar e verificar
```bash
adb -s $P reboot; sleep 90; adb connect $P
adb -s $P shell pm list packages | grep -E '<pacotes removidos>'   # deve vir vazio
adb -s $P shell settings get global window_animation_scale
adb -s $P shell grep MemAvailable /proc/meminfo
```
Alguns pacotes protegidos voltam após o reinício (ex.: `printspooler`, `musicfx`). Avise o usuário e não insista.
Se pacotes **suspeitos** reaparecerem, sugira `/projetor-seguranca`.

## 5. Relatório
Mostre uma tabela de antes e depois (RAM livre, animações, apps removidos), o que deixa de funcionar (ex.: busca por voz) e como desfazer (`/projetor-desfazer`).
