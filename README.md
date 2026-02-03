# Tradutor Múltiplo Inteligente

Um aplicativo web simples que permite traduzir um texto de entrada para múltiplos idiomas simultaneamente. Utiliza a API Google Gemini para as traduções e a API de Síntese de Fala (Web Speech API) para produzir áudio das traduções.

> (print)

## Funcionalidades principais

- Tradução múltipla — traduz um único texto para vários idiomas ao mesmo tempo.
- Detecção de idioma — identifica automaticamente o idioma de entrada (opcional).
- Seleção de saída — interface para selecionar múltiplos idiomas de destino.
- Saída de áudio — permite ouvir a pronúncia de cada tradução usando a Web Speech API (SpeechSynthesis).
- Interface responsiva — construída com Tailwind CSS via CDN, funciona bem em desktop e dispositivos móveis.
- Feedback ao usuário — inclui indicadores de carregamento e mensagens de erro claras.

## Tecnologias utilizadas

- HTML5
- Tailwind CSS (via CDN)
- JavaScript (ES6+)
- Google Gemini API (para tradução)
- Web Speech API (SpeechSynthesis) (para reprodução de áudio)

## Como usar

Este projeto é autocontido em um único arquivo `translator.html` e não requer instalação ou um servidor complexo.

1. Clone ou baixe o repositório:
   ```bash
   git clone https://github.com/mgabrielramos/tradutor-multilingue.git
   ```
   Ou apenas baixe o arquivo `translator.html`.

2. Abra o arquivo:
   - Abra `translator.html` diretamente no seu navegador (Chrome, Firefox, Edge, etc.).

3. Usando o app:
   - Selecione o idioma de origem (ou deixe em "Detectar Idioma").
   - Selecione um ou mais idiomas de saída.
   - Digite o texto e clique em "Traduzir".
   - Para ouvir uma tradução, utilize o botão de áudio correspondente (caso implementado).

### Observações importantes
- A funcionalidade de tradução depende da API Google Gemini e requer uma chave de API válida e conexão ativa com a internet.
- A reprodução de áudio depende da Web Speech API, que pode ter diferenças de suporte entre navegadores. Para melhor compatibilidade, use navegadores atualizados (Chrome/Edge baseados em Chromium geralmente têm suporte mais completo).

## Exemplo de integração com a API (orientação)
- No arquivo `translator.html` você deve configurar onde a chamada à Google Gemini é feita (por exemplo, via fetch para seu backend que contém a chave da API).
- Nunca exponha sua chave da API em código cliente (front-end). Sempre encaminhe requisições de tradução por um servidor seguro que armazene a chave.

## Próximos passos para publicação na Play Store
Este projeto começou como um app web simples. Para torná-lo profissional e pronto para venda, siga os guias abaixo:

- **Flutter (app nativo)**: guia de migração, arquitetura e estrutura recomendada. Veja `docs/FLUTTER.md`.
- **Backend seguro**: referência para proteger a chave da API, autenticação e rate limiting. Veja `docs/BACKEND.md`.
- **Políticas legais (LGPD/Play Store)**: modelos e checklist. Veja `docs/LEGAL.md`.
- **Monetização Freemium**: sugestões de planos e limites. Veja `docs/MONETIZATION.md`.
- **Roadmap profissional**: sequência sugerida para evoluir o produto. Veja `docs/ROADMAP.md`.

## Implementação inicial (Flutter + Backend)
Foram adicionadas bases mínimas para começar a implementação:

- **Backend Node.js**: `backend/` (Express, JWT, rate limiting, endpoints de autenticação e tradução).
- **App Flutter**: `mobile/` (tela principal com tradução e indicação de uso do plano).
- **Políticas legais**: `legal/` (templates de Termos e Política de Privacidade).

### Como rodar o backend
1. `cd backend`
2. `cp .env.example .env` e configure as variáveis.
3. `npm install`
4. `npm run dev`

## Compatibilidade de navegadores
- Chrome, Edge (Chromium) — recomendado.
- Firefox — suporta a maior parte da funcionalidade, mas teste a síntese de fala.
- Safari — verificar suporte à Web Speech API em versões recentes.

## Contribuindo
Contribuições são bem-vindas. Você pode:
- Abrir issues para reportar bugs ou pedir funcionalidades.
- Enviar pull requests com correções ou melhorias.
- Adicionar traduções, testes, ou melhorar a interface.

Siga o fluxo usual:
1. Fork do repositório
2. Crie uma branch com a sua feature (`git checkout -b minha-feature`)
3. Faça commits descritivos
4. Abra um Pull Request explicando suas mudanças

## Licença
Projeto open source — sinta-se à vontade para usar, modificar e distribuir como desejar.

```

