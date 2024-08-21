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
  description = "Nombre de la variable que quiere crear"
  validation {        
        condition = length(var.project_name) > 4
        error_message = "El nombre es demasiado corto"
  }
}


resource "azurerm_resource_group" "variablesexample" {
  name = var.project_name ##aqui es donde utilizamos la variable anterior para dar nombre al recurso que el usuario escogio
  location = "west europe"
}

  # Clase 23 - cadenas interpoladas
  #si quieremos reutilizar una variable para un recurso diferente 
  #solo debemos agregar "" comillas como si fuera un string y seguido ponemos un signo de pesos $
  #abrimos llaves {} quedando con la siguiente sintaxis "${var.project_name}_main" donde al final de la sintaxis
  #agregamos el texto que nos ayudara a diferencia a un bloque del otro
  # y si queremos agregar una nueva cadena interpolada la sintaxis seria "${var.project_name}_main ${var.variable_nueva}_ejemplodiferenciador"
  #realizare el ejemplo con la variable project_name

# Reutilizaremos el recurso anterior que usa la variable de project_name para tomar el nombre del recurso
resource "azurerm_resource_group" "variablesexample2" {
  name = "${var.project_name}_main" 
  location = "west europe"
}

resource "azurerm_resource_group" "variablesexample3" {
  name = "${var.project_name}_secundary"
  location = "west europe"
}

#Clase 24 - locals values (valores locales)
# son valores locales que se asignan o se pueden asignar a un recurso
#realizare el ejemplo con la creacion del recurso anterior 

locals{
  RG1 = azurerm_resource_group.variablesexample.id
  tag = "development"
}


resource "azurerm_resource_group" "variablesexample4" {
  name = "${var.project_name}_secundary"
  location = "west europe"
  tags = {
    "team" = local.tag
  }
}

# Clase 25 - Propiedad Count 
#La propiedad Count viene por defecto en cada uno de los bloques que creamos de recursos en terraform
# y su valor por defult es 1, si cambiamos su valor a por ejemplo 3 se crearan 3 recursos con los parametros de este bloque
# lo ejemplificare con el recurso de variableexaple5

resource "azurerm_resource_group" "variablesexample5" {
  count = 0 #PRO TIP = Si cambiamos el valor de count a 0 eliminamos todos los recursos ligados a este bloque facilitando la eliminacion de recursos
  name = "${var.project_name}_secundary${count.index}"
  location = "west europe"
  tags = {
    "team" = local.tag
  }
}