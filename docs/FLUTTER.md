# Flutter: estrutura recomendada

## Arquitetura
- Clean Architecture ou MVVM.
- Separar **camadas**: `data`, `domain`, `presentation`.
- Injeção de dependências (get_it ou riverpod).

## Pastas sugeridas
```
lib/
  core/
  data/
  domain/
  presentation/
```

## Pacotes úteis
- `flutter_bloc` ou `riverpod` (estado)
- `dio` (HTTP)
- `freezed` (modelos)
- `go_router` (rotas)
- `intl` (i18n)

## Telas essenciais
- Home (entrada + resultados)
- Histórico
- Favoritos
- Configurações (tema, idiomas)
- Sobre/Políticas

## UX/UI profissional
- Tema claro/escuro.
- Layout responsivo para tablets.
- Feedback de carregamento e erros claros.
- Acessibilidade (tamanho de fonte, contraste, labels).
