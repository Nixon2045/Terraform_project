variable "rg_name" {
    type = string
}

variable "rg_location" {
    type = string
    default = "westus"
}

variable "vnet_name" { 
    type = string 

}

variable "vnet_cidr_range" {
    type  = string
    default = "10.0.0.0/16"
}

variable "subnet_prefixes" { 
    type  = list(string)
    default = ["10.0.0.0/24", "10.0.1.0/24"]
}

 variable "subnet_names" {
    type = list(string)
    default = ["web", "database"]
 }