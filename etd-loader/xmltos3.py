import boto3
from botocore.exceptions import ClientError
import logging

def xmltos3(file_name):
    s3 = boto3.client('s3', region_name='us-west-2')
    try:
        bucket_name = 'cubl-static'
        key = 'samvera/metadata' + '/' + file_name
        uploadObject = s3.upload_file(file_name, bucket_name, key)
        location = s3.get_bucket_location(Bucket=bucket_name)['LocationConstraint']
        url = 'https://s3-{0}.amazonaws.com/{1}/{2}'.format(location, bucket_name, key)
        return url
    except ClientError as e:
        logging.error(e)
        return False
    return uploadObject
