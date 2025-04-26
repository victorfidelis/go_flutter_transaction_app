package main

import (
	transactionHandler "backend/internal/app/handlers/transaction"
	"backend/internal/app/routes"
	transactionService "backend/internal/app/services/transaction"
	transactionRepository "backend/internal/repository/transaction"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	transactionRepo := transactionRepository.NewGormTransactionRepository()
	transactionServ := transactionService.NewTransactionService(transactionRepo)
	transactionHand := transactionHandler.NewTransactionHandler(transactionServ)

	routes.RegisterMainRoutes(router)
	routes.RegisterTransactionRoutes(router, transactionHand)

	router.Run(":8080")
}
