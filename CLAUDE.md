# Contexto do projeto Espertinhos — leia antes de começar

Jansey usa dois PCs diferentes; a memória do Claude Code é local a cada máquina. Este arquivo sincroniza junto com o código (via OneDrive), então é a forma de continuar de onde parou em qualquer um dos dois. Ver também `README.md` nesta mesma pasta (instruções de ambiente/toolchain) e o `CLAUDE.md` da pasta `OneDrive\trabalhos jansey` (contexto dos outros projetos do Jansey).

**Instrução para o Claude:** sempre que um trabalho relevante for concluído aqui, atualize este arquivo antes de encerrar a conversa.

## O que é
App educativo infantil "Espertinhos" — 12 minijogos (Cores e Formas, Contando, Memória, Alfabeto, Matemática, Sequência, Pintar, Ache o Diferente, Maior ou Menor, Opostos, Caça-Palavras, Quebra-cabeça). Mascote coelhinho 🐰, 3 faixas etárias (2-4/5-6/7-8 anos), sistema de estrelas (nota por jogo + contador vitalício meta 500), trava dos responsáveis por múltipla escolha.

**Stack definitivo (decidido 2026-08-11):** Flutter + Firebase (login anônimo via Firebase Auth, dados na nuvem via Cloud Firestore, projeto Firebase `espertinhos-app-2026`). A versão antiga em HTML/JS/PWA (pasta `app-educativo-kids` dentro de `trabalhos jansey`) está **descontinuada** — não retomar sem o Jansey pedir.

## Status atual (2026-08-11)
- 12 minijogos implementados em Flutter. Ainda sem sons nem arte ilustrada (usa emoji/formas desenhadas em código).
- Visual portado da versão HTML antiga (cores, cartões, animações do mascote, splash, trava dos responsáveis) — **primeira passada feita, AINDA NÃO TESTADA** com `flutter run`/`flutter analyze` (feito num PC sem Flutter instalado). Validar no PC do Jansey antes de considerar pronto.
- Firebase ainda não conectado de verdade neste checkout — `lib/firebase_options.dart` pode estar com valores de exemplo; seguir o passo "conectar o Firebase" do `README.md` se for o caso.

## Rumo à publicação na Google Play — checklist
- **Política de Privacidade:** escrita e publicada. Artifact: https://claude.ai/code/artifact/fd100547-577c-4254-9a2a-2dea75f1a5d4 — contato Jansey Silva / janseysilva@gmail.com. **Pendente do Jansey:** revisar e tornar o Artifact público (menu de compartilhar) antes de colar o link no Play Console.
- **Ícone do app:** feito — emoji real 🐰 recortado sobre o degradê do app, aplicado como ícone legado + adaptativo (Android 8+). Ícone 512x512 da loja em `materiais-loja/icone_playstore_512.png`. Pendente: conferir visualmente no celular após o próximo `flutter run`.
- **Capturas de tela (5) e imagem de destaque (1024x500):** feitas, em `materiais-loja/capturas-tela/` e `materiais-loja/feature_graphic.jpg` — são recriações fiéis via HTML/Canvas (não screenshots do app rodando de verdade ainda). Trocar pelas reais depois que o Jansey rodar o app.
- **Texto da ficha da loja:** pronto em `materiais-loja/ficha-da-loja.md` (nome, descrições, categoria).
- **Guia de classificação indicativa:** pronto em `materiais-loja/classificacao-indicativa.md` (respostas sugeridas; só o Jansey pode preencher de verdade no Play Console).
- **Convite para testadores do teste fechado:** pronto em `materiais-loja/convite-testadores.md`. Falta colar o link real do Play Console quando o Jansey criar a faixa de teste.
- Build final para envio precisa ser `.aab` (`flutter build appbundle`), não `.apk`.

## Pendente — só o Jansey pode fazer (conta/pagamento/identidade)
- Criar conta Google Play Console (taxa única US$25) + verificação de identidade.
- Recrutar 12–20 testadores para o teste fechado obrigatório (~14 dias) antes de liberar produção.
- Criar conta AdMob com modo de conteúdo infantil ativado + dados bancários.
- Depois disso, o Claude integra o AdMob real no lugar dos placeholders e ajuda a preparar o envio.
