package main

import (
	transactionHandler "backend/internal/app/handlers/transaction"
	"backend/internal/app/routes"
	transactionService "backend/internal/app/services/transaction"
	"backend/internal/middleware"
	"backend/internal/pkg/exchange"
	transactionRepository "backend/internal/repository/transaction"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	log.Println("Iniciando aplicação...")

	router := gin.Default()

	router.Use(middleware.Cors())

	transactionRepo := transactionRepository.NewTransactionRepositoryGorm()
	exchangeClient := exchange.NewExchangeClientImpl()
	transactionServ := transactionService.NewTransactionServiceImpl(transactionRepo, exchangeClient)
	transactionHand := transactionHandler.NewTransactionHandler(transactionServ)

	routes.RegisterMainRoutes(router)
	routes.RegisterTransactionRoutes(router, transactionHand)

	router.Run(":8080")

	log.Println("Iniciando aplicação...")
}
