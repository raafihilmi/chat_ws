package controllers

import (
	"log"
	"net/http"
	"strings"
	"time"

	"chat_app_backend/config"
	"chat_app_backend/models"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

func Register(c *gin.Context) {
	var user models.User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	log.Printf("Password after binding: '%s'", user.Password)

	if strings.TrimSpace(user.Password) == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Password cannot be empty"})
		return
	}

	if err := user.HashPassword(user.Password); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	if err := config.DB.Create(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User registered successfully"})
}

func Login(c *gin.Context) {
	var loginData struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&loginData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user models.User
	if err := config.DB.Where("username = ?", loginData.Username).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid username"})
		return
	}

	if !user.CheckPassword(loginData.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid pasword"})
		return
	}

	if loginData.Password == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Password is required"})
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": user.ID,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
	})

	tokenString, err := token.SignedString([]byte("your_secret_key"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": tokenString, "user_id": user.ID})
}

func SaveFCMToken(c *gin.Context) {
	var tokenData struct {
		UserID   uint   `json:"user_id"`
		FCMToken string `json:"fcm_token"`
	}

	if err := c.ShouldBindJSON(&tokenData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user models.User
	if err := config.DB.First(&user, tokenData.UserID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Update FCM Token di database
	user.FCMToken = tokenData.FCMToken
	if err := config.DB.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update FCM Token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "FCM Token saved successfully"})
}
