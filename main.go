package main

import (
	"github.com/brunojet/go-signserver-producer/internal/handlers"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.POST("/upload/request", handlers.UploadRequestHandler)

	r.Run(":8080")
}
