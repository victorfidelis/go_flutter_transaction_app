package services

import "backend/internal/app/models"

type TransactionService interface {
	CreateTransaction(transaction *models.Transaction) error
	GetTransactionByID(id int) (models.Transaction, error)
	GetAllTransactions() ([]models.Transaction, error)
	GetTransactionWithExchangeByID(id int, currency string) (models.TransactionWithExchange, error)
}
