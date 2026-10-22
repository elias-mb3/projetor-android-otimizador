# Pacotes do ELT300-PRO

Levantamento feito num ELT300-PRO (Android TV 13, Amlogic T950S). Outros modelos podem ter nomes diferentes, então sempre confira com `pm list packages`.

## Removidos com segurança (`pm uninstall --user 0`)

| Pacote | O que é | Observação |
|---|---|---|
| `com.master.tv.market` | Loja chinesa | Bloatware |
| `com.overseas.store.appstore` | Loja chinesa | Bloatware |
| `com.google.android.tvrecommendations` | Recomendações na tela inicial | A tela inicial fica sem sugestões |
| `com.google.android.katniss` | Assistente e busca por voz do Google | O botão de microfone para de funcionar. Libera cerca de 70 MB |
| `com.android.chrome` | Navegador | Pesado para 2 GB de RAM |
| `com.fb` | App de teste de fábrica ("JMFactory") | Sem utilidade para o usuário |
| `com.android.deskclock` | Relógio | |
| `com.android.camera2` | Câmera | O projetor não tem câmera |
| `com.android.gallery3d` | Galeria | |
| `com.droidlogic.musicplayer` | Player de música | |
| `com.apple.atve.androidtv.appletv` | Apple TV | Opcional: só se não usar |
| `com.waxrain.airplaydmr2` | AirPlay (espelhar iPhone) | Opcional: só se não usar |

## Voltam ao reiniciar (protegidos pelo sistema; deixe como estão)
- `com.android.printspooler`: serviço de impressão
- `com.android.musicfx`: equalizador

Os dois quase não usam memória.

## Suspeitos: rodam como `system` (uid 1000)

| Pacote | Pasta | Permissões |
|---|---|---|
| `com.mbox.accessibility` | `/system/app/NetFocus` | Instalar e remover apps, ligar e desligar apps, ler registros do sistema, gravar áudio, localização, contas, internet, alterar configurações seguras |
| `com.abc.ninja` | `/system/app/NetflixNinja` | As mesmas acima |

- Eles se **reinstalam a cada reinício**, então `pm uninstall --user 0` não resolve.
- Provavelmente são eles que reativam apps desativados e apagam as permissões de acessibilidade.
- A Netflix funciona normalmente sem o `com.abc.ninja`.
- Para remover de vez, veja [seguranca.md](seguranca.md).

## Outros de fábrica (mantidos)

| Pacote | O que é |
|---|---|
| `com.htc.htclauncherhighenglishd08` | Launcher de fábrica (`/system/app/HTCLauncher`) |
| `com.master.apps` | Tela "todos os apps" do launcher (`/system/priv-app/AllApp`) |
| `com.koushikdutta.superuser` | Gerenciador de root (o binário fica em `/system/xbin/su`) |
| `com.droidlogic.updater` | Atualizador do fabricante |
| `com.droidlogic.miracast` | Espelhamento Miracast |
| `com.softwinner.tcorrection` | Correção de trapézio (keystone) |
