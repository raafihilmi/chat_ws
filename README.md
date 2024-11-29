# Chat App Backend - Development Branch

This is the backend of the Chat App, implemented in Go (Golang) with WebSocket support. This version is under active development and uses PostgreSQL with Laragon for local development. Firebase is also integrated for authentication.

---

## **Features**
- WebSocket communication for real-time chat.
- PostgreSQL as the main database for storing user and message data.
- Firebase authentication for user registration and login.

---

## **Getting Started**

### **Prerequisites**
1. **Go version**: `>=1.19`
2. **Database**: PostgreSQL (local development using Laragon).
3. **Firebase credentials**: Make sure you have a Firebase project and credentials set up.

### **Setup Instructions**
1. **Clone the repository and switch to the `chat_app_backend` branch:**
   ```bash
   git clone https://github.com/raafihilmi/chat_ws.git
   cd chat_ws
   git checkout development/chat_app_backend
   ```

2. **Install Dependencies:**
   Run the following command to download the dependencies:
   ```bash
   go mod tidy
   ```

3. **Setup PostgreSQL Database using Laragon:**
   - Make sure you have **Laragon** installed and running.
   - Start **PostgreSQL** from Laragon.
   - Create a new database, e.g., `chat_app_db`, or use the existing one.
   - Update `config/database.go` with the connection details:
     ```go
     package config

     import (
         "fmt"
         "log"
         "github.com/jinzhu/gorm"
         _ "github.com/jinzhu/gorm/dialects/postgres"
     )

     var DB *gorm.DB

     func InitDB() {
         var err error
         // Update connection string with your PostgreSQL details
         DB, err = gorm.Open("postgres", "host=localhost port=5432 user=your_user dbname=chat_app_db password=your_password sslmode=disable")
         if err != nil {
             log.Fatal(err)
         }
     }
     ```

4. **Set Up Firebase:**
   - Obtain Firebase credentials from your Firebase Console and download the JSON file.
   - Add the path to the Firebase credentials in your `.env` file:
     ```env
     FIREBASE_CREDENTIALS_PATH=./hanya/hanya.json
     FIREBASE_PROJECT_ID=chat-ws-89088
     ```

5. **Configure the `.env` File:**
   Create a `.env` file in the root of the project and add the following configuration:
   ```env
   FIREBASE_CREDENTIALS_PATH=./hanya/hanya.json
   FIREBASE_PROJECT_ID=chat-ws-89088
   ```

6. **Run Database Migrations (Optional):**
   If your app uses migrations, you can run them using Go. Otherwise, you can set up your tables manually:
   ```bash
   go run main.go migrate
   ```

7. **Start the Server:**
   To run the backend, use:
   ```bash
   go run main.go
   ```

   The server will be running at `http://localhost:8080`.

---

## **API Endpoints**
The following endpoints are available for authentication and WebSocket communication:

### **WebSocket Endpoint**
- **URL:** `ws://localhost:8080/ws`
- **Headers:**
  - `Authorization: Bearer <your_token>`

### **HTTP Endpoints**
| Method | Endpoint               | Description               |
|--------|------------------------|---------------------------|
| POST   | `/api/auth/login`       | User login                |
| POST   | `/api/auth/register`    | User registration         |
| GET    | `/api/users`            | Fetch the list of users   |

---

## **Known Issues**
- **WebSocket reconnection logic** may occasionally fail on certain network configurations.
- **Database migration scripts** might not work perfectly with every version of PostgreSQL.

---

## **Contributing**
We welcome contributions! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add: [describe your feature in Bahasa Indonesia]"
   ```
4. Push to your branch and create a pull request.

---

## **Branch Comparison**
| Feature                | Main     | Development | KG       |
|------------------------|----------|-------------|----------|
| Stable version         | ✅       | ❌          | ❌       |
| New features           | ❌       | ✅          | ❌       |
| External API support   | ❌       | ❌          | ✅       |

---

## **Contact**
For any questions or issues, reach out:
- **GitHub:** [@raafihilmi](https://github.com/raafihilmi)
