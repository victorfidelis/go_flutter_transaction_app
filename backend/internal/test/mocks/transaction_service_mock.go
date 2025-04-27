package mocks

import (
	"backend/internal/app/models"

	"github.com/stretchr/testify/mock"
)

type MockTransactionService struct {
	mock.Mock
}

func (m *MockTransactionService) CreateTransaction(transaction *models.Transaction) error {
	args := m.Called(transaction)
	return args.Error(0)
}

func (m *MockTransactionService) GetTransactionByID(id int) (models.Transaction, error) {
	args := m.Called(id)
	return args.Get(0).(models.Transaction), args.Error(1)
}

func (m *MockTransactionService) GetAllTransactions() ([]models.Transaction, error) {
	args := m.Called()
	return args.Get(0).([]models.Transaction), args.Error(1)
}
func (m *MockTransactionService) GetTransactionWithExchangeByID(id int, country string) (models.TransactionWithExchange, error) {
	args := m.Called(id, country)
	return args.Get(0).(models.TransactionWithExchange), args.Error(1)
}
