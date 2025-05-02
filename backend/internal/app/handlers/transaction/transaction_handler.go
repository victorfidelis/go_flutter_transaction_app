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

// CreateTransaction godoc
// @Summary      Criar uma transação
// @Description  Rota para criar uma nova transação
// @Tags         transaction
// @Accept       json
// @Produce      json
// @Param        transaction   body      models.Transaction  true  "Modelo de transação"
// @Success      201  {object}  models.Transaction
// @Failure      400  {object}  httputil.HTTPError
// @Failure      500  {object}  httputil.HTTPError
// @Router       /transactions [post]
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

// GetTransaction godoc
// @Summary      Capturar uma transação
// @Description  Rota para capturar uma nova transação
// @Tags         transaction
// @Accept       json
// @Produce      json
// @Param        id   path      int  true  "Id da transação"
// @Success      200  {object}  models.Transaction
// @Failure      400  {object}  httputil.HTTPError
// @Failure      500  {object}  httputil.HTTPError
// @Router       /transactions/{id} [get]
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

// GetAllTransactions godoc
// @Summary      Capturar todas as transações
// @Description  Rota para capturar todas as transações
// @Tags         transaction
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.Transaction
// @Failure      400  {object}  httputil.HTTPError
// @Failure      500  {object}  httputil.HTTPError
// @Router       /transactions [get]
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

// GetTransaction godoc
// @Summary      Capturar uma transação com a taxa da câmbio
// @Description  Rota para capturar uma transação com a taxa da câmbio
// @Tags         transaction
// @Accept       json
// @Produce      json
// @Param        id   path      int  true  "Id da transação"
// @Param        currency   path      string  true  "Moeda"
// @Success      200  {object}  models.TransactionWithExchange
// @Failure      400  {object}  httputil.HTTPError
// @Failure      500  {object}  httputil.HTTPError
// @Router       /transactions/{id}/{currency} [get]
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
