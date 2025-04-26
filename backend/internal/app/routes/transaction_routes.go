package routes

import (
	handlers "backend/internal/app/handlers/transaction"

	"github.com/gin-gonic/gin"
)

func RegisterTransactionRoutes(router *gin.Engine, handler *handlers.TransactionHandler) {
	router.POST("/transaction", handler.CreateTransaction)
	router.GET("/transaction/:id", handler.GetTransaction)
	router.GET("/transactions", handler.GetAllTransactions)
}
