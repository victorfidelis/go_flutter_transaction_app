package routes

import (
	"backend/docs"
	"backend/internal/app/handlers"

	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func RegisterMainRoutes(router *gin.Engine) {
	docs.SwaggerInfo.BasePath = "/"
	router.GET("/", handlers.LoadHome)
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
}
