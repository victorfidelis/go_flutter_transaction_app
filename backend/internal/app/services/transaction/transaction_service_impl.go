package services

import (
	"backend/internal/app/models"
	"backend/internal/pkg/exchange"
	"backend/internal/pkg/round"
	repository "backend/internal/repository/transaction"
	"backend/pkg/logging"
	"errors"
	"strings"

	"go.uber.org/zap"
)

type TransactionServiceImpl struct {
	repository     repository.TransactionRepository
	exchangeClient exchange.ExchangeClient
}

func NewTransactionServiceImpl(
	repository repository.TransactionRepository,
	exchangeClient exchange.ExchangeClient,
) *TransactionServiceImpl {
	return &TransactionServiceImpl{
		repository:     repository,
		exchangeClient: exchangeClient,
	}
}

func (s *TransactionServiceImpl) CreateTransaction(transaction *models.Transaction) error {
	logging.Logger.Info("Iniciando serviço de criação de transação", zap.String("description", transaction.Description))
	if err := ValidateTransaction(transaction); err != nil {
		logging.Logger.Error("Erro ao validar transação", zap.String("description", transaction.Description), zap.Error(err))
		return err
	}

	err := s.repository.CreateTransaction(transaction)
	if err != nil {
		logging.Logger.Error("Erro ao criar transação", zap.String("description", transaction.Description), zap.Error(err))
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

func (s *TransactionServiceImpl) GetTransactionByID(id int) (models.Transaction, error) {
	logging.Logger.Info("Iniciando serviço de busca de transação", zap.Int("id", id))
	transaction, err := s.repository.GetTransactionByID(id)
	if err != nil {
		logging.Logger.Error("Erro ao buscar transação", zap.Int("id", id), zap.Error(err))
		return models.Transaction{}, err
	}
	return transaction, nil
}

func (s *TransactionServiceImpl) GetAllTransactions() ([]models.Transaction, error) {
	logging.Logger.Info("Iniciando serviço de busca de todas as transações")
	transactions, err := s.repository.GetAllTransactions()
	if err != nil {
		logging.Logger.Error("Erro ao buscar todas as transações", zap.Error(err))
		return []models.Transaction{}, err
	}
	return transactions, nil
}

func (s *TransactionServiceImpl) GetTransactionWithExchangeByID(id int, country string) (models.TransactionWithExchange, error) {
	logging.Logger.Info("Iniciando serviço de busca de transação com câmbio", zap.Int("id", id), zap.String("country", country))
	transaction, err := s.repository.GetTransactionByID(id)
	if err != nil {
		logging.Logger.Error("Erro ao buscar transação", zap.Int("id", id), zap.Error(err))
		return models.TransactionWithExchange{}, err
	}

	exchange, err := s.exchangeClient.GetRate(transaction.Date, country)
	if err != nil {
		logging.Logger.Error("Erro ao buscar taxa de câmbio", zap.Int("id", id), zap.String("country", country), zap.Error(err))
		return models.TransactionWithExchange{}, err
	}

	effectiveDate, err := exchange.EffectiveDateParsed()
	if err != nil {
		logging.Logger.Error("Erro ao parsear data efetiva", zap.Int("id", id), zap.String("country", country), zap.Error(err))
		return models.TransactionWithExchange{}, err
	}

	exchangeRate, err := exchange.ExchangeRateParse()
	if err != nil {
		logging.Logger.Error("Erro ao parsear taxa de câmbio", zap.Int("id", id), zap.String("country", country), zap.Error(err))
		return models.TransactionWithExchange{}, err
	}

	transactionWithExchange := models.TransactionWithExchange{
		Id:             transaction.Id,
		Description:    transaction.Description,
		Date:           transaction.Date,
		OriginalValue:  round.Round(transaction.Amount, 2),
		Country:        exchange.Country,
		Currency:       exchange.Currency,
		ExchangeRate:   exchangeRate,
		ConvertedValue: round.Round(transaction.Amount*exchangeRate, 2),
		EffectiveDate:  effectiveDate,
	}

	return transactionWithExchange, nil
}
