provider "aws" {
  alias                   = "default"
  profile                 = "${var.profile}"
  region                  = "us-east-1"
  shared_credentials_file = "${var.shared_credentials_file}"
}

resource "aws_s3_bucket" "static" {
  provider = "aws.default"
  bucket   = "static.${var.hostname}"
  acl      = "public-read"

  logging {
    target_bucket = "${var.logging_bucket}"
    target_prefix = "static/s3/"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_object" "index" {
  count        = "${length(var.bucket_names)}"
  provider     = "aws.default"
  bucket       = "${aws_s3_bucket.static.id}"
  key          = "${var.bucket_names[count.index]}/index.html"
  source       = "${path.module}/index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "robots" {
  count        = "${length(var.bucket_names)}"
  provider     = "aws.default"
  bucket       = "${aws_s3_bucket.static.id}"
  key          = "${var.bucket_names[count.index]}/robots.txt"
  source       = "${path.module}/robots.txt"
  acl          = "public-read"
  content_type = "text/plain"
}

resource "aws_cloudfront_distribution" "static" {
  count               = "${length(var.bucket_names)}"
  provider            = "aws.default"
  aliases             = ["${var.bucket_names[count.index]}.${var.hostname}"]
  default_root_object = "index.html"
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "Static Site: ${var.bucket_names[count.index]}.${var.hostname}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  logging_config {
    bucket          = "${var.logging_bucket}.s3.amazonaws.com"
    include_cookies = false
    prefix          = "static/cloudfront/${var.bucket_names[count.index]}/"
  }

  origin {
    domain_name = "${aws_s3_bucket.static.id}.s3.amazonaws.com"
    origin_id   = "Static Site: ${var.bucket_names[count.index]}.${var.hostname}"
    origin_path = "/${var.bucket_names[count.index]}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.acm_certificate_arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "static" {
  count    = "${length(var.bucket_names)}"
  provider = "aws.default"
  zone_id  = "${var.zone_id}"
  name     = "${var.bucket_names[count.index]}.${var.hostname}"
  type     = "CNAME"
  ttl      = "300"
  records  = ["${element(aws_cloudfront_distribution.static.*.domain_name, count.index)}"]
}
