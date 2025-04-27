package handlers

import (
	"backend/pkg/logging"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func LoadHome(c *gin.Context) {
	logging.Logger.Info("Requisição recebida", zap.String("path", c.Request.URL.Path))
	c.JSON(200, gin.H{"message": "Welcome to the Home Page!"})
}
