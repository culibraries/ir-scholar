import boto3
from botocore.exceptions import ClientError
import logging

def xmltos3(file_name):
    s3 = boto3.client('s3', region_name='us-west-2')
    try:
        uploadObject = s3.upload_file(
            file_name, 'cubl-static', 'samvera/metadata')
    except ClientError as e:
        logging.error(e)
        return False
    return uploadObject
