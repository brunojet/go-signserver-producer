package models

// UploadRequest representa o payload recebido para solicitar o upload de um APK.
type UploadRequest struct {
	DeviceProfile string `json:"device_profile"`
	FileName      string `json:"file_name"`
	FileSize      int64  `json:"file_size"`
	FileHash      string `json:"file_hash"` // Hash do arquivo (ex: SHA-256) enviado pelo cliente
	// Novo campo para escolher o modo de upload: "presigned_url" ou "sts_temporary_credentials"
	UploadMethod string `json:"upload_method"`
}
