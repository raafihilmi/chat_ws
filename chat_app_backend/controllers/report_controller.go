package controllers

import (
	"net/http"
	"strconv"

	"chat_app_backend/config"
	"chat_app_backend/models"

	"github.com/gin-gonic/gin"
)

func ReportUser(c *gin.Context) {
	reporterID := c.GetUint("user_id")
	reportedID, _ := strconv.ParseUint(c.Param("user_id"), 10, 32)

	var input struct {
		Reason string `json:"reason" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	report := models.Report{
		ReporterID: reporterID,
		ReportedID: uint(reportedID),
		Reason:     input.Reason,
	}

	if err := config.DB.Create(&report).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to submit report"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User reported successfully"})
}

func ReportMessage(c *gin.Context) {
	reporterID := c.GetUint("user_id")
	messageID, _ := strconv.ParseUint(c.Param("message_id"), 10, 32)

	var input struct {
		Reason string `json:"reason" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var chat models.Chat
	if err := config.DB.First(&chat, messageID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Message not found"})
		return
	}

	report := models.Report{
		ReporterID: reporterID,
		ReportedID: chat.SenderID,
		ChatID:     uint(messageID),
		Reason:     input.Reason,
	}

	if err := config.DB.Create(&report).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to submit report"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Message reported successfully"})
}
