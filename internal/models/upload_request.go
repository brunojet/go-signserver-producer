package models

// UploadMethod define os métodos suportados para upload.
type UploadMethod string

const (
	UploadMethodPresignedURL            UploadMethod = "presigned_url"
	UploadMethodSTSTemporaryCredentials UploadMethod = "sts_temporary_credentials"
)

// UploadRequest representa o payload recebido para solicitar o upload de um APK.
type UploadRequest struct {
	DeviceProfile string       `json:"device_profile"`
	FileName      string       `json:"file_name"`
	FileSize      int64        `json:"file_size"`
	FileHash      string       `json:"file_hash"` // Hash do arquivo (ex: SHA-256) enviado pelo cliente
	UploadMethod  UploadMethod `json:"upload_method"`
}
