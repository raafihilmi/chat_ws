package websockets

import (
	"sync"

	"github.com/gorilla/websocket"
)

type Client struct {
	ID   uint
	Conn *websocket.Conn
	Send chan []byte
}

type Manager struct {
	clients    map[uint]*Client
	broadcast  chan []byte
	register   chan *Client
	unregister chan *Client
	mutex      sync.Mutex
}

func NewManager() *Manager {
	return &Manager{
		clients:    make(map[uint]*Client),
		broadcast:  make(chan []byte),
		register:   make(chan *Client),
		unregister: make(chan *Client),
	}
}

// Metode untuk mendaftarkan client
func (m *Manager) RegisterClient(client *Client) {
	m.register <- client
}

// Metode untuk membatalkan pendaftaran client
func (m *Manager) UnregisterClient(client *Client) {
	m.unregister <- client
}

func (m *Manager) Run() {
	for {
		select {
		case client := <-m.register:
			m.mutex.Lock()
			m.clients[client.ID] = client
			m.mutex.Unlock()
		case client := <-m.unregister:
			if _, ok := m.clients[client.ID]; ok {
				delete(m.clients, client.ID)
				close(client.Send)
			}
		case message := <-m.broadcast:
			for _, client := range m.clients {
				select {
				case client.Send <- message:
				default:
					close(client.Send)
					delete(m.clients, client.ID)
				}
			}
		}
	}
}

func (m *Manager) Send(userID uint, message []byte) {
	m.mutex.Lock()
	defer m.mutex.Unlock()
	if client, ok := m.clients[userID]; ok {
		client.Send <- message
	}
}
