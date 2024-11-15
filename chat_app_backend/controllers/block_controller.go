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
	blockedID, err := strconv.ParseUint(c.Param("user_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	// Attempt to delete the block record
	result := config.DB.Unscoped().Where("blocker_id = ? AND blocked_id = ?", blockerID, blockedID).Delete(&models.Block{})
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to unblock user"})
		return
	}

	// Check if any record was deleted
	if result.RowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "No block record found for this user"})
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

func GetAllUsersExceptBlockedUsers(c *gin.Context) {
	userID := c.GetUint("user_id")
	var users []models.User

	// Query untuk mengambil semua user kecuali yang diblokir oleh userID
	if err := config.DB.
		Joins("LEFT JOIN blocks ON users.id = blocks.blocked_id AND blocks.blocker_id = ?", userID).
		Where("blocks.blocked_id IS NULL").
		Find(&users).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get users"})
		return
	}

	c.JSON(http.StatusOK, users)
}
