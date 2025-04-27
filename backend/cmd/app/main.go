package main

import (
	transactionHandler "backend/internal/app/handlers/transaction"
	"backend/internal/app/routes"
	transactionService "backend/internal/app/services/transaction"
	"backend/internal/pkg/exchange"
	transactionRepository "backend/internal/repository/transaction"
	"backend/pkg/logging"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {

	err := logging.InitLogger()
	if err != nil {
		log.Fatalf("não foi possível iniciar o logger: %v", err)
	}
	logging.Logger.Info("Iniciando aplicação...")

	router := gin.Default()

	transactionRepo := transactionRepository.NewTransactionRepositoryGorm()
	exchangeClient := exchange.NewExchangeClientImpl()
	transactionServ := transactionService.NewTransactionServiceImpl(transactionRepo, exchangeClient)
	transactionHand := transactionHandler.NewTransactionHandler(transactionServ)

	routes.RegisterMainRoutes(router)
	routes.RegisterTransactionRoutes(router, transactionHand)

	router.Run(":8080")

	logging.Logger.Info("Iniciando aplicação...")
}
