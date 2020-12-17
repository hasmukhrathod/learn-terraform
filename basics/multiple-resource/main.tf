resource "local_file" "name" {
    filename = each.value
    sensitive_content = var.content
    for_each = toset(var.users)

}
