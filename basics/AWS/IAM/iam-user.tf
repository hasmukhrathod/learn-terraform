resource "aws_iam_user" "users" {
  name = var.project-abc-users[count.index]
  count = length(var.project-abc-users)
}
