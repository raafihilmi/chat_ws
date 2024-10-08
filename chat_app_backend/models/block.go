package models

import (
	"github.com/jinzhu/gorm"
)

type Block struct {
	gorm.Model
	BlockerID uint `json:"blocker_id"`
	BlockedID uint `json:"blocked_id"`
}
