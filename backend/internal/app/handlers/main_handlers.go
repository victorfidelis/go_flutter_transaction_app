package handlers

import (
	"log"

	"github.com/gin-gonic/gin"
)

func LoadHome(c *gin.Context) {
	log.Println("Requisição recebida.", "path:", c.Request.URL.Path)
	c.JSON(200, gin.H{"message": "Welcome to the Home Page!"})
}
