variable "rds_subnet" {
  type = list(string)
  default = [
    "172.31.36.0/24",
    "172.31.37.0/24",
  ]
}