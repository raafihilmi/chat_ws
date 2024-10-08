package controllers

import (
	"net/http"
	"strconv"

	"chat_app_backend/config"
	"chat_app_backend/models"

	"github.com/gin-gonic/gin"
)

func GetChatHistory(c *gin.Context) {
	userID := c.GetUint("user_id")
	otherUserID, _ := strconv.ParseUint(c.Param("user_id"), 10, 32)

	var chats []models.Chat
	config.DB.Where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
		userID, otherUserID, otherUserID, userID).
		Order("created_at ASC").
		Find(&chats)

	c.JSON(http.StatusOK, chats)
}

func SendMessage(c *gin.Context) {
	var chat models.Chat
	if err := c.ShouldBindJSON(&chat); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	chat.SenderID = c.GetUint("user_id")
	if err := config.DB.Create(&chat).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send message"})
		return
	}

	c.JSON(http.StatusOK, chat)
}
