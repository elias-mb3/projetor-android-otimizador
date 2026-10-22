---
name: projetor-seguranca
description: Verifica se o projetor tem apps suspeitos de fábrica ou conexões de rede estranhas (vazamento de dados). Use quando o usuário perguntar sobre segurança, malware, privacidade ou apps suspeitos. Só faz leitura.
---

# Verificação de segurança (só leitura)

Siga a seção 1 de `docs/seguranca.md`.

1. **Root:** `adb -s $P shell which su`. Se existir, avise que o projetor vem com root aberto.
2. **Apps de sistema com permissões perigosas:** rode o loop do `docs/seguranca.md`. Para cada suspeito, mostre o pacote, a pasta (`codePath`), o uid e as permissões.
   - Sinais de alerta: uid 1000, nome genérico, permissões como `INSTALL_PACKAGES`, `READ_LOGS`, `RECORD_AUDIO` ou `WRITE_SECURE_SETTINGS`, e a combinação `CHANGE_COMPONENT_ENABLED_STATE` + `RECEIVE_BOOT_COMPLETED`.
3. **Está rodando?** `adb -s $P shell "ps -A -o USER,NAME" | grep <pacote>`
4. **Conexões:** `P=$P scripts/conexoes.sh`. Identifique os destinos (Google, CDN etc.) e destaque conexões de apps suspeitos ou para IPs desconhecidos. Avise que isso mostra só o momento atual.
5. **Relatório:** tabela com os apps suspeitos e o risco de cada um, as conexões encontradas e as recomendações:
   - Tentar `pm uninstall --user 0`, reiniciar e conferir se voltaram.
   - Se voltarem, oferecer `/projetor-sistema`.
   - Não fazer login com contas importantes no projetor.
   - Desligar a Depuração USB ao terminar.

Não remova nada nesta skill sem confirmação do usuário.
