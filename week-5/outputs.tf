output "ecr_repo_url" {
  value = aws_ecr_repository.my-tf-images.repository_url
}

output "alb_dns" {
  value = aws_alb.my-tf-alb.dns_name
}
