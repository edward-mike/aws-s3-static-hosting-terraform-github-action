# Project outputs
output "static_website_s3_endpoint" {
  value = aws_s3_bucket_website_configuration.my_static_website.website_endpoint
}

output "static_website_cdn_endpoint" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
