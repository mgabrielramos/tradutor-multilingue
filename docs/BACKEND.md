# Backend seguro (Gemini API)

Este guia descreve a arquitetura mínima para proteger a chave da API e operar em produção.

## Arquitetura recomendada
- **App Flutter → API** (HTTPS)
- **API → Google Gemini** (server-to-server)
- **Banco** (Postgres ou Firebase) para usuários, planos e histórico

## Requisitos mínimos
- **Chave da API em variáveis de ambiente** (nunca no app).
- **Rate limiting** por usuário/IP.
- **Autenticação** (JWT + refresh token).
- **Logs** estruturados e monitoração (Sentry/Datadog).

## Endpoints sugeridos
- `POST /v1/translate`
  - Entrada: texto, idioma origem, idiomas destino
  - Saída: traduções + metadados
- `POST /v1/speech`
  - Opcional: TTS server-side, se você não usar a Web Speech API no device

## Segurança e compliance
- Validar tamanho de input e língua suportada.
- Sanitizar texto para evitar abuso.
- Bloquear uso automatizado (CAPTCHA invisível ou heurísticas).

## Observações Play Store
Evite expor a API diretamente do app. A Play Store penaliza apps que vazam chaves ou abusam de serviços externos.
