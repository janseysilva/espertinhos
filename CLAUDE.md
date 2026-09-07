# Contexto do projeto Espertinhos — leia antes de começar

Jansey usa dois PCs diferentes; a memória do Claude Code é local a cada máquina. Este arquivo sincroniza junto com o código (via GitHub/OneDrive), então é a forma de continuar de onde parou em qualquer um dos dois. Ver também `README.md` nesta mesma pasta (instruções de ambiente/toolchain) e o `CLAUDE.md` da pasta `OneDrive\trabalhos jansey` (contexto dos outros projetos do Jansey).

**Instrução para o Claude:** sempre que um trabalho relevante for concluído aqui, atualize este arquivo antes de encerrar a conversa. **Este arquivo ficou 3 semanas sem atualização (11/08 a 07/09)** enquanto o código avançou bastante no outro PC — antes de descrever o status pro Jansey, rode `git log` e compare com o que está escrito aqui, não confie cegamente nesta seção.

## O que é
App educativo infantil "Espertinhos" — 15 jogos: os 12 originais (Cores e Formas, Contando, Memória, Alfabeto, Matemática, Sequência, Pintar, Ache o Diferente, Maior ou Menor, Opostos, Caça-Palavras, Quebra-cabeça) + Labirinto, Sons dos Bichos, e o jogo especial "Família" (desbloqueado ao juntar 1000 estrelas). Mascote coelhinho 🐰, 3 faixas etárias (2-4/5-6/7-8 anos), sistema de estrelas, trava dos responsáveis por múltipla escolha, narração por voz (TTS) em todos os jogos/idades, nome da criança capturado no início.

**Stack definitivo (decidido 2026-08-11):** Flutter + Firebase (login anônimo via Firebase Auth, dados na nuvem via Cloud Firestore, projeto Firebase `espertinhos-app-2026`). A versão antiga em HTML/JS/PWA (pasta `app-educativo-kids` dentro de `trabalhos jansey`) está **descontinuada** — não retomar sem o Jansey pedir.

## Status atual (2026-09-07)
- Versão do código: **1.3.0+4**. App completo, testado (teste interno + teste fechado "alpha" no Play Console), com anúncios reais do AdMob (obrigatórios após cada fase) e compra "remover anúncios" via in-app purchase.
- Firebase conectado de verdade (login anônimo + Firestore).
- **App enviado para revisão de produção do Google Play em 2026-09-07**, disponibilidade limitada ao **Brasil**. Revisão costuma levar até 7 dias, pode demorar mais. Conferir o painel antes de assumir o status: https://play.google.com/console/u/1/developers/6269272435347218782/app/4975464292977682277/app-dashboard
- Conta Google Play Console e conta AdMob **já existem e já estão configuradas** — não são mais pendências.

## Rumo à publicação na Google Play — checklist
- **Política de Privacidade:** escrita e publicada. Artifact: https://claude.ai/code/artifact/fd100547-577c-4254-9a2a-2dea75f1a5d4 — contato Jansey Silva / janseysilva@gmail.com.
- **Ícone do app:** feito — emoji real 🐰 recortado sobre o degradê do app, ícone legado + adaptativo (Android 8+). Ícone 512x512 em `materiais-loja/icone_playstore_512.png`.
- **Guia "Segurança dos Dados" (Data Safety):** pronto em `materiais-loja/seguranca-dos-dados.md`.
- **Capturas de tela (5) e imagem de destaque (1024x500):** em `materiais-loja/capturas-tela/` e `materiais-loja/feature_graphic.jpg` — ainda são recriações via HTML/Canvas, **não** screenshots reais do app rodando. Trocar pelas reais quando possível (não bloqueia a revisão do Google, mas fica melhor).
- **Texto da ficha da loja:** pronto em `materiais-loja/ficha-da-loja.md`.
- **Guia de classificação indicativa:** pronto em `materiais-loja/classificacao-indicativa.md`.
- **Convite para testadores do teste fechado:** pronto em `materiais-loja/convite-testadores.md`, com link real do Play Console preenchido.
- Build usada na promoção pra produção foi o App Bundle (`.aab`) gerado automaticamente pelo Play Console a partir da build 4 (1.3.0) do teste fechado — não precisou gerar manualmente.

## Pendente
- Acompanhar o resultado da revisão do Google (aprovação, rejeição ou pedido de ajuste).
- Trocar as capturas de tela da loja pelas reais do app rodando, quando for conveniente.
- Considerar expandir a disponibilidade pra outros países além do Brasil, se o Jansey quiser.

## Notas operacionais importantes (aprendidas em 2026-08-23 e 2026-09-07)
- **A pasta local `OneDrive\Documentos\projetoAppEspertinhos` já ficou desatualizada em relação ao GitHub duas vezes** (uma vez ~10 dias, outra ~12 dias), porque o trabalho de verdade costuma acontecer no outro PC do Jansey e o OneDrive não é confiável pra sincronizar isso sozinho. **Sempre rodar `git fetch` e comparar `git log -1 origin/main` com o local no início de uma sessão**, mesmo que este arquivo pareça atualizado.
- Nunca colocar este projeto em uma pasta com espaços ou acentos no caminho (ex.: "Área de Trabalho") — o compilador de shaders do Android quebra nesses casos.
