# Bucket for file storage for static resources
resource "aws_s3_bucket" "storage_public" {
  bucket = "php-bref-demo-symfony-app-static"

  tags = {
    Name = "php-bref-demo-symfony-app-static"
  }
}

resource "aws_s3_bucket_policy" "allow_from_cloudfront" {
  bucket = aws_s3_bucket.storage_public.id
  policy = data.aws_iam_policy_document.allow_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_from_cloudfront" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.storage_public.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.distribution.arn]
      variable = "AWS:SourceArn"
    }
  }
}

# CDN
resource "aws_cloudfront_distribution" "distribution" {
  enabled = true
  aliases = ["bref.terracloud.fr"]

  price_class = "PriceClass_100"

  origin {
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }

    custom_header {
      name  = "x-forwarded-host"
      value = "bref.terracloud.fr"
    }

    domain_name = aws_api_gateway_domain_name.api_bref.domain_name
    origin_id   = "api"
  }

  origin {
    domain_name              = aws_s3_bucket.storage_public.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.storage_public.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_s3.id
  }

  ordered_cache_behavior {
    allowed_methods          = ["HEAD", "GET"]
    cached_methods           = ["HEAD", "GET"]
    path_pattern             = "assets/*"
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" #Hard-Coded: Caching optimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" #Hard-Coded CORS-S3Origin - see https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html#managed-origin-request-policy-cors-s3
  }

  ordered_cache_behavior {
    path_pattern             = "*.jpg"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.png"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.gif"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.svg"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.woff*"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.ttf"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.js"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ordered_cache_behavior {
    path_pattern             = "*.css"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.storage_public.id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = "api"
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" #Hard-Coded: CachingDisabled
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac" #Hard-Coded: Forward all headers EXCEPT HOST, cookies and query strings
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.root_bref.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "oac_s3" {
  name                              = "cloudfront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Certificate for bref.terracloud.fr
# NB : here I'm creating Route53 entries to validate certificate manually (in another account)
# but there is a nice module to do it all at once.
resource "aws_acm_certificate" "root_bref" {
  provider = aws.us-east-1
  domain_name       = "bref.terracloud.fr"
  validation_method = "DNS"
}

# Push static assets to S3 Bucket
module "thisdir" {
  source  = "registry.terraform.io/hashicorp/dir/template"
  version = "1.0.2"
  base_dir = "../SymfonyApp/public/assets"
}

resource "aws_s3_object" "dist" {
  for_each = module.thisdir.files

  bucket = aws_s3_bucket.storage_public.bucket
  key    = "assets/${each.key}"
  source = each.value.source_path
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag   = each.value.digests.md5
  content_type = each.value.content_type

  lifecycle {
    create_before_destroy = true
  }
}