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
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/ubuntu/terraform_base/keys/john.07")
      host        = self.public_ip
    }
  }
}




