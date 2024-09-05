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
<<<<<<< HEAD
} # algo de modificacion
=======
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
  name = "${var.project_name}_secundary${count.index}" #la propiedad index de count permite especificar un nombre a cada uno de los recursos empezando por 0 
  location = "west europe"
  tags = {
    "team" = local.tag
  }
}


#Clase 26 iterando con for_aech  
#existe una parametro en terraform para iterar sobre cada uno de los recursos creados y es atraves de la sintaxis for_each 
#donde con una variable especifica podemos nombrar e iterar un recurso
#en el caso de ejemplo vemos como con la variable local de names  pasamos a iterarlo en el for each del bloque del recurso creando asi 3 recursos
#con los nombres asignados en la varible local de names

locals {
  names = {
    name01 = "name01"
    name02 = "name02"
    name03 = "name03"
  }
}


resource "azurerm_resource_group" "variablesexample6" {
  for_each = local.names 
  name = "${each.value}"
  location = "west europe"
  tags = {
    "team" = local.tag
  }
}

# clase 27 - operadores en terraform 


locals {
  t_string = "cadena de texto"
  t_number = 123.45 # numeros enteros o con punto 
  t_booleano = true # o False dependiendo el caso 
  # una lista puede contener diferentes tipos de datos y se inicia con un par de corchetes
  t_list = [ 
    "lista compuesta de elementos",
    3540.45,
    true,
    false,
  ]
  t_map = {
    type_llave = "valor_Asignado_por_mi" # el dato tipo map corresponde a una llave y a un valor asignado, la llave puede llevar el nombre que quiera pero el valor sers el asignado por mi (tambien el que quiera o corresponda)
  }

 # tambien podemos declarar un tipo de dato complejo, por complejo me refiero a un dato que no se encuentra en terraform
 # que podemos asignarles diferentes tipos de datos
 #como el siguiente ejemplo
  costumer = {
    Name = "Nixon betancour"
    Age = 28
    # podemos adicionar una lista ya que es un tipo de dato
    Gustos = {
      deporte = "Basquetball", 
      comida_favorita = "sushi",
      Adddress_home = "La_mariana",
      Address_office = "La_rosa",
    }
  }
}

output "Llamada_a_locals" {
  value = local.costumer.Gustos.deporte
}

locals {
  t_operations = 1 / 1
}


locals {
  t_logical = 5 < 3
  t_logical2 = (5 < 3) && (4 > 2) # el && es un operador "and" comparando asi el conjunto de operacion y SI cumplen ambas condiciones u operaciones devolucion un booleano
  }


variable "Rg_count" {
  type = number
}

locals{
  min_Rg_number = 3 #valor por defecto dado el caso
  rg_no = var.Rg_count > 0 ? var.Rg_count : local.min_Rg_number
}

resource "azurerm_resource_group" "variablesexample7" {
  count = local.rg_no
  name = "rg_${count.index}"
  location = "west europe"
}

/* Clase 28 - Funciones en terraform 
Las funciones en terraform son bloques de codigo ya preconfigurado 
que pueden realizar operaciones matematicas o concatenar cadenas,
realizar validaciones de prueba o validar subnets.
son utiles y puedan dar dinamismo al codigo de terraform 
por eso es importante familiarizarse con sus sintaxis 

para cualquier la documentacion se encuentra en: https://developer.hashicorp.com/terraform/language/functions
*/

#funcion length()
variable "length_example" {
  default = "this string is very long"
}

output "result_lengt" {
  value = length(var.length_example)
} # El resultado de length es 24 debido a que es el numero de las letras y espacios en "this string is very long"

#funcion join()
variable "join_example" {
  default = ["this", "string", "is", "very", "long"
  ]
}

output "result_join" {
  value = join("-", var.join_example)
} # El resultado de join es "this-string-is-very-long" ya que concatena la lista de cadenas de texto en una sola cadena, separada por un delimitador

#funcion split()
variable "split_example" {
  default = "this-string-is-very-long"
}

output "split_result" {
  value = split("-", var.split_example)
}# El resultado de split es una lista de string de las cadenas de texto "this-string-is-very-long", separadas cada cadena por el delimitador "-"

#Funcion lookup()
variable "lookup_example" {
  default = {
    "name" = "example"
    "type" = "demo"
  }
}

output "lookup_result" {
  value = lookup(var.lookup_example, "name", "default_name")
} #El resultado de esta funcion lookup sera "example" ya que es el valor asignado al par key de "name"
#lookup() se utiliza para buscar un valor de una key en un mapa de una variable (mapa tambien conocido como diccionario)

#funcion cidrsubnet()

variable "cidrsubnet_example" {
  default = "192.168.0.0/16"
}

output "cidrsubnet_result" {
  value = cidrsubnet(var.cidrsubnet_example, 8, 1)
} #la funcion cidrsubnet calcula las subredes dentro de un rango dado de cidr 
#los argumentos dados de 8 y 1 son 8 como los bit a agregar a la mascara de red y 1 como el numero de la subnet que quiero escanear


/* Clase 29 - iteraciones en terraform 
*/

locals {
  names2 = ["Nixon", "Alejandra", "Carito"]
  mayus = [for i in local.names2: upper(i)]
  a_names = [for i in local.names2: i if substr(i,0,1) == "A"]
}

output mayus {
  value       = local.mayus
}

output a_names {
  value       = local.a_names
}


/* Clase 30 - Data sources o fuentes de datos 

Es informacion que esta fuera de terraform y podemos acceder a ella
a traves de los data sources, es de solo lectura, con los data sources 
no podemos crear ni eliminar datos de recursos, pero podemos hacer uso de esa informacion obtenida 
para usarla dentro de nuestra configuracion de terraform. 
*/

#ejemplo obteniendo el ID de un recurso creado como subnet para usarla como subnet de un nuevo recurso


data "azurerm_virtual_network" "example" {
  name = "my_vnet"
  id = "subnet-123456"
}

resource "azurerm_resource_group" "nuevogrupo" {
  id = data.azurerm_resource_group.example.id
  tags = {
    Name = "my_instance"
  }
}

#este ejemplo no sirvio ya que el recurso tiene que estar creado para buscar la informacion dentro de azure en este caso 
