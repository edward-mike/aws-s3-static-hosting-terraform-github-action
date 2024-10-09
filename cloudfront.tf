# resource "aws_cloudfront_distribution" "website_distribution" {
#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "website/index.html"

#   origin {
#     domain_name = aws_s3_bucket_website_configuration.my_static_website.website_endpoint
#     origin_id   = aws_s3_bucket.static_storage.bucket

#     custom_origin_config {
#       origin_protocol_policy   = "http-only"
#       origin_ssl_protocols     = ["TLSv1.2"]
#       http_port                = 80
#       https_port               = 443
#     }
#   }

#   custom_error_response {
#     error_code = 404
#     response_code = 404
#     response_page_path = "website/error.html"
#   }

# #   aliases = [ var.domain ]

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#       locations        = []
#     }
#   }

#   default_cache_behavior {
#     viewer_protocol_policy = "redirect-to-https"

#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = aws_s3_bucket.static_storage.bucket

#     compress = true

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn      = aws_acm_certificate.domain_cert.arn
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }
# }

# # ###########  

resource "random_password" "custom_header" {
  length      = 13
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.my_static_website.website_endpoint
    origin_id   = aws_s3_bucket.static_storage.bucket

    custom_header {
      name  = "Referer"
      value = random_password.custom_header.result
    }
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "static hosting cdn"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static_storage.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
