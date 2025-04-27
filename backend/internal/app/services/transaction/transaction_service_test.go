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
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)

		mockRepo.On("CreateTransaction", &validTransaction).Return(nil)

		err := service.CreateTransaction(&validTransaction)

		assert.NoError(t, err, "nenhum erro esperado")
	})

	t.Run("Erro no repositório", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)
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
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)

		mockRepo.On("GetTransactionByID", validID).Return(sampleTransaction, nil)

		result, err := service.GetTransactionByID(validID)

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Equal(t, sampleTransaction, result, "resultado não corresponde ao esperado")
	})

	t.Run("Erro ao buscar transação por ID", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)
		wantErr := errors.New("transação não encontrada")

		mockRepo.On("GetTransactionByID", invalidID).Return(models.Transaction{}, wantErr)

		_, err := service.GetTransactionByID(invalidID)
		assert.Error(t, err, "erro esperado")
		assert.Equal(t, wantErr.Error(), err.Error(), "mensagem de erro não corresponde")
	})

	t.Run("Erro ao buscar transação com ID vazio", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)
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
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)

		mockRepo.On("GetAllTransactions").Return(transactions, nil)

		result, err := service.GetAllTransactions()

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Equal(t, len(transactions), len(result), "resultado não corresponde ao esperado")
	})

	t.Run("Sucesso ao buscar lista vazia de transações", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)

		mockRepo.On("GetAllTransactions").Return([]models.Transaction{}, nil)

		result, err := service.GetAllTransactions()

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Empty(t, result, "resultado não deve conter transações")
	})

	t.Run("Erro ao buscar transações", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchange := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchange)
		wantErr := errors.New("erro ao buscar transações")

		mockRepo.On("GetAllTransactions").Return([]models.Transaction{}, wantErr)

		_, err := service.GetAllTransactions()
		assert.Error(t, err, "erro esperado")
		assert.Equal(t, wantErr.Error(), err.Error(), "mensagem de erro não corresponde")
	})
}

func TestGetTransactionWithExchangeByID(t *testing.T) {

	mockTransaction := models.Transaction{
		Id:          1,
		Description: "Compra internacional",
		Date:        time.Date(2023, 10, 1, 0, 0, 0, 0, time.UTC),
		Amount:      200.00,
	}

	mockExchange := models.Exchange{
		RecordDate:          "2023-10-01",
		Country:             "Brazil",
		Currency:            "Real",
		CountryCurrencyDesc: "Brazil-Real",
		ExchangeRate:        "5.0",
		EffectiveDate:       "2023-10-01",
	}

	t.Run("Sucesso ao buscar transação com câmbio", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchangeClient := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchangeClient)

		mockRepo.On("GetTransactionByID", mockTransaction.Id).Return(mockTransaction, nil)
		mockExchangeClient.On("GetRate", mockTransaction.Date, "Brazil").Return(mockExchange, nil)

		result, err := service.GetTransactionWithExchangeByID(mockTransaction.Id, "Brazil")

		assert.NoError(t, err, "nenhum erro esperado")
		assert.Equal(t, mockTransaction.Id, result.Id)
		assert.Equal(t, mockTransaction.Description, result.Description)
		assert.Equal(t, mockTransaction.Date, result.Date)
		assert.Equal(t, "Brazil", result.Country)
		assert.Equal(t, "Real", result.Currency)
		assert.Equal(t, 5.0, result.ExchangeRate)
		assert.Equal(t, 200.00, result.OriginalValue)
		assert.Equal(t, 1000.00, result.ConvertedValue)
	})

	t.Run("Erro ao buscar transação no repositório", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchangeClient := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchangeClient)
		wantErr := errors.New("transação não encontrada")

		mockRepo.On("GetTransactionByID", mockTransaction.Id).Return(models.Transaction{}, wantErr)

		result, err := service.GetTransactionWithExchangeByID(mockTransaction.Id, "Brazil")

		assert.Error(t, err, "esperado erro")
		assert.Equal(t, models.TransactionWithExchange{}, result, "esperado resultado vazio")
		assert.Equal(t, wantErr, err, "erro esperado não corresponde")
	})

	t.Run("Erro ao buscar taxa de câmbio", func(t *testing.T) {
		mockRepo := &mocks.MockTransactionRepository{}
		mockExchangeClient := &mocks.MockExchangeClient{}
		service := services.NewTransactionServiceImpl(mockRepo, mockExchangeClient)
		wantErr := errors.New("erro ao buscar taxa")

		mockRepo.On("GetTransactionByID", mockTransaction.Id).Return(mockTransaction, nil)
		mockExchangeClient.On("GetRate", mockTransaction.Date, "Brazil").Return(models.Exchange{}, wantErr)

		result, err := service.GetTransactionWithExchangeByID(mockTransaction.Id, "Brazil")

		assert.Error(t, err, "esperado erro")
		assert.Equal(t, models.TransactionWithExchange{}, result, "esperado resultado vazio")
		assert.Equal(t, wantErr, err, "erro esperado não corresponde")
	})
}
