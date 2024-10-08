package models

import (
	"github.com/jinzhu/gorm"
)

type Group struct {
	gorm.Model
	Name        string `json:"name"`
	Description string `json:"description"`
	CreatorID   uint   `json:"creator_id"`
}

type GroupMember struct {
	gorm.Model
	GroupID uint `json:"group_id"`
	UserID  uint `json:"user_id"`
}

type GroupMessage struct {
	gorm.Model
	GroupID uint   `json:"group_id"`
	UserID  uint   `json:"user_id"`
	Message string `json:"message"`
}
