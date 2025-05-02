# Transaction API

Uma API simples para gerenciar transações financeiras com suporte a múltiplas moedas, construída em Go com o framework Gin e PostgreSQL.

## Estrutura do Projeto

Abaixo consta os principais diretórios do projeto. 
Foi usada uma arquitetura comum em projetos Go que segue conceito de Clean Code, Clean Architecture e SOLID.

```
/backend
├── /cmd                    # Ponto de entrada da aplicação 
│   └── /app                # Aplicação principal (`main.go`)
├── /internal               # Código interno (não importável por outros projetos)
│   ├── /app                # Lógica da aplicação (regras de negócio)
│   │   ├── /handlers       # HTTP handlers
│   │   ├── /routes         # Definição de rotas
│   │   ├── /services       # Lógica de negócios
│   │   └── /models         # Modelos (structs)
│   ├── /pkg                # Código compartilhado internamente
│   │   └── /exchange       # Client para consulta de taxas de câmbio
│   └── /repository         # Camada de persistência (banco de dados)
├── /pkg                    # Código importável por outros projetos
│   ├── /config             # Configurações
│   └── /utils              # Funções utilitárias
├── /api                    # Arquivos de API
├── go.mod                  # Gerenciamento de dependências
├── go.sum                  
└── README.md               
```

## Endpoints

### Listar todas as transações

**GET** `/transactions`

Retorna uma lista de todas as transações.

Exemplo de resposta:
```json
[
    {
        "id": 1,
        "description": "Transacao 1",
        "date": "2025-05-01T00:00:00Z",
        "amount": 81
    },
    ...
]
```

### Obter uma transação específica

**GET** `/transactions/{id}`

Retorna os detalhes de uma transação específica.

Exemplo de resposta:
```json
{
    "id": 12,
    "description": "test p",
    "date": "2025-05-01T00:00:00Z",
    "amount": 8547
}
```

### Obter uma transação com conversão de moeda

**GET** `/transactions/{id}/{currency}`

Retorna os detalhes de uma transação com o valor convertido para a moeda especificada.

Exemplo de resposta:
```json
{
    "id": 10,
    "description": "Test Transacao 50",
    "date": "2025-05-01T00:00:00Z",
    "original_value": 50,
    "country": "Austria",
    "currency": "Euro",
    "exchange_rate": 0.924,
    "converted_value": 46.2,
    "effective_date": "2025-03-31T00:00:00Z"
}
```

### Criar uma nova transação

**POST** `/transactions`

Cria uma nova transação.

Exemplo de corpo da requisição:
```json
{
    "description": "Transação 5",
    "date": "2025-04-26T14:04:05Z",
    "amount": 600.889
}
```

## Pré-requisitos

- Docker e Docker Compose instalados

## Como executar

1. Clone o repositório
2. Abra o docker e o matenha aberto
3. Navegue até o diretório do projeto
4. Execute:
   ```bash
   docker-compose up --build
   ```
5. A API estará disponível em `http://localhost:8080`

## Variáveis de Ambiente

O arquivo `.env` já consta na aplicação para facilitar os testes:

## Testes

Para executar os testes:

```bash
go test ./...
```


# Aplicativo Flutter - Gerenciamento de Transações Financeiras

## Visão Geral
Aplicativo mobile desenvolvido em Flutter para gerenciamento de transações financeiras, conectado à API backend em Go. A aplicação segue os princípios de Clean Architecture, SOLID e Clean Code, utilizando MobX para gerenciamento de estado e Flutter Modular para injeção de dependências e roteamento.

## Estrutura do Projeto

```
/frontend
└── /lib                    
    ├── main.dart                      # Ponto de entrada da aplicação
    └── /app                           # Núcleo da aplicação
        ├── /core                      # Recursos compartilhados
        │   ├── /config                # Configurações gerais
        │   ├── /constants             # Constantes da aplicação
        │   ├── /errors                # Classes de erro personalizadas
        │   ├── /result                # Modelo de resultado padronizado
        │   ├── /services              # Serviços globais
        │   ├── /utils                 # Utilitários
        │   └── /widgets               # Widgets reutilizáveis
        └── /modules                   # Módulos da aplicação
            └── /transaction           # Módulo de transações
                ├── /domain            # Camada de domínio
                │   ├── /entities      # Entidades do negócio
                │   ├── /repository    # Contratos de repositório
                │   ├── /usecases      # Casos de uso
                │   └── /errors        # Erros específicos do domínio
                ├── /data              # Camada de dados
                │   ├── /models        # Modelos de dados
                │   ├── /datasources   # Fontes de dados (local/remoto)
                │   └── /repository    # Implementação dos repositórios
                └── /presentation      # Camada de apresentação
                    ├── /store         # Stores MobX
                    ├── /views         # Páginas/componentes
                    └── /widgets       # Widgets específicos do módulo
```

## Tecnologias e Padrões Utilizados

- **Flutter**: Framework para desenvolvimento multiplataforma
- **MobX**: Gerenciamento de estado reativo
- **Flutter Modular**: Injeção de dependências e roteamento
- **Clean Architecture**: Separação em camadas (domain, data, presentation)
- **SOLID**: Princípios de design de software
- **Repository Pattern**: Padrão para acesso a dados
- **Dependency Injection**: Inversão de controle

## Funcionalidades

1. **Listagem de transações**

2. **Detalhes da transação**
   - Visualização completa dos dados
   - Conversão de moeda

3. **Criação de novas transações**
   - Formulário com validação
   - Feedback visual

4. **Gerenciamento de estado**
   - Atualização em tempo real
   - Tratamento de erros

## Configuração do Ambiente

### Pré-requisitos

- Flutter SDK 
- Dart SDK 
- Emulador Android configurado

### Como Executar

1. Clone o repositório:
   ```bash
   git clone https://github.com/victorfidelis/go_flutter_transaction_app.git
   ```

2. Navegue até o diretório do projeto:
   ```bash
   cd frontend
   ```

3. Instale as dependências:
   ```bash
   flutter pub get
   ```

4. Execute o aplicativo:
   ```bash
   flutter run
   ```

## Configuração da API

O aplicativo está configurado para sempre utilizar a rede local através do emulador. Caso precise alterar esse dado acesse:
```
lib/app/core/config/api_config.dart
```

## Testes

Para executar os testes:
```bash
flutter test
```

