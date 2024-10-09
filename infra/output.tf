# Project outputs
output "static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.my_static_website.website_endpoint
}
