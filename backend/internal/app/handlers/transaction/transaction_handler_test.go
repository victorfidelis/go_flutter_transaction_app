package handlers_test

import (
	handlers "backend/internal/app/handlers/transaction"
	"backend/internal/app/models"
	testhelpers "backend/internal/test"
	"backend/internal/test/mocks"
	"encoding/json"
	"errors"
	"net/http"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func TestCreateTransaction(t *testing.T) {

	validTransaction := models.Transaction{
		Id:          1,
		Description: "Test Transaction",
		Date:        time.Now(),
		Amount:      100.0,
	}

	t.Run("Sucesso enviar criar uma transação válida", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)
		mockService.On("CreateTransaction", mock.AnythingOfType("*models.Transaction")).Return(nil)

		context, recorder, _ := testhelpers.BuildTestContextGin("POST", "/transactions", validTransaction)

		handler.CreateTransaction(context)

		assert.Equal(t, http.StatusCreated, recorder.Code)

		var response models.Transaction
		json.Unmarshal(recorder.Body.Bytes(), &response)
		assert.Equal(t, validTransaction.Id, response.Id)
		assert.Equal(t, validTransaction.Description, response.Description)
		assert.Equal(t, validTransaction.Amount, response.Amount)
		assert.Equal(t, validTransaction.Date.Format(time.RFC3339), response.Date.Format(time.RFC3339))
	})

	t.Run("Erro ao criar transação", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)
		mockService.On("CreateTransaction", mock.AnythingOfType("*models.Transaction")).Return(errors.New("error"))

		context, recorder, _ := testhelpers.BuildTestContextGin("POST", "/transactions", validTransaction)

		handler.CreateTransaction(context)

		assert.Equal(t, http.StatusInternalServerError, recorder.Code)
	})

	t.Run("Erro ao enviar transação inválida", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		context, recorder, _ := testhelpers.BuildTestContextGin("POST", "/transactions", "invalid-json")

		handler.CreateTransaction(context)

		assert.Equal(t, http.StatusBadRequest, recorder.Code)
	})
}

func TestGetTransaction(t *testing.T) {

	validTransaction := models.Transaction{
		Id:          1,
		Description: "Test Transaction",
		Date:        time.Now(),
		Amount:      100.0,
	}

	t.Run("Sucesso ao consultar uma transação válida", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)
		mockService.On("GetTransactionByID", 1).Return(validTransaction, nil)

		context, recorder, _ := testhelpers.BuildTestContextGin(
			"GET",
			"/transactions/1",
			nil,
			gin.Param{Key: "id", Value: "1"},
		)

		handler.GetTransaction(context)

		assert.Equal(t, http.StatusOK, recorder.Code)
		var response models.Transaction
		json.Unmarshal(recorder.Body.Bytes(), &response)
		assert.Equal(t, validTransaction.Id, response.Id)
		assert.Equal(t, validTransaction.Description, response.Description)
		assert.Equal(t, validTransaction.Amount, response.Amount)
		assert.Equal(t, validTransaction.Date.Format(time.RFC3339), response.Date.Format(time.RFC3339))
	})

	t.Run("Erro ao consultar transação", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)
		mockService.On("GetTransactionByID", 1).Return(models.Transaction{}, errors.New("error"))

		context, recorder, _ := testhelpers.BuildTestContextGin(
			"GET",
			"/transactions/1",
			nil,
			gin.Param{Key: "id", Value: "1"},
		)

		handler.GetTransaction(context)

		assert.Equal(t, http.StatusInternalServerError, recorder.Code)
	})

	t.Run("Erro ao consultar transação com ID inválido", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		context, recorder, _ := testhelpers.BuildTestContextGin(
			"GET",
			"/transactions/invalid",
			nil,
			gin.Param{Key: "id", Value: "invalid"},
		)

		handler.GetTransaction(context)

		assert.Equal(t, http.StatusBadRequest, recorder.Code)
	})
}

