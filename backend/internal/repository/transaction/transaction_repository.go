package repository

import "backend/internal/app/models"

type TransactionRepository interface {
	CreateTransaction(transaction *models.Transaction) error
	GetTransactionByID(id int) (models.Transaction, error)
	GetAllTransactions() ([]models.Transaction, error)
}
