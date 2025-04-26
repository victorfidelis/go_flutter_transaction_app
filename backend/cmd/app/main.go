package main

import (
	"backend/internal/app/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	// err := repositories.InitDB(repositories.DatabaseConfig{
	// 	Host:     os.Getenv("DB_HOST"),
	// 	User:     os.Getenv("DB_USER"),
	// 	Password: os.Getenv("DB_PASSWORD"),
	// 	Name:     os.Getenv("DB_NAME"),
	// 	Port:     os.Getenv("DB_PORT"),
	// })

	// if err != nil {
	// 	panic("Falha ao conectar ao banco de dados: " + err.Error())
	// }

	routes.RegisterMainRoutes(router)
	routes.RegisterTransactionRoutes(router)

	router.Run(":8080")
}
