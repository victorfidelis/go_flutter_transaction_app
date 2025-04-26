package repositories

import (
	"backend/internal/app/models"
	round "backend/internal/pkg"
	"backend/internal/repositories"
)

type GormTransactionRepository struct{}

func NewGormTransactionRepository() *GormTransactionRepository {
	return &GormTransactionRepository{}
}

func (g *GormTransactionRepository) CreateTransaction(transaction *models.Transaction) error {
	gormDb, err := repositories.GetGorm()
	if err != nil {
		return err
	}

	transaction.Amount = round.Round(transaction.Amount, 2)

	if err := gormDb.Create(transaction).Error; err != nil {
		return err
	}
	return nil
}

func (g *GormTransactionRepository) GetTransactionByID(id int) (models.Transaction, error) {
	gormDb, err := repositories.GetGorm()
	if err != nil {
		return models.Transaction{}, err
	}

	var transaction models.Transaction
	if err := gormDb.First(&transaction, id).Error; err != nil {
		return models.Transaction{}, err
	}
	return transaction, nil
}

func (g *GormTransactionRepository) GetAllTransactions() ([]models.Transaction, error) {
	gormDb, err := repositories.GetGorm()
	if err != nil {
		return nil, err
	}

	var transactions []models.Transaction
	if err := gormDb.Find(&transactions).Error; err != nil {
		return nil, err
	}
	return transactions, nil
}
