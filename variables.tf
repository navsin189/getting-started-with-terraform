variable "rds_subnet" {
  type = list(string)
  default = [
    "172.31.36.0/24",
    "172.31.37.0/24",
  ]
}

variable "key_path" {
  type = string
  default = "C:/Users/Naveen.Singh/.ssh/id_rsa.pub"
}