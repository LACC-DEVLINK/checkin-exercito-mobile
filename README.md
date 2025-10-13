# CheckIn Exército - Mobile App

Aplicativo móvel Flutter para sistema de check-in militar com funcionalidades de autenticação, scanner QR Code, dashboard de participantes e relatórios.

## Funcionalidades

- **Autenticação**: Sistema de login e cadastro de usuários
- **Scanner QR Code**: Leitura de códigos QR para check-in
- **Dashboard**: Visão geral de participantes e estatísticas
- **Lista de Participantes**: Gerenciamento e visualização de participantes
- **Relatórios**: Geração e visualização de relatórios
- **Perfil do Usuário**: Gerenciamento de perfil e configurações

## Como Rodar o Projeto

### Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Flutter SDK** (versão 3.9.2 ou superior)
- **Dart SDK** (incluído com Flutter)
- **Android Studio** ou **VS Code** com extensões Flutter
- **Android SDK** para desenvolvimento Android
- **Xcode** (apenas para macOS, desenvolvimento iOS)

### Verificar Instalação

```bash
flutter doctor
```

### Configuração do Projeto

#### 1. **Clonar o Repositório**

**Opção 1: Usando HTTPS**
```bash
git clone https://github.com/LACC-DEVLINK/checkin-exercito-mobile.git
```

**Opção 2: Usando SSH (recomendado se você tem chave SSH configurada)**
```bash
git clone git@github.com:LACC-DEVLINK/checkin-exercito-mobile.git
```

#### 2. **Navegar até o Projeto**

Após clonar, navegue até a pasta do projeto:
```bash
cd checkin-exercito-mobile
```

#### 3. **Instalar Dependências**

Execute o comando para baixar todas as dependências do projeto:
```bash
flutter pub get
```

#### 4. **Limpeza (se necessário)**

Se encontrar problemas de cache ou dependências:
```bash
flutter clean
flutter pub get
```

### Verificação da Configuração

Antes de executar o projeto, verifique se tudo está configurado corretamente:

```bash
# Verificar se o Flutter está funcionando
flutter doctor

# Verificar dependências do projeto
flutter pub deps

# Analisar possíveis problemas no código
flutter analyze
```

### Executando o Projeto

#### Usando um Dispositivo Android/iOS Conectado

1. **Conecte seu dispositivo via USB** e habilite a depuração USB

2. **Verifique se o dispositivo foi detectado**
   ```bash
   flutter devices
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

#### Usando Emulador

1. **Inicie um emulador Android** através do Android Studio ou via linha de comando

2. **Execute o aplicativo**
   ```bash
   flutter run
   ```
