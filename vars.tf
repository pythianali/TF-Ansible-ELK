variable "AWS_REGION" {
  default = "us-east-1"
}


variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-1f3c9f09" # ubuntu 16.04 LTS
    }
}