func TestGetAllTransactions(t *testing.T) {

	transactions := []models.Transaction{
		{Id: 1, Description: "Transaction 1", Amount: 100.0, Date: time.Now()},
		{Id: 2, Description: "Transaction 2", Amount: 200.0, Date: time.Now()},
	}

	t.Run("Sucesso ao consultar todas as transações", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		mockService.On("GetAllTransactions").Return(transactions, nil)

		context, recorder, _ := testhelpers.BuildTestContextGin("GET", "/transactions", nil)

		handler.GetAllTransactions(context)

		assert.Equal(t, http.StatusOK, recorder.Code)
		var response []*models.Transaction
		json.Unmarshal(recorder.Body.Bytes(), &response)
		assert.Equal(t, len(transactions), len(response))
		for i, transaction := range transactions {
			assert.Equal(t, transaction.Id, response[i].Id)
			assert.Equal(t, transaction.Description, response[i].Description)
			assert.Equal(t, transaction.Amount, response[i].Amount)
			assert.Equal(t, transaction.Date.Format(time.RFC3339), response[i].Date.Format(time.RFC3339))
		}
	})

	t.Run("Erro ao consultar todas as transações", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		mockService.On("GetAllTransactions").Return([]models.Transaction{}, errors.New("error"))

		context, recorder, _ := testhelpers.BuildTestContextGin("GET", "/transactions", nil)

		handler.GetAllTransactions(context)

		assert.Equal(t, http.StatusInternalServerError, recorder.Code)
	})
}

func TestGetTransactionWithExchangeByID(t *testing.T) {
	validTransactionWithExchange := models.TransactionWithExchange{
		Id:             1,
		Description:    "Test Transaction",
		Date:           time.Date(2023, 10, 1, 0, 0, 0, 0, time.UTC),
		OriginalValue:  100.0,
		Country:        "Brazil",
		Currency:       "Real",
		ExchangeRate:   5.0,
		ConvertedValue: 500.0,
		EffectiveDate:  time.Now(),
	}

	t.Run("Sucesso ao consultar transação com exchange", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		mockService.On("GetTransactionWithExchangeByID", 1, "Brazil").Return(validTransactionWithExchange, nil)

		context, recorder, _ := testhelpers.BuildTestContextGin(
			"GET",
			"/transactions/1/Real",
			nil,
			gin.Param{Key: "id", Value: "1"},
			gin.Param{Key: "currency", Value: "Real"},
		)

		handler.GetTransactionWithExchangeByID(context)

		assert.Equal(t, http.StatusOK, recorder.Code)

		var response models.TransactionWithExchange
		json.Unmarshal(recorder.Body.Bytes(), &response)
		assert.Equal(t, validTransactionWithExchange.Id, response.Id)
		assert.Equal(t, validTransactionWithExchange.Description, response.Description)
		assert.Equal(t, validTransactionWithExchange.OriginalValue, response.OriginalValue)
		assert.Equal(t, validTransactionWithExchange.Country, response.Country)
		assert.Equal(t, validTransactionWithExchange.Currency, response.Currency)
		assert.Equal(t, validTransactionWithExchange.ExchangeRate, response.ExchangeRate)
		assert.Equal(t, validTransactionWithExchange.ConvertedValue, response.ConvertedValue)
		assert.Equal(t, validTransactionWithExchange.Date.Format(time.RFC3339), response.Date.Format(time.RFC3339))
		assert.Equal(t, validTransactionWithExchange.EffectiveDate.Format(time.RFC3339), response.EffectiveDate.Format(time.RFC3339))
	})

	t.Run("Erro ao consultar transação com exchange", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		mockService.On("GetTransactionWithExchangeByID", 1, "USA").Return(models.TransactionWithExchange{}, errors.New("error"))

		context, recorder, _ := testhelpers.BuildTestContextGin(
			"GET",
			"/transactions/1/dolar",
			nil,
			gin.Param{Key: "id", Value: "1"},
			gin.Param{Key: "currency", Value: "dolar"},
		)

		handler.GetTransactionWithExchangeByID(context)

		assert.Equal(t, http.StatusInternalServerError, recorder.Code)
	})

	t.Run("Erro ao consultar transação com ID inválido", func(t *testing.T) {
		mockService := new(mocks.MockTransactionService)
		handler := handlers.NewTransactionHandler(mockService)

		context, recorder, _ := testhelpers.BuildTestContextGin(
			"GET",
			"/transactions/invalid/dolar",
			nil,
			gin.Param{Key: "id", Value: "invalid"},
			gin.Param{Key: "currency", Value: "dolar"},
		)

		handler.GetTransactionWithExchangeByID(context)

		assert.Equal(t, http.StatusBadRequest, recorder.Code)
	})
}
