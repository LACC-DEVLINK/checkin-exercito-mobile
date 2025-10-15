# Estrutura do Projeto

Este projeto segue uma estrutura simples e organizada:

## 📁 Estrutura de Pastas

```
lib/
├── main.dart              # Ponto de entrada da aplicação
├── screens/              # 📱 Todas as telas do app
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── qr_scanner_screen.dart
│   └── ... (outras telas)
├── widgets/              # 🧩 Componentes reutilizáveis
└── utils/                # 🔧 Utilitários e serviços
    ├── mock_authorization_service.dart
    └── websocket_service.dart
```

## 📋 Convenções

- **screens/**: Contém todas as telas/páginas do aplicativo
- **widgets/**: Componentes reutilizáveis que podem ser usados em múltiplas telas
- **utils/**: Serviços, helpers, constantes e utilitários gerais

## Como usar

1. **Telas**: Adicione novas telas na pasta `screens/`
2. **Componentes**: Crie widgets reutilizáveis na pasta `widgets/`
3. **Serviços**: Adicione serviços e utilitários na pasta `utils/`

Esta estrutura mantém o projeto organizado sem complexidade desnecessária.
