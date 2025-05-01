package services

import (
	"backend/internal/app/models"
	"backend/internal/pkg/exchange"
	"backend/internal/pkg/round"
	repository "backend/internal/repository/transaction"
	"errors"
	"log"
	"strings"
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
	log.Println("Iniciando serviço de criação de transação.", "description: ", transaction.Description)
	if err := ValidateTransaction(transaction); err != nil {
		log.Println("Erro ao validar transação.", "description:", transaction.Description, "error:", err.Error())
		return err
	}

	err := s.repository.CreateTransaction(transaction)
	if err != nil {
		log.Println("Erro ao criar transação.", "description", transaction.Description, "error:", err.Error())
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
	log.Println("Iniciando serviço de busca de transação.", "id", id)
	transaction, err := s.repository.GetTransactionByID(id)
	if err != nil {
		log.Println("Erro ao buscar transação", "id", id, "error:", err.Error())
		return models.Transaction{}, err
	}
	return transaction, nil
}

func (s *TransactionServiceImpl) GetAllTransactions() ([]models.Transaction, error) {
	log.Println("Iniciando serviço de busca de todas as transações")
	transactions, err := s.repository.GetAllTransactions()
	if err != nil {
		log.Println("Erro ao buscar todas as transações.", "error:", err.Error())
		return []models.Transaction{}, err
	}
	return transactions, nil
}

func (s *TransactionServiceImpl) GetTransactionWithExchangeByID(id int, currency string) (models.TransactionWithExchange, error) {
	log.Println("Iniciando serviço de busca de transação com câmbio.", "id:", id, "currency:", currency)
	transaction, err := s.repository.GetTransactionByID(id)
	if err != nil {
		log.Println("Erro ao buscar transação.", "id:", id, "error:", err.Error())
		return models.TransactionWithExchange{}, err
	}

	exchange, err := s.exchangeClient.GetRate(transaction.Date, currency)
	if err != nil {
		log.Println("Erro ao buscar taxa de câmbio.", "id:", id, "currency:", currency, "error:", err.Error())
		return models.TransactionWithExchange{}, err
	}

	effectiveDate, err := exchange.EffectiveDateParsed()
	if err != nil {
		log.Println("Erro ao parsear data efetiva.", "id:", id, "currency:", currency, "error:", err.Error())
		return models.TransactionWithExchange{}, err
	}

	exchangeRate, err := exchange.ExchangeRateParse()
	if err != nil {
		log.Println("Erro ao parsear taxa de câmbio.", "id:", id, "currency:", currency, "error:", err.Error())
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
