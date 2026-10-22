---
name: projetor-conectar
description: Conecta ao projetor Android pela rede via ADB e faz um diagnóstico. Use quando o usuário passar o IP do projetor ou pedir para conectar, antes de qualquer otimização.
argument-hint: <ip-do-projetor>
---

# Conectar ao projetor

IP informado: `$ARGUMENTS`. Se estiver vazio, peça o IP ao usuário (fica em *Configurações → Rede → Wi-Fi* no projetor).

1. **ADB instalado?** Rode `which adb`. Se não estiver, peça ao usuário para instalar (é preciso senha):
   - Fedora: `! sudo dnf install -y android-tools`
   - Ubuntu: `! sudo apt install -y adb`
   - macOS: `! brew install android-platform-tools`

2. **Testar a rede:**
   ```bash
   ping -c1 -W2 <ip>; nc -zv -w3 <ip> 5555
   ```
   - Se o ping falhar, o projetor está em outra rede ou desligado.
   - Se a porta 5555 estiver fechada, a depuração por rede não está ativa. Opções:
     a) procurar *Depuração por rede* / *ADB por Wi-Fi* nas Opções do desenvolvedor;
     b) ligar o projetor ao PC por cabo USB (porta OTG ou Service), rodar `adb devices` e depois `adb tcpip 5555`.

3. **Conectar:**
   ```bash
   adb connect <ip>:5555 && adb devices -l
   ```
   Se aparecer `unauthorized`, peça ao usuário para aceitar a pergunta "Permitir depuração USB?" na tela do projetor, marcando **Sempre permitir**. Depois rode `adb devices` de novo.

4. **Diagnóstico:**
   ```bash
   P=<ip>:5555 scripts/diagnostico.sh
   ```

5. **Resumo para o usuário**, em tabela: modelo, versão do Android, RAM total e livre, resolução, launcher atual, se tem root e apps instalados. Depois sugira os próximos passos:
   - `/projetor-otimizar` (recomendado)
   - `/projetor-apps`
   - `/projetor-seguranca`
