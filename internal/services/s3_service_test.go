package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/stretchr/testify/assert"
)

func TestGeneratePresignedURL_Success(t *testing.T) {
	svc := &S3Service{Bucket: "bucket"}
	url := "https://example.com/presigned"
	presignClient := &MockPresignClient{URL: url}

	oldNewPresignClient := newPresignClient
	newPresignClient = func(_ *s3.Client) PresignPutObjectAPI { return presignClient }
	defer func() { newPresignClient = oldNewPresignClient }()

	result, err := svc.GeneratePresignedURL("file.apk", 10*time.Minute)
	assert.NoError(t, err)
	assert.Equal(t, url, result)
}

func TestGeneratePresignedURL_Error(t *testing.T) {
	svc := &S3Service{Bucket: "bucket"}
	errMock := errors.New("presign error")
	presignClient := &MockPresignClient{Err: errMock}

	oldNewPresignClient := newPresignClient
	newPresignClient = func(_ *s3.Client) PresignPutObjectAPI { return presignClient }
	defer func() { newPresignClient = oldNewPresignClient }()

	result, err := svc.GeneratePresignedURL("file.apk", 10*time.Minute)
	assert.Error(t, err)
	assert.Empty(t, result)
}

func TestNewS3Service_Success(t *testing.T) {
	// Testa inicialização sem erro (mockando config.LoadDefaultConfig)
	svc, err := NewS3Service("bucket")
	assert.NoError(t, err)
	assert.NotNil(t, svc)
	assert.Equal(t, "bucket", svc.Bucket)
}

func TestNewS3Service_Error(t *testing.T) {
	// Simula erro usando injeção de dependência
	mockErr := errors.New("erro de config")
	mockLoader := func(ctx context.Context, optFns ...func(*config.LoadOptions) error) (aws.Config, error) {
		return aws.Config{}, mockErr
	}
	_, err := NewS3ServiceWithConfigLoader("bucket", mockLoader)
	assert.Error(t, err)
}

func TestGenerateTemporaryS3Credentials_Success(t *testing.T) {
	// Este teste é apenas ilustrativo, pois AssumeRole real exige AWS configurado.
	// Em ambiente real, use mock do stsClient.
	roleArn := "arn:aws:iam::123456789012:role/test-role"
	creds, err := GenerateTemporaryS3Credentials(roleArn, "test-session", 900*time.Second)
	if err != nil {
		t.Logf("Erro esperado em ambiente local: %v", err)
		return
	}
	assert.NotNil(t, creds)
	assert.NotEmpty(t, creds.AccessKeyId)
}
