package services

import (
	"backend/internal/app/models"
	"errors"
	"testing"
	"time"
)

func TestValidateTransaction(t *testing.T) {
	now := time.Now()

	tests := []struct {
		name        string
		transaction models.Transaction
		wantErr     error
	}{
		{
			name: "Transação válida",
			transaction: models.Transaction{
				Description: "Compra de materiais",
				Date:        now,
				Amount:      100.50,
			},
			wantErr: nil,
		},
		{
			name: "Descrição vazia",
			transaction: models.Transaction{
				Description: "",
				Date:        now,
				Amount:      100.50,
			},
			wantErr: errors.New("description is required"),
		},
		{
			name: "Descrição com espaços em branco",
			transaction: models.Transaction{
				Description: "   ",
				Date:        now,
				Amount:      100.50,
			},
			wantErr: errors.New("description is required"),
		},
		{
			name: "Descrição muito longa",
			transaction: models.Transaction{
				Description: "Esta descrição é claramente muito longa para ser aceita pelo nosso validador de transações",
				Date:        now,
				Amount:      100.50,
			},
			wantErr: errors.New("description must be less than 50 characters"),
		},
		{
			name: "Data não informada",
			transaction: models.Transaction{
				Description: "Compra de materiais",
				Date:        time.Time{}, // zero value
				Amount:      100.50,
			},
			wantErr: errors.New("date is required"),
		},
		{
			name: "Valor zero",
			transaction: models.Transaction{
				Description: "Compra de materiais",
				Date:        now,
				Amount:      0,
			},
			wantErr: errors.New("amount must be greater than zero"),
		},
		{
			name: "Valor negativo",
			transaction: models.Transaction{
				Description: "Compra de materiais",
				Date:        now,
				Amount:      -50.25,
			},
			wantErr: errors.New("amount must be greater than zero"),
		},
		{
			name: "Descrição no limite de caracteres",
			transaction: models.Transaction{
				Description: "Esta descrição tem exatamente 50 caracteres!!",
				Date:        now,
				Amount:      100.50,
			},
			wantErr: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := ValidateTransaction(&tt.transaction)

			// Verifica se ambos são nil
			if err == nil && tt.wantErr == nil {
				return
			}

			// Verifica se um é nil e o outro não
			if (err == nil) != (tt.wantErr == nil) {
				t.Errorf("ValidateTransaction() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			// Verifica a mensagem de erro
			if err != nil && err.Error() != tt.wantErr.Error() {
				t.Errorf("ValidateTransaction() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestValidateTransaction_Trimming(t *testing.T) {
	t.Run("Remove espaços em branco da descrição", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "   Compra de materiais   ",
			Date:        time.Now(),
			Amount:      100.50,
		}

		err := ValidateTransaction(&transaction)
		if err != nil {
			t.Fatalf("ValidateTransaction() retornou erro inesperado: %v", err)
		}

		if transaction.Description != "Compra de materiais" {
			t.Errorf("Espaços em branco não foram removidos corretamente, got: '%s'", transaction.Description)
		}
	})
}

// MockTransactionRepository simplificado
type MockTransactionRepository struct {
	CreateTransactionFunc  func(*models.Transaction) error
	GetTransactionByIDFunc func(id int) (models.Transaction, error)
	GetAllTransactionsFunc func() ([]models.Transaction, error)
}

func (m *MockTransactionRepository) CreateTransaction(t *models.Transaction) error {
	return m.CreateTransactionFunc(t)
}

func (m *MockTransactionRepository) GetTransactionByID(id int) (models.Transaction, error) {
	return m.GetTransactionByIDFunc(id)
}

func (m *MockTransactionRepository) GetAllTransactions() ([]models.Transaction, error) {
	return m.GetAllTransactionsFunc()
}

func TestCreateTransaction(t *testing.T) {
	now := time.Now()
	validTransaction := models.Transaction{
		Description: "Compra válida",
		Date:        now,
		Amount:      100.50,
	}

	tests := []struct {
		name         string
		mockBehavior func(*MockTransactionRepository)
		expectedErr  error
	}{
		{
			name: "Sucesso ao criar transação",
			mockBehavior: func(m *MockTransactionRepository) {
				m.CreateTransactionFunc = func(t *models.Transaction) error {
					return nil
				}
			},
			expectedErr: nil,
		},
		{
			name: "Erro no repositório",
			mockBehavior: func(m *MockTransactionRepository) {
				m.CreateTransactionFunc = func(t *models.Transaction) error {
					return errors.New("erro no banco")
				}
			},
			expectedErr: errors.New("erro no banco"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockRepo := &MockTransactionRepository{}
			tt.mockBehavior(mockRepo)

			service := NewTransactionService(mockRepo)
			err := service.CreateTransaction(&validTransaction)

			if (err != nil) != (tt.expectedErr != nil) {
				t.Errorf("erro = %v, esperado %v", err, tt.expectedErr)
				return
			}

			if err != nil && tt.expectedErr != nil && err.Error() != tt.expectedErr.Error() {
				t.Errorf("erro = %v, esperado %v", err, tt.expectedErr)
			}
		})
	}
}

func TestGetTransactionByID(t *testing.T) {
	now := time.Now()
	validID := 123
	invalidID := 999

	sampleTransaction := models.Transaction{
		Id:          validID,
		Description: "Compra de teste",
		Date:        now,
		Amount:      100.50,
	}

	tests := []struct {
		name        string
		setupMock   func(*MockTransactionRepository)
		inputID     int
		expected    models.Transaction
		expectedErr error
	}{
		{
			name: "Sucesso - Transação encontrada",
			setupMock: func(m *MockTransactionRepository) {
				m.GetTransactionByIDFunc = func(id int) (models.Transaction, error) {
					if id == validID {
						return sampleTransaction, nil
					}
					return models.Transaction{}, errors.New("não encontrado")
				}
			},
			inputID:     validID,
			expected:    sampleTransaction,
			expectedErr: nil,
		},
		{
			name: "Erro - Transação não encontrada",
			setupMock: func(m *MockTransactionRepository) {
				m.GetTransactionByIDFunc = func(id int) (models.Transaction, error) {
					return models.Transaction{}, errors.New("não encontrado")
				}
			},
			inputID:     invalidID,
			expected:    models.Transaction{},
			expectedErr: errors.New("não encontrado"),
		},
		{
			name: "Erro - ID vazio",
			setupMock: func(m *MockTransactionRepository) {
				m.GetTransactionByIDFunc = func(id int) (models.Transaction, error) {
					if id == 0 {
						return models.Transaction{}, errors.New("ID inválido")
					}
					return sampleTransaction, nil
				}
			},
			inputID:     0,
			expected:    models.Transaction{},
			expectedErr: errors.New("ID inválido"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Arrange
			mockRepo := &MockTransactionRepository{}
			tt.setupMock(mockRepo)
			service := NewTransactionService(mockRepo)

			// Act
			result, err := service.GetTransactionByID(tt.inputID)

			// Assert - Verifica o erro
			if (err != nil) != (tt.expectedErr != nil) {
				t.Errorf("Erro retornado: %v, esperado: %v", err, tt.expectedErr)
				return
			}

			if err != nil && tt.expectedErr != nil && err.Error() != tt.expectedErr.Error() {
				t.Errorf("Mensagem de erro: %q, esperado: %q", err.Error(), tt.expectedErr.Error())
			}

			// Assert - Verifica o resultado
			if result.Id != tt.expected.Id ||
				result.Description != tt.expected.Description ||
				!result.Date.Equal(tt.expected.Date) ||
				result.Amount != tt.expected.Amount {
				t.Errorf("Resultado: %+v, esperado: %+v", result, tt.expected)
			}
		})
	}
}
