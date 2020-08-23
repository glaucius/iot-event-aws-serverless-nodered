variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_REGION_AZ_WEB_1" {
  default = "us-east-1a"
}
variable "AWS_REGION_AZ_WEB_2" {
  default = "us-east-1b"
}
variable "AWS_REGION_AZ_WEB_3" {
  default = "us-east-1c"
}
variable "AWS_REGION_AZ_DB" {
  default = "us-east-1b"
}

variable "PRIVATE_KEY_PATH" {
  default = "minha-chave-ssh"
}

variable "PUBLIC_KEY_PATH" {
  default = "minha-chave-ssh.pub"
}

variable "BUCKET_ELB" {
  default = "bucketelbglauciusha20192020"
}
