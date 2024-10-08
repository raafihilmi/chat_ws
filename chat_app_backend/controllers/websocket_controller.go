package controllers

import (
	"encoding/json"
	"log"
	"net/http"

	"chat_app_backend/config"
	"chat_app_backend/models"

	"chat_app_backend/websockets"

	"github.com/gorilla/websocket"

	"github.com/gin-gonic/gin"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true // For development, allow all origins
	},
}

var manager = websockets.NewManager()

func init() {
	go manager.Run()
}

func HandleWebSocket(c *gin.Context) {
	userID := c.GetUint("user_id") // Assumes middleware sets this
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not upgrade connection"})
		return
	}

	client := &websockets.Client{
		ID:   userID,
		Conn: conn,
		Send: make(chan []byte),
	}

	manager.RegisterClient(client)

	go readPump(client)
	go writePump(client)
}

func readPump(client *websockets.Client) {
	defer func() {
		manager.RegisterClient(client)
		client.Conn.Close()
	}()

	for {
		_, message, err := client.Conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error: %v", err)
			}
			break
		}

		var chatMessage models.Chat
		if err := json.Unmarshal(message, &chatMessage); err != nil {
			log.Printf("error chat: %v", err)
			continue
		}

		chatMessage.SenderID = client.ID
		config.DB.Create(&chatMessage)

		manager.Send(chatMessage.ReceiverID, message)
	}
}

func writePump(client *websockets.Client) {
	defer func() {
		client.Conn.Close()
	}()

	for {
		select {
		case message, ok := <-client.Send:
			if !ok {
				client.Conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			w, err := client.Conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			w.Write(message)

			n := len(client.Send)
			for i := 0; i < n; i++ {
				w.Write(<-client.Send)
			}

			if err := w.Close(); err != nil {
				return
			}
		}
	}
}
