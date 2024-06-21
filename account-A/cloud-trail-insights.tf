
# this is file consists cloud trail service
# It will log the tasks/actions performed on EC2 instance and S3 bucket


resource "aws_cloudtrail" "my-demo-cloudtrail" {
  name                          = "my-demo-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.s3_bucket_cloudtrail_event_detection.id
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.guardduty_logging_key.arn
  depends_on                    = [aws_s3_bucket_policy.s3_access_policy, aws_s3_bucket.s3_bucket_cloudtrail_event_detection, aws_kms_key.guardduty_logging_key]
}