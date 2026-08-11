# Espertinhos

App educativo infantil com 12 minijogos, Flutter + Firebase (Android).

Este projeto vive em `OneDrive\Documentos\projetoAppEspertinhos` de propósito — é uma pasta sem acentos/espaços (diferente de "Área de Trabalho"), porque o compilador de shaders do Android quebra em caminhos com caracteres especiais. Se for mover de novo, mantenha o nome da pasta só com letras/números.

## Abrindo em outro PC

O OneDrive sincroniza o **código-fonte** (esta pasta), mas **não** sincroniza o Flutter SDK, o Android SDK, o Java nem o Firebase CLI — essas ferramentas foram instaladas fora da pasta do projeto (`C:\src\flutter`, `C:\Android\sdk`, etc.) e precisam ser instaladas de novo em qualquer outro PC onde você for compilar/rodar o app. Sem elas, dá pra ver e editar os arquivos, mas não pra rodar `flutter run`/`flutter build`.

O login do Firebase CLI (`firebase login`) também é por máquina — no outro PC você vai precisar logar de novo com a conta `janseysilva@gmail.com` (ou instalar o Flutter/Android SDK lá e me pedir pra automatizar de novo).

## Toolchain já instalada nesta máquina

- Flutter SDK: `C:\src\flutter`
- Android SDK: `C:\Android\sdk`
- JDK 17 (Temurin): `C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot`
- Node.js + Firebase CLI + FlutterFire CLI

As variáveis de ambiente (`JAVA_HOME`, `ANDROID_HOME`, `PATH`) já foram configuradas para o seu usuário do Windows. **Feche e reabra o terminal** (ou reinicie o PC) para que `flutter`, `adb` e `java` funcionem sem caminho completo.

## Passo obrigatório: conectar o Firebase

O app ainda não está ligado a um projeto Firebase real (`lib/firebase_options.dart` está com valores de exemplo). Sem isso, o app abre direto numa tela de "Firebase não configurado".

1. Crie um projeto em [console.firebase.google.com](https://console.firebase.google.com) (gratuito, plano Spark já serve para começar).
2. No terminal, na raiz deste projeto:
   ```bash
   firebase login
   flutterfire configure
   ```
3. Escolha o projeto Firebase criado e a plataforma **android**. Isso gera `lib/firebase_options.dart` de verdade e `android/app/google-services.json`.
4. No [Firebase Console](https://console.firebase.google.com) do projeto:
   - **Authentication** → Sign-in method → ative **Anônimo**.
   - **Firestore Database** → crie o banco (modo produção) e publique as regras do arquivo [`firestore.rules`](firestore.rules) deste repositório (Console → Firestore → Regras, cole o conteúdo e publique).

## Rodar o app

Com um emulador Android aberto ou celular conectado via USB (depuração USB ativada):

```bash
flutter pub get
flutter run
```

## Estrutura

- `lib/games/<jogo>/` — um diretório por minijogo.
- `lib/widgets/choice_game_scaffold.dart` — tela genérica reusada pelos jogos de "múltipla escolha, 8 rodadas" (Cores e Formas, Contando, Alfabeto, Matemática, Sequência, Ache o Diferente, Maior ou Menor, Opostos).
- `lib/services/app_state.dart` — estado global (idade escolhida, autenticação anônima, progresso).
- `lib/services/profile_service.dart` — leitura/escrita no Firestore (`users/{uid}`).
- Sistema de estrelas: `lib/models/scoring.dart` — por erros (jogos de rodada) ou por eficiência de jogadas (Memória, Quebra-cabeça).
- Trava dos responsáveis para trocar a faixa de idade: `lib/widgets/admin_lock_dialog.dart` (conta de matemática simples).

## Próximos passos sugeridos

- Testar em um emulador Android (nenhum foi configurado ainda nesta máquina) ou dispositivo físico.
- Trocar os emojis/formas desenhadas à mão por arte ilustrada, se desejar um visual mais "premium".
- Adicionar sons (efeito de acerto/erro, música de fundo) — a estrutura atual não usa áudio ainda.
- Antes de publicar: seguir a política "Designed for Families" da Google Play (anúncios certificados para crianças, sem rastreamento) — ver anotações do projeto anterior (PWA "Espertinhos").
