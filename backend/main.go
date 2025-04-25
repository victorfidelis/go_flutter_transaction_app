package main

import (
	"backend/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	routes.RegisterMainRoutes(router)

	router.Run(":8080")
}
