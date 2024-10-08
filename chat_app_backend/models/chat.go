package models

import (
	"github.com/jinzhu/gorm"
)

type Chat struct {
	gorm.Model
	SenderID   uint   `json:"sender_id"`
	ReceiverID uint   `json:"receiver_id"`
	Message    string `json:"message"`
	IsRead     bool   `json:"is_read" gorm:"default:false"`
}
