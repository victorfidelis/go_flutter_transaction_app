package mocks

import (
	"backend/internal/app/models"

	"github.com/stretchr/testify/mock"
)

type MockTransactionRepository struct {
	mock.Mock
}

func (m *MockTransactionRepository) CreateTransaction(t *models.Transaction) error {
	args := m.Called(t)
	return args.Error(0)
}

func (m *MockTransactionRepository) GetTransactionByID(id int) (models.Transaction, error) {
	args := m.Called(id)
	return args.Get(0).(models.Transaction), args.Error(1)
}

func (m *MockTransactionRepository) GetAllTransactions() ([]models.Transaction, error) {
	args := m.Called()
	return args.Get(0).([]models.Transaction), args.Error(1)
}
