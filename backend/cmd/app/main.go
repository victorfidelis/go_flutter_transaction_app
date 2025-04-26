package main

import (
	transactionHandler "backend/internal/app/handlers/transaction"
	"backend/internal/app/routes"
	transactionService "backend/internal/app/services/transaction"
	"backend/internal/pkg/exchange"
	transactionRepository "backend/internal/repository/transaction"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	transactionRepo := transactionRepository.NewTransactionRepositoryGorm()
	exchangeClient := exchange.NewExchangeClientImpl()
	transactionServ := transactionService.NewTransactionServiceImpl(transactionRepo, exchangeClient)
	transactionHand := transactionHandler.NewTransactionHandler(transactionServ)

	routes.RegisterMainRoutes(router)
	routes.RegisterTransactionRoutes(router, transactionHand)

	router.Run(":8080")
}
