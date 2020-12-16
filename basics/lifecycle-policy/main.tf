resource "local_file" "file" {
    filename = var.filename
    file_permission =  var.permission
    content = "This is a random string - ${random_string.string.id}"
    # In this example, the filename argument for the local_file resource has to be unique which means that we cannot have two instances of the same file created at the same time!
    # lifecycle {
    #  create_before_destroy = true
    # }

}

resource "random_string" "string" {
    length = var.length
    keepers = {
        length = var.length
    }
    lifecycle {
        create_before_destroy =  true
    }

}
