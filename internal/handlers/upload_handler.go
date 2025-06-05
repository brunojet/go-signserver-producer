package handlers

import (
	"net/http"
	"github.com/gin-gonic/gin"
	"github.com/brunojet/go-signserver-producer/internal/models"
)

// UploadRequestHandler lida com a solicitação de upload de APK.
func UploadRequestHandler(c *gin.Context) {
	var req models.UploadRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Dados inválidos"})
		return
	}
	// Aqui futuramente será chamada a service para gerar a presigned URL
	c.JSON(http.StatusOK, gin.H{"message": "Solicitação de upload recebida", "payload": req})
}
