package routes

import (
	handlers "backend/internal/app/handlers/transaction"

	"github.com/gin-gonic/gin"
)

func RegisterTransactionRoutes(router *gin.Engine, handler *handlers.TransactionHandler) {
	router.POST("/transactions", handler.CreateTransaction)
	router.GET("/transactions/:id", handler.GetTransaction)
	router.GET("/transactions", handler.GetAllTransactions)
	router.GET("/transactions/:id/:currency", handler.GetTransactionWithExchangeByID)
}
