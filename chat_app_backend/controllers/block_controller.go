package controllers

import (
	"net/http"
	"strconv"

	"chat_app_backend/config"
	"chat_app_backend/models"

	"github.com/gin-gonic/gin"
)

func BlockUser(c *gin.Context) {
	blockerID := c.GetUint("user_id")
	blockedID, _ := strconv.ParseUint(c.Param("user_id"), 10, 32)

	block := models.Block{
		BlockerID: blockerID,
		BlockedID: uint(blockedID),
	}

	if err := config.DB.Create(&block).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to block user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User blocked successfully"})
}

func UnblockUser(c *gin.Context) {
	blockerID := c.GetUint("user_id")
	blockedID, _ := strconv.ParseUint(c.Param("user_id"), 10, 32)

	if err := config.DB.Where("blocker_id = ? AND blocked_id = ?", blockerID, blockedID).Delete(&models.Block{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to unblock user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User unblocked successfully"})
}

func GetBlockedUsers(c *gin.Context) {
	userID := c.GetUint("user_id")
	var blockedUsers []models.User

	if err := config.DB.Joins("JOIN blocks ON users.id = blocks.blocked_id").
		Where("blocks.blocker_id = ?", userID).
		Select("users.*").
		Find(&blockedUsers).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get blocked users"})
		return
	}

	c.JSON(http.StatusOK, blockedUsers)
}
