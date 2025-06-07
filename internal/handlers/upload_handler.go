package handlers

import (
	"net/http"
	"os"
	"time"

	"github.com/brunojet/go-signserver-producer/internal/models"
	"github.com/brunojet/go-signserver-producer/internal/services"
	"github.com/gin-gonic/gin"
)

// UploadRequestHandler lida com a solicitação de upload de APK.
func UploadRequestHandler(c *gin.Context) {
	var req models.UploadRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.UploadResponse{Error: "Dados inválidos"})
		return
	}

	bucket := os.Getenv("S3_BUCKET")
	if bucket == "" {
		c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Bucket S3 não configurado"})
		return
	}

	switch req.UploadMethod {
	case models.UploadMethodSTSTemporaryCredentials:
		roleArn := os.Getenv("S3_UPLOAD_ROLE_ARN")
		if roleArn == "" {
			c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Role ARN não configurado"})
			return
		}
		creds, err := services.GenerateTemporaryS3Credentials(roleArn, "upload-session", 15*time.Minute)
		if err != nil {
			c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Erro ao gerar credenciais temporárias"})
			return
		}
		c.JSON(http.StatusOK, models.UploadResponse{
			Message: "Credenciais temporárias geradas com sucesso",
			Payload: gin.H{
				"access_key_id":     *creds.AccessKeyId,
				"secret_access_key": *creds.SecretAccessKey,
				"session_token":     *creds.SessionToken,
				"expiration":        creds.Expiration,
			},
		})
		return
	case models.UploadMethodPresignedURL, "":
		// Default para presigned_url usando presigned POST com limite de tamanho
		s3svc, err := services.NewS3Service(bucket)
		if err != nil {
			c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Erro ao inicializar serviço S3"})
			return
		}
		postData, err := s3svc.GeneratePresignedPostURL(req.FileName, 15*time.Minute, req.FileSize)
		if err != nil {
			c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Erro ao gerar presigned POST"})
			return
		}
		c.JSON(http.StatusOK, models.UploadResponse{
			Message: "Presigned POST gerado com sucesso",
			Payload: postData,
		})
		return
	default:
		c.JSON(http.StatusBadRequest, models.UploadResponse{Error: "upload_method inválido"})
	}
}
