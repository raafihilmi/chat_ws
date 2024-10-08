package main

import (
	"chat_app_backend/config"
	"chat_app_backend/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	config.InitDB()
	defer config.DB.Close()

	r := gin.Default()
	routes.SetupRoutes(r)

	r.Run(":8080")
}
