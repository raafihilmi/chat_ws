package models

import (
	"github.com/jinzhu/gorm"
)

type Report struct {
	gorm.Model
	ReporterID uint   `json:"reporter_id"`
	ReportedID uint   `json:"reported_id"`
	ChatID     uint   `json:"chat_id"`
	Reason     string `json:"reason"`
}
