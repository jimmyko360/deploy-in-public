resource "aws_ecr_repository" "my-tf-images" {
  name         = "${var.app_name}-images"
  force_delete = true
}
