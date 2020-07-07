resource "aws_ecr_repository" "test" {
  name                 = "nginx"
  image_tag_mutability = "MUTABLE"

}
