package handlers

import (
	"backend/internal/app/models"
	services "backend/internal/app/services/transaction"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type TransactionHandler struct {
	service services.TransactionService
}

func NewTransactionHandler(service services.TransactionService) *TransactionHandler {
	return &TransactionHandler{
		service: service,
	}
}

func (h *TransactionHandler) CreateTransaction(c *gin.Context) {
	log.Println("Requisição recebida.", "path:", c.Request.URL.Path)
	var transaction models.Transaction
	if err := c.ShouldBindJSON(&transaction); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		log.Println("Chamada incorreta.", "message:", err.Error())
		return
	}
	if err := h.service.CreateTransaction(&transaction); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		log.Println("Falha interna.", "message", err.Error())
		return
	}
	c.JSON(http.StatusCreated, transaction)
}

func (h *TransactionHandler) GetTransaction(c *gin.Context) {
	log.Println("Requisição recebida.", "path:", c.Request.URL.Path)
	textId := c.Params.ByName("id")
	id, err := strconv.Atoi(textId)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		log.Println("Chamada incorreta.", "message", err.Error())
		return
	}

	transaction, err := h.service.GetTransactionByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		log.Println("Falha interna.", "message:", err.Error())
		return
	}

	c.JSON(http.StatusOK, transaction)
}

func (h *TransactionHandler) GetAllTransactions(c *gin.Context) {
	log.Println("Requisição recebida.", "path:", c.Request.URL.Path)
	transactions, err := h.service.GetAllTransactions()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		log.Println("Falha interna.", "message:", err.Error())
		return
	}

	c.JSON(http.StatusOK, transactions)
}

func (h *TransactionHandler) GetTransactionWithExchangeByID(c *gin.Context) {
	log.Println("Requisição recebida.", "path:", c.Request.URL.Path)
	textId := c.Params.ByName("id")
	id, err := strconv.Atoi(textId)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		log.Println("Chamada incorreta.", "message:", err.Error())
		return
	}

	currency := c.Params.ByName("currency")
	transaction, err := h.service.GetTransactionWithExchangeByID(id, currency)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		log.Println("Falha interna.", "message:", err.Error())
		return
	}

	c.JSON(http.StatusOK, transaction)
}
