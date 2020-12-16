resource "random_pet" "super_pet" {
    length = var.length
    prefix = var.prefix
    lifecycle {
      prevent_destroy = true
    }

}
