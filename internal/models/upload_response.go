package models

// UploadResponse representa a resposta enviada ao cliente após a solicitação de upload.
type UploadResponse struct {
	Message string      `json:"message"`
	Payload interface{} `json:"payload,omitempty"`
	Error   string      `json:"error,omitempty"`
}
