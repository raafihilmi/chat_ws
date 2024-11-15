package models

import (
	"log"

	"github.com/jinzhu/gorm"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	gorm.Model
	Username string `gorm:"unique;not null" json:"username"`
	Email    string `gorm:"unique;not null" json:"email"`
	Password string `gorm:"not null" json:"password"`
	FCMToken string `json:"fcm_token"`
}

func (u *User) HashPassword(plain string) error {
	log.Printf("Password to be hashed: %v", plain)
	hashed, err := bcrypt.GenerateFromPassword([]byte(plain), bcrypt.DefaultCost)

	if err != nil {
		return err
	}
	u.Password = string(hashed)
	log.Printf("Password : %v", u.Password)
	return nil
}

func (u *User) CheckPassword(plain string) bool {
	log.Printf("Password Plain: %v", plain)
	log.Printf("Password Hash (from DB): %s", u.Password)
	err := bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(plain))
	if err != nil {
		log.Printf("Password check failed: %v", err)
		return false
	}

	return true
}
