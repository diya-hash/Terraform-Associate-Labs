terraform{

}
module "apache" {
 source = ".//terraform-aws-apache-example"
 vpc_id = "vpc-06d5575973a832582"
 my_ip_with_cidr = "99.240.67.76"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkNvI+H3XQUQAxor2xxx0QY2jwJwhPhP1mD+ETduDy/u58jkO9PZdr6uD9/7akNi8Hi48hwl9w9EACO5vgfD4H4OQ2KMOl8/0JCyhMQSiGISSc+j3Af9xfzgIP4qbRNSLpcIRLLEBFAJuE2vXpkhM4MCSF+jeksNXRLdfm3HyMVQiGnxIR1o/gEutLqdiQWxTMaxA0BICmU4IoyrmLN+jfpPdDq1GPvBWCoDVbDxYFjxabMq31g6SEBlZXsj2orpffJVgBA4zSqlzaUlttsE/oXHb7QZQ54omQAW+xMyecThN7LpyG/f/gLV95gHg2J02CGl10QdUDHQYnDMb522kwUiiu1iMvdnngssMmLMF+vbkDNmkRnquSh7f0qWyE87or9lqwx9KIbjCyYWJYoD4TjzpTCp+PAAlCCa0MiorBX2N5LOS7nB9iLtyZPo8+Fu6E/XBhtalb9t+4dV3BhcVaYuL9aGMWECQBHQMEmDQG9y9gpMJFqJxsj5ANyrTW+UE= shaikhdiyasalam@Shaikhs-MacBook-Air.local"
 instance_type = "t2.micro"
 server_name = "Apache Example server"
}
output "public_ip" {
  value = module.apache.public_ip
}
