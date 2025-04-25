package routes

import (
	"backend/controllers"

	"github.com/gin-gonic/gin"
)

func RegisterMainRoutes(router *gin.Engine) {
	router.GET("/", controllers.LoadHome)
}
