package routes

import (
	"backend/internal/app/handlers"

	"github.com/gin-gonic/gin"
)

func RegisterTransactionRoutes(router *gin.Engine) {
	router.POST("/transaction", handlers.CreateTransaction)
}
