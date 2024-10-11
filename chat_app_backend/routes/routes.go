package routes

import (
	"chat_app_backend/controllers"
	"chat_app_backend/middlewares"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	auth := r.Group("/api/auth")
	{
		auth.POST("/register", controllers.Register)
		auth.POST("/login", controllers.Login)
	}

	api := r.Group("/api").Use(middlewares.AuthMiddleware())
	{
		api.GET("/chats/:user_id", controllers.GetChatHistory)
		api.POST("/chats/:user_id", controllers.SendMessage)

		api.POST("/block/:user_id", controllers.BlockUser)
		api.DELETE("/block/:user_id", controllers.UnblockUser)
		api.GET("/block", controllers.GetBlockedUsers)

		api.GET("/users/available", controllers.GetAllUsersExceptBlockedUsers)

		api.POST("/report/user/:user_id", controllers.ReportUser)
		api.POST("/report/message/:message_id", controllers.ReportMessage)

		api.POST("/groups", controllers.CreateGroup)
		api.GET("/groups", controllers.GetUserGroups)
		api.POST("/groups/:group_id/members", controllers.AddGroupMember)
		api.POST("/groups/:group_id/messages", controllers.SendGroupMessage)
	}

	r.GET("/ws", middlewares.AuthMiddleware(), controllers.HandleWebSocket)
}
