# Transaction API

Uma API simples para gerenciar transações financeiras com suporte a múltiplas moedas, construída em Go com o framework Gin, PostgreSQL e GORM.

## Estrutura do Projeto

Abaixo consta os principais diretórios do projeto. 
Foi usada uma arquitetura comum em projetos Go que segue conceito de Clean Code, Clean Architecture e SOLID.

```
/backend
├── main.go                 # Aplicação principal
├── /internal               # Código interno da API
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

- Docker instalado

## Como executar

1. Clone o repositório
   ```bash
   git clone https://github.com/victorfidelis/go_flutter_transaction_app.git
   ```
2. Abra o docker e o matenha aberto
3. Navegue até o diretório do projeto
   `.\go_flutter_transaction_app`
5. Execute:
   ```bash
   docker-compose up --build -d
   docker-compose up --build
   ```
6. Em testes foi identificado que vez ou outra ocorre um erro na inicialização do postgreSQL. Verifique se a API foi carregada corretamente acessando `http://localhost:8080/transactions`. Se for apresentado `[]` a API está funcionando normalmente. Caso apresente um erro, execute o passo 5 novamente. 
7. API estará disponível em `http://localhost:8080`
8. Para cosultar a documentação da API acesse `http://localhost:8080/swagger/index.html`

<img src="https://github.com/user-attachments/assets/dac6a093-7aaa-4f22-8b2a-475f7cb8f162" width="1000">

## PgAdmin (PostgreSQL) 

1. Para acessar PgAdmin do PostgreSQL acesse `http://localhost:54321/`, informe o email `fideliscorrea.victor@gmail.com` e a senha `pass123`
2. Acesse a linha de comando do container 'postgres' digite `hostname i` e capture o ip apresentado
3. Para acessar o banco pelo pgAdmin informe as seguintes credenciais:
   `hostname: [ip capturado no container postgres]`
   `database: postgres`
   `username: root`
   `senha: pass123`

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

2. **Armazenamento local de transações pendentes**

3. **Detalhes da transação**
   - Visualização completa dos dados
   - Conversão de moeda

4. **Criação de novas transações**
   - Formulário com validação
   - Feedback visual

5. **Gerenciamento de estado**
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

O aplicativo está configurado para acessar a API através do emulador. Caso queria executar em um disposivo físico adicione o IP da máquina em que a API está sendo executada no seguinte arquivo:
```
lib/app/core/config/dio_config.dart
```
Basta alterar o valor da seguinte variável para o IP da máquina em que a API está rodando: 
```
const deviceApiIp = '10.0.2.2'; 
```

## Testes

Para executar os testes:
```bash
flutter test
```

## 🖼️ Capturas de Tela 

<img src="https://github.com/user-attachments/assets/1143f366-16f5-49fc-b4b5-0b3f83742367" width="250">
<img src="https://github.com/user-attachments/assets/7ff4651e-8f8b-43a1-87d1-0f41db54d1dc" width="250">
<img src="https://github.com/user-attachments/assets/b6ba111d-f0ca-4766-a195-55cc12261938" width="250">
<img src="https://github.com/user-attachments/assets/a761212f-eaac-4cde-858d-0c87a10c424d" width="250">

