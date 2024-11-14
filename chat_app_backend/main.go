package main

import (
	"chat_app_backend/config"
	"chat_app_backend/models"
	"chat_app_backend/routes"
	"chat_app_backend/utils"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	if err := utils.InitFirebase(); err != nil {
		log.Fatalf("Failed to initialize Firebase: %v", err)
	}

	config.InitDB()
	config.DB.AutoMigrate(&models.User{})
	utils.InitFirebase()
	defer config.DB.Close()

	r := gin.Default()
	routes.SetupRoutes(r)

	r.Run(":8080")
}
