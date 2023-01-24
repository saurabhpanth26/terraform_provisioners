data "terraform_remote_state" "network_details" {
  backend = "s3"
  config = {
    bucket = "john.07-bucket"
    key    = "john.07-network-state"
    region = "ap-south-1"
  }
}

resource "aws_instance" "my_vm" {
  ami                    = "ami-06984ea821ac0a879"
  subnet_id              = data.terraform_remote_state.network_details.outputs.my_subnet
  key_name               = data.terraform_remote_state.network_details.outputs.key_name
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
  instance_type          = "t2.micro"
  tags = {
    Name = "john.07-vm1"
  }
}







