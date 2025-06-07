package services

import (
	"context"

	v4 "github.com/aws/aws-sdk-go-v2/aws/signer/v4"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type MockPresignClient struct {
	URL string
	Err error
}

func (m *MockPresignClient) PresignPutObject(_ context.Context, _ *s3.PutObjectInput, _ ...func(*s3.PresignOptions)) (*v4.PresignedHTTPRequest, error) {
	if m.Err != nil {
		return nil, m.Err
	}
	return &v4.PresignedHTTPRequest{URL: m.URL}, nil
}
