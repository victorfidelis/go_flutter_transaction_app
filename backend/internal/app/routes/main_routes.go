package routes

import (
	"backend/internal/app/handlers"

	"github.com/gin-gonic/gin"
)

func RegisterMainRoutes(router *gin.Engine) {
	router.GET("/", handlers.LoadHome)
}
