variable "site_bucket" {}
variable "force_destroy" { default = false }
variable "cloudfront_distribution_arn" { default = "" }

resource "aws_s3_bucket" "site" {
  bucket        = var.site_bucket
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  depends_on = [aws_s3_bucket.site]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowCloudFrontServicePrincipal"
      Effect    = "Allow"
      Principal = { Service = "cloudfront.amazonaws.com" }
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = var.cloudfront_distribution_arn
        }
      }
    }]
  })
}

output "site_bucket" {
  value = aws_s3_bucket.site.id
}