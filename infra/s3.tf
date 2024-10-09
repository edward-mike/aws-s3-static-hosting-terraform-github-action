#######################################
# Configuration for S3 Bucket Storage #
#######################################

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# setup bucket name
resource "aws_s3_bucket" "static_storage" {
  bucket = "tf-github-actions-demo-bucket-${random_id.bucket_suffix.hex}"
}

# bucket public access settings
resource "aws_s3_bucket_public_access_block" "static_storage" {
  bucket                  = aws_s3_bucket.static_storage.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# bucket policy settings
resource "aws_s3_bucket_policy" "static_storage_public_read_only" {
  bucket = aws_s3_bucket.static_storage.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"                          # read only action
        Resource  = "${aws_s3_bucket.static_storage.arn}/*" # access to all objects under bucket.
      }
    ]
  })

  # optional - but okay to add explicitly avoid race condition
  depends_on = [aws_s3_bucket.static_storage, aws_s3_bucket_public_access_block.static_storage]
}


# configure bucket to host website or application
resource "aws_s3_bucket_website_configuration" "my_static_website" {
  bucket = aws_s3_bucket.static_storage.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


# configure bucket object to host website or application via tf
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_storage.id
  key          = "index.html"
  source       = "../website/index.html"
  etag         = filemd5("../website/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_storage.id
  key          = "error.html"
  source       = "../website/error.html"
  etag         = filemd5("../website/error.html")
  content_type = "text/html"
}
