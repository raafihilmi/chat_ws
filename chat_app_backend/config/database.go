package config

import (
	"chat_app_backend/models"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
)

var DB *gorm.DB

func InitDB() {
	var err error
	DB, err = gorm.Open("postgres", "host=localhost user=raafi dbname=chat_app password=123456 sslmode=disable")
	if err != nil {
		panic(err)
	}

	// Auto Migrate
	DB.AutoMigrate(&models.User{}, &models.Chat{}, &models.Block{}, &models.Report{}, &models.Group{}, &models.GroupMember{}, &models.GroupMessage{})
}
