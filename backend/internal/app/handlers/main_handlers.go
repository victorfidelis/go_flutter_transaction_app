package handlers

import (
	"github.com/gin-gonic/gin"
)

func LoadHome(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Welcome to the Home Page!"})
}
