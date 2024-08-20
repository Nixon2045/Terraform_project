terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "pruebita-example" {
  name = "example-resource-group"
  location = "west europe"
}


#configuracion de dependencia implicita

resource "azurerm_resource_group" "Rg2" {
  name = "Rg2"
  location = "west europe"
  tags = {
    dependency = azurerm_resource_group.pruebita-example.name
  }
}
#configuracion de dependencia explicita
resource "azurerm_resource_group" "Rg3" {
  name = "Rg3"
  location = "west europe"
  depends_on = [
    azurerm_resource_group.Rg2
  ]
}

# crearemos o declararemos una variable de entrada que seria como especificar un 
# input en python

variable "image_id"{
  type = string # siendo una variable de tipo string solo aceptara caracteres, no es una lista o aceptara numeros
  default = "abc"
}

variable "image_id_example_0"{
  type = list(string) #te esta forma esta declarando una variable lista de caracter string o cadenas
  default = ["abc"] #especficiando entre corchetes que ese strinng o cadena sera el valor por defecto
}

# crearemos una variable tipo objeto donde podremos especificar propiedades especificas de ese objeto
variable "docker_ports"{
  type = list(object({
    internal = number
    external = number
    protocol = string
  }) )
  default = [
    {
      internal = 5000
      external = 4000
      protocol = "tcp"
    }

  ]
}

#solicitamos con una variable el nombre que llevara el recurso a crearse en el siguiente bloque
variable "project_name"{
  type = string
  description = "Nombre de la variable que quiere crear" # ---> de aqui a terminar el bloque fue creado en la clase 22 de terraform
  validation {                                           # 
        condition = length(var.project_name) > 4
        error_message = "El nombre es demasiado corto"
  }
}


resource "azurerm_resource_group" "variablesexample" {
  name = var.project_name ##aqui es donde utilizamos la variable anterior para dar nombre al recurso que el usuario escogio
  location = "west europe"
} # algo de modificacion