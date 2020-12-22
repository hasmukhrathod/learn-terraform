resource "aws_iam_user" "project-sonic-users" {
  name = split(":",var.cloud_users)[count.index]
  count = length(split(":",var.cloud_users))
}
