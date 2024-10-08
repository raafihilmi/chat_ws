package controllers

import (
	"net/http"
	"strconv"

	"chat_app_backend/config"
	"chat_app_backend/models"

	"github.com/gin-gonic/gin"
)

func CreateGroup(c *gin.Context) {
	creatorID := c.GetUint("user_id")

	var input struct {
		Name        string `json:"name" binding:"required"`
		Description string `json:"description"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	group := models.Group{
		Name:        input.Name,
		Description: input.Description,
		CreatorID:   creatorID,
	}

	if err := config.DB.Create(&group).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create group"})
		return
	}

	// Add creator as a member
	member := models.GroupMember{
		GroupID: group.ID,
		UserID:  creatorID,
	}

	if err := config.DB.Create(&member).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add creator to group"})
		return
	}

	c.JSON(http.StatusOK, group)
}

func GetUserGroups(c *gin.Context) {
	userID := c.GetUint("user_id")
	var groups []models.Group

	if err := config.DB.Joins("JOIN group_members ON groups.id = group_members.group_id").
		Where("group_members.user_id = ?", userID).
		Find(&groups).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get user groups"})
		return
	}

	c.JSON(http.StatusOK, groups)
}

func AddGroupMember(c *gin.Context) {
	groupID, _ := strconv.ParseUint(c.Param("group_id"), 10, 32)
	var input struct {
		UserID uint `json:"user_id" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	member := models.GroupMember{
		GroupID: uint(groupID),
		UserID:  input.UserID,
	}

	if err := config.DB.Create(&member).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add member to group"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Member added to group successfully"})
}

func SendGroupMessage(c *gin.Context) {
	senderID := c.GetUint("user_id")
	groupID, _ := strconv.ParseUint(c.Param("group_id"), 10, 32)

	var input struct {
		Message string `json:"message" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	message := models.GroupMessage{
		GroupID: uint(groupID),
		UserID:  senderID,
		Message: input.Message,
	}

	if err := config.DB.Create(&message).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send group message"})
		return
	}

	c.JSON(http.StatusOK, message)
}
