import boto3
import pandas as pd

s3_resource = boto3.resource("s3")
s3_client = boto3.client("s3")
buckets = s3_resource.buckets.all()
data = []

# This section will iterate over each bucket in the account your authenticated to, and tell if you each bucket uses KMS, AES256 or NO ENCRYPTION.

for bucket in buckets:
    try:
        encryption = s3_client.get_bucket_encryption(Bucket=bucket.name)
        if encryption["ServerSideEncryptionConfiguration"]["Rules"][0]["ApplyServerSideEncryptionByDefault"]["SSEAlgorithm"] == "aws:kms":
            print(bucket.name, 'aws:kms')
            data.append([bucket.name, 'aws:kms'])
        elif encryption["ServerSideEncryptionConfiguration"]["Rules"][0]["ApplyServerSideEncryptionByDefault"]["SSEAlgorithm"] == "AES256":
            print(bucket.name, 'AES256')
            data.append([bucket.name, 'AES256'])
    except Exception as e:
        if e.response["Error"]["Code"] == "ServerSideEncryptionConfigurationNotFoundError":
            print(bucket.name,'No Encryption')
            data.append([bucket.name, 'No Encryption'])

# Create a pandas dataframe to store the data
df = pd.DataFrame(data, columns=['Bucket Name', 'Encryption'])

# Save the dataframe to a Excel file
df.to_excel('vpn-testing-bucket_encryption.xlsx', index=False)
