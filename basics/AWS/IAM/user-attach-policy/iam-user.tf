resource "aws_iam_user" "admin_user" {
  name = "hasmukh"
}

resource "aws_iam_policy" "admin_policy" {
  name = "AdminUsers"
  policy = file("admin-policy.json")
}

resource "aws_iam_user_policy_attachment" "hasmukh_admin_user" {
  user = aws_iam_user.admin_user.name
  policy_arn = aws_iam_policy.admin_policy.arn
}


