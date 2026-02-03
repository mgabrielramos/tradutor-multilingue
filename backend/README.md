# Backend seguro

## Setup rápido
1. Copie `.env.example` para `.env`.
2. Instale dependências: `npm install`.
3. Rode localmente: `npm run dev`.

## Endpoints
- `POST /v1/auth/anonymous`
- `POST /v1/translate`
- `GET /health`

## Notas
- O endpoint de tradução usa um stub quando `GEMINI_API_KEY` não está configurado.
