package services_test

import (
	"backend/internal/app/models"
	services "backend/internal/app/services/transaction"
	"backend/internal/test/mocks"
	"errors"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestValidateTransaction(t *testing.T) {
	now := time.Now()

	t.Run("Transação válida", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "Compra de materiais",
			Date:        now,
			Amount:      100.50,
		}
		assert.NoError(t, services.ValidateTransaction(&transaction), "nenhum erro esperado")
	})

	t.Run("Descrição vazia", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "",
			Date:        now,
			Amount:      100.50,
		}
		wantErr := errors.New("description is required")

		err := services.ValidateTransaction(&transaction)
		assert.Error(t, err, "Esperado erro")
		assert.Equal(t, wantErr.Error(), err.Error(), "descrição do erro não corresponde")
	})

	t.Run("Descrição com espaços em branco", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "   ",
			Date:        now,
			Amount:      100.50,
		}
		wantErr := errors.New("description is required")

		err := services.ValidateTransaction(&transaction)
		assert.Error(t, err, "Esperado erro")
		assert.Equal(t, wantErr.Error(), err.Error(), "descrição em branco não foi tratada corretamente")
	})

	t.Run("Descrição muito longa", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "Esta descrição é claramente muito longa para ser aceita pelo nosso validador de transações",
			Date:        now,
			Amount:      100.50,
		}
		wantErr := errors.New("description must be less than 50 characters")

		err := services.ValidateTransaction(&transaction)
		assert.Error(t, err, "Esperado erro")
		assert.Equal(t, wantErr.Error(), err.Error(), "descrição muito longa não foi tratada corretamente")
	})

	t.Run("Data não informada", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "Compra de materiais",
			Date:        time.Time{}, // zero value
			Amount:      100.50,
		}
		wantErr := errors.New("date is required")

		err := services.ValidateTransaction(&transaction)
		assert.Error(t, err, "Esperado erro")
		assert.Equal(t, wantErr.Error(), err.Error(), "data não informada não foi tratada corretamente")
	})

	t.Run("Valor zero", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "Compra de materiais",
			Date:        now,
			Amount:      0,
		}
		wantErr := errors.New("amount must be greater than zero")

		err := services.ValidateTransaction(&transaction)
		assert.Error(t, err, "Esperado erro")
		assert.Equal(t, wantErr.Error(), err.Error(), "valor zero não foi tratado corretamente")
	})

	t.Run("Valor negativo", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "Compra de materiais",
			Date:        now,
			Amount:      -50.25,
		}
		wantErr := errors.New("amount must be greater than zero")

		err := services.ValidateTransaction(&transaction)
		assert.Error(t, err, "Esperado erro")
		assert.Equal(t, wantErr.Error(), err.Error(), "valor negativo não foi tratado corretamente")
	})

	t.Run("Descrição no limite de caracteres", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "Esta descricao possui 50 caracteres o limite......",
			Date:        now,
			Amount:      100.50,
		}
		fmt.Println(len(transaction.Description))
		assert.NoError(t, services.ValidateTransaction(&transaction), "nenhum erro esperado")
	})

	t.Run("Remove espaços em branco da descrição", func(t *testing.T) {
		transaction := models.Transaction{
			Description: "   Compra de materiais   ",
			Date:        time.Now(),
			Amount:      100.50,
		}

		wantDescription := "Compra de materiais"
		assert.NoError(t, services.ValidateTransaction(&transaction), "nenhum erro esperado")
		assert.Equal(t, wantDescription, transaction.Description, "Espaços em branco não foram removidos corretamente")
	})
}

func TestCreateTransaction(t *testing.T) {
	now := time.Now()
	validTransaction := models.Transaction{
		Description: "Compra válida",
		Date:        now,
		Amount:      100.50,
	}

	t.Run("Sucesso ao criar transação", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)

		mockRepo.On("CreateTransaction", &validTransaction).Return(nil)

		err := service.CreateTransaction(&validTransaction)

		assert.NoError(t, err, "nenhum erro esperado")
	})

	t.Run("Erro no repositório", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)
		wantErr := errors.New("erro no banco")

		mockRepo.On("CreateTransaction", &validTransaction).Return(wantErr)

		err := service.CreateTransaction(&validTransaction)

		assert.Equal(t, wantErr, err, "erro esperado")
	})
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

	t.Run("Sucesso ao buscar transação por ID", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)

		mockRepo.On("GetTransactionByID", validID).Return(sampleTransaction, nil)

		result, err := service.GetTransactionByID(validID)

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Equal(t, sampleTransaction, result, "resultado não corresponde ao esperado")
	})

	t.Run("Erro ao buscar transação por ID", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)
		wantErr := errors.New("transação não encontrada")

		mockRepo.On("GetTransactionByID", invalidID).Return(models.Transaction{}, wantErr)

		_, err := service.GetTransactionByID(invalidID)
		assert.Error(t, err, "erro esperado")
		assert.Equal(t, wantErr.Error(), err.Error(), "mensagem de erro não corresponde")
	})

	t.Run("Erro ao buscar transação com ID vazio", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)
		wantErr := errors.New("ID inválido")

		mockRepo.On("GetTransactionByID", 0).Return(models.Transaction{}, wantErr)

		_, err := service.GetTransactionByID(0)
		assert.Error(t, err, "erro esperado")
		assert.Equal(t, wantErr.Error(), err.Error(), "mensagem de erro não corresponde")
	})
}

func TestGetAllTransactions(t *testing.T) {
	now := time.Now()
	transactions := []models.Transaction{
		{
			Id:          1,
			Description: "Transação 1",
			Date:        now,
			Amount:      100.50,
		},
		{
			Id:          2,
			Description: "Transação 2",
			Date:        now.Add(24 * time.Hour),
			Amount:      200.75,
		},
	}

	t.Run("Sucesso ao buscar múltiplas as transações", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)

		mockRepo.On("GetAllTransactions").Return(transactions, nil)

		result, err := service.GetAllTransactions()

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Equal(t, len(transactions), len(result), "resultado não corresponde ao esperado")
	})

	t.Run("Sucesso ao buscar lista vazia de transações", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)

		mockRepo.On("GetAllTransactions").Return([]models.Transaction{}, nil)

		result, err := service.GetAllTransactions()

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Empty(t, result, "resultado não deve conter transações")
	})

	t.Run("Erro ao buscar transações", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		service := services.NewTransactionServiceImpl(mockRepo)
		wantErr := errors.New("erro ao buscar transações")

		mockRepo.On("GetAllTransactions").Return([]models.Transaction{}, wantErr)

		_, err := service.GetAllTransactions()
		assert.Error(t, err, "erro esperado")
		assert.Equal(t, wantErr.Error(), err.Error(), "mensagem de erro não corresponde")
	})
}
