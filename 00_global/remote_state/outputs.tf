output "remote_s3_name" {
    value = aws_s3_bucket.remote_bucket.id
}
output "remote_dynamodb_name" {
    value = aws_dynamodb_table.remote_locks.name
}