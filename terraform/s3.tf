resource "aws_s3_bucket" "artifacts-backend" {
  bucket = "artifacts-backend"
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "p" {
 bucket = "${aws_s3_bucket.artifacts-backend.id}"
 policy =<<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": [
                "${aws_s3_bucket.artifacts-backend.arn}",
                "${aws_s3_bucket.artifacts-backend.arn}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpc": "${module.vpc.vpc_id}"
                }
            }
        }
    ]
}
POLICY
}