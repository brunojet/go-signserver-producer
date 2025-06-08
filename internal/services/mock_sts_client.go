package services

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/service/sts"
	"github.com/aws/aws-sdk-go-v2/service/sts/types"
)

type MockSTSClient struct {
	AssumeRoleFunc func(ctx context.Context, params *sts.AssumeRoleInput, optFns ...func(*sts.Options)) (*sts.AssumeRoleOutput, error)
}

func (m *MockSTSClient) AssumeRole(ctx context.Context, params *sts.AssumeRoleInput, optFns ...func(*sts.Options)) (*sts.AssumeRoleOutput, error) {
	if m.AssumeRoleFunc != nil {
		return m.AssumeRoleFunc(ctx, params, optFns...)
	}
	return &sts.AssumeRoleOutput{
		Credentials: &types.Credentials{
			AccessKeyId:     awsString("mock-access-key"),
			SecretAccessKey: awsString("mock-secret-key"),
			SessionToken:    awsString("mock-session-token"),
		},
	}, nil
}

func awsString(s string) *string { return &s }
