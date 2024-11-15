package utils

import (
	"context"
	"fmt"
	"log"
	"os"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
)

var FirebaseApp *firebase.App
var FirebaseMessagingClient *messaging.Client

func InitFirebase() error {
	credentialsPath := os.Getenv("FIREBASE_CREDENTIALS_PATH")
	if credentialsPath == "" {
		return fmt.Errorf("missing FIREBASE_CREDENTIALS_PATH in environment variables")
	}

	opt := option.WithCredentialsFile(credentialsPath)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return fmt.Errorf("error initializing Firebase app: %v", err)
	}

	FirebaseMessagingClient, err = app.Messaging(context.Background())
	if err != nil {
		return fmt.Errorf("error initializing Firebase Messaging: %v", err)
	}

	FirebaseApp = app
	log.Println("Firebase Admin SDK initialized successfully")
	return nil
}

func SendPushNotification(fcmToken, title, body, userId, selectedUser, username string) error {
	if FirebaseMessagingClient == nil {
		return fmt.Errorf("firebase Messaging client is not initialized")
	}

	message := &messaging.Message{
		Token: fcmToken,
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Data: map[string]string{
			"userId":       userId,
			"selectedUser": selectedUser,
			"username":     username,
		},
	}

	_, err := FirebaseMessagingClient.Send(context.Background(), message)
	if err != nil {
		return fmt.Errorf("failed to send FCM message: %v", err)
	}

	log.Printf("Push notification sent to token: %s", fcmToken)
	return nil
}
