package services

import (
	"context"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

// S3Service encapsula operações com o S3.
type S3Service struct {
	Client *s3.Client
	Bucket string
}

// NewS3Service inicializa o serviço S3.
func NewS3Service(bucket string) (*S3Service, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return nil, err
	}
	client := s3.NewFromConfig(cfg)
	return &S3Service{Client: client, Bucket: bucket}, nil
}

// GeneratePresignedURL gera uma URL presignada para upload de arquivo.
func (s *S3Service) GeneratePresignedURL(key string, expires time.Duration) (string, error) {
	presignClient := s3.NewPresignClient(s.Client)
	params := &s3.PutObjectInput{
		Bucket: aws.String(s.Bucket),
		Key:    aws.String(key),
	}
	presignedReq, err := presignClient.PresignPutObject(context.TODO(), params, func(opts *s3.PresignOptions) {
		opts.Expires = expires
	})
	if err != nil {
		return "", err
	}
	return presignedReq.URL, nil
}
