package handlers

import (
	"backend/internal/app/models"
	services "backend/internal/app/services/transaction"
	repositories "backend/internal/repositories/transaction"
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreateTransaction(c *gin.Context) {
	var transaction models.Transaction
	if err := c.ShouldBindJSON(&transaction); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}
	transactionService := services.NewTransactionService(repositories.NewGormTransactionRepository())
	if err := transactionService.Repository.CreateTransaction(&transaction); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(http.StatusCreated, transaction)
}
