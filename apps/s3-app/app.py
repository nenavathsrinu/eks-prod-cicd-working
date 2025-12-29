import boto3

s3 = boto3.client("s3", region_name="ap-south-2")

obj = s3.get_object(
    Bucket="eks-prod-dev-tf-state",
    Key="test.txt"
)

print(obj["Body"].read().decode())
