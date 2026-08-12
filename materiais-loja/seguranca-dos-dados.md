# Formulário "Segurança dos dados" (Data Safety) — guia de respostas

Esse é um formulário SEPARADO da classificação indicativa, também obrigatório,
em: Play Console → seu app → Presença na loja → Segurança dos dados.
Baseado exatamente no que o Espertinhos faz (login anônimo + Firestore,
sem anúncios ainda).

## Pergunta inicial

**"Seu app coleta ou compartilha algum dos tipos de dados do usuário
listados?"** → **Sim** (o app guarda faixa etária e pontuação na nuvem)

## Tipos de dados a marcar como coletados

Percorra a lista de categorias do Google e marque **apenas**:

### "ID do dispositivo ou outros IDs"
- Coletado: **Sim**
- Compartilhado com terceiros: **Não**
- Finalidade: **Funcionalidade do app**
- É opcional ou obrigatório: **Obrigatório** (o app não funciona sem salvar o progresso)
- (Esse é o identificador anônimo criado pelo Firebase Authentication —
  não tem nome, e-mail nem nada que identifique a pessoa.)

### "Atividade no app" → "Outra atividade no app do usuário"
- Coletado: **Sim** (a faixa etária escolhida e as estrelas/pontuação de cada jogo)
- Compartilhado com terceiros: **Não**
- Finalidade: **Funcionalidade do app**
- Obrigatório: **Sim**

## TODAS as outras categorias

Marque **"Não coletado"** para todas as demais: Localização, Informações
pessoais (nome/e-mail/endereço/telefone), Informações financeiras, Saúde e
condicionamento físico, Mensagens, Fotos e vídeos, Áudio, Arquivos e
documentos, Calendário, Contatos, Navegação na web, Informações e
desempenho do app.

## Perguntas de segurança (aparecem depois de listar os tipos)

- **"Os dados são criptografados em trânsito?"** → **Sim** (o Firebase usa
  HTTPS/TLS por padrão, isso é automático)
- **"Você oferece uma forma do usuário solicitar a exclusão dos dados?"**
  → **Sim** — explique que o pedido pode ser feito por e-mail
  (janseysilva@gmail.com), conforme a Política de Privacidade
- **"Os dados foram enviados para revisão de segurança independente?"**
  → **Não** (normal pra um app pequeno/independente, não impede a publicação)

## Resumo que vai aparecer pro usuário na ficha da loja

Depois de preencher, o Google mostra automaticamente algo como:
"Este app pode coletar esses tipos de dados: ID do dispositivo, atividade
no app. Os dados são criptografados em trânsito. Você pode solicitar a
exclusão dos dados." — isso é exatamente o esperado e bate com a Política
de Privacidade já escrita.

## Quando os anúncios (AdMob) forem ativados no futuro

Essa seção do Play Console vai precisar ser **atualizada de novo** —
adicionar "Publicidade ou marketing" como finalidade e declarar o AdMob
como terceiro que recebe dados (mesmo no modo infantil/sem personalização).
Lembre de avisar quando chegar nessa etapa pra eu te ajudar a revisar.
