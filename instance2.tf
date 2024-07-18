resource "aws_instance" "docker_server1" {
  # ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.docker_server.id]
  key_name               = "asdfghj"
  ami = "ami-0faab6bdbac9486fb"
  #   vpc_id      = aws_vpc.lab-vpc.id
  subnet_id  = aws_subnet.public.id
  depends_on = [aws_subnet.public]
  user_data = <<EOF
  #!/bin/bash
 # Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt install docker.io

  EOF
  tags = {
    Name = "docker1"
  }
}

resource "aws_eip" "ansible_server_ip1" {
  instance = aws_instance.docker_server1.id
  vpc      = true
}
