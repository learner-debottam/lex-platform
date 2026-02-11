#!/bin/bash
# Script to create S3 bucket and DynamoDB table for Terraform state

set -e

BUCKET_NAME="lex-platform-tfstate"
DYNAMODB_TABLE="lex-platform-tfstate-lock"
REGION="eu-west-2"

echo "Creating S3 bucket for Terraform state..."
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION \
  || echo "Bucket already exists"

echo "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

echo "Enabling encryption on S3 bucket..."
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "Blocking public access to S3 bucket..."
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "Creating DynamoDB table for state locking..."
aws dynamodb create-table \
  --table-name $DYNAMODB_TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION \
  || echo "DynamoDB table already exists"

echo ""
echo "✅ S3 backend setup complete!"
echo ""
echo "Bucket: $BUCKET_NAME"
echo "DynamoDB Table: $DYNAMODB_TABLE"
echo "Region: $REGION"
echo ""
echo "Next steps:"
echo "1. Run 'terraform init' in each environment directory"
echo "2. If migrating from local state, run 'terraform init -migrate-state'"
