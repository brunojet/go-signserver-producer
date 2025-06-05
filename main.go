package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	// TODO: Adicionar middlewares de autenticação

	r.POST("/upload/request", func(c *gin.Context) {
		// TODO: Implementar geração de presigned URL
		c.JSON(200, gin.H{"message": "Solicitação de upload recebida"})
	})

	r.Run(":8080")
}
