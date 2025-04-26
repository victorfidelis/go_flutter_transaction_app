package services

import (
	"backend/internal/app/models"
	repositories "backend/internal/repositories/transaction"
	"errors"
	"strings"
)

type TransactionService struct {
	Repository repositories.TransactionRepository
}

func NewTransactionService(repository repositories.TransactionRepository) *TransactionService {
	return &TransactionService{
		Repository: repository,
	}
}

func (s *TransactionService) CreateTransaction(transaction *models.Transaction) error {
	if err := ValidateTransaction(transaction); err != nil {
		return err
	}

	err := s.Repository.CreateTransaction(transaction)
	if err != nil {
		return err
	}
	return nil
}

func ValidateTransaction(transaction *models.Transaction) error {
	transaction.Description = strings.TrimSpace(transaction.Description)
	if transaction.Description == "" {
		return errors.New("description is required")
	}
	if len(transaction.Description) > 50 {
		return errors.New("description must be less than 50 characters")
	}
	if transaction.Date.IsZero() {
		return errors.New("date is required")
	}
	if transaction.Amount <= 0 {
		return errors.New("amount must be greater than zero")
	}
	return nil
}

func (s *TransactionService) GetTransactionByID(id int) (models.Transaction, error) {
	transaction, err := s.Repository.GetTransactionByID(id)
	if err != nil {
		return models.Transaction{}, err
	}
	return transaction, nil
}

func (s *TransactionService) GetAllTransactions() ([]models.Transaction, error) {
	transactions, err := s.Repository.GetAllTransactions()
	if err != nil {
		return []models.Transaction{}, err
	}
	return transactions, nil
}
