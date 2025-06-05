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
	case "sts_temporary_credentials":
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
		// Conversão explícita para *types.Credentials se necessário
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
	case "presigned_url", "":
		// Default para presigned_url
		s3svc, err := services.NewS3Service(bucket)
		if err != nil {
			c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Erro ao inicializar serviço S3"})
			return
		}
		presignedURL, err := s3svc.GeneratePresignedURL(req.FileName, 15*time.Minute)
		if err != nil {
			c.JSON(http.StatusInternalServerError, models.UploadResponse{Error: "Erro ao gerar presigned URL"})
			return
		}
		c.JSON(http.StatusOK, models.UploadResponse{
			Message: "Presigned URL gerada com sucesso",
			Payload: gin.H{
				"presigned_url": presignedURL,
			},
		})
		return
	default:
		c.JSON(http.StatusBadRequest, models.UploadResponse{Error: "upload_method inválido"})
	}
}
