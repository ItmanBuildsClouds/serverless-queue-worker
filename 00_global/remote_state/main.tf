resource "random_string" "suffix" {
    length = 6
    special = false
    upper = false
}

resource "aws_s3_bucket" "remote_bucket" {
    bucket = "${var.project_name}-${random_string.suffix.result}"

    tags = {
      Project = var.project_name
    }
    lifecycle {
        prevent_destroy = true
    }
}
resource "aws_s3_bucket_versioning" "remote_bucket_versioning" {
    bucket = aws_s3_bucket.remote_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
  }
resource "aws_s3_bucket_public_access_block" "remote_bucket_public_access_block" {
    bucket = aws_s3_bucket.remote_bucket.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}
