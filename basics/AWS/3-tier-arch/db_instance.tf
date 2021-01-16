resource "aws_db_subnet_group" "db_tier_subnet_group" {
  provider   = aws.us-east
  name       = var.db_tier_subnet_group
  subnet_ids = [aws_subnet.db_tier_subnet1_az1.id, aws_subnet.db_tier_subnet2_az2.id]
  tags = {
    Name = "${var.project_env}-${var.project_name}-db-tiers-subnet-group"
  }
}

resource "aws_db_instance" "test-db" {
  provider               = aws.us-east
  identifier             = "${var.project_env}-${var.project_name}-new-db"
  allocated_storage      = var.db_storage_allocation
  storage_type           = var.db_storage_type
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.db_tier_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_tier_subnet_group.name
  skip_final_snapshot    = true
}
