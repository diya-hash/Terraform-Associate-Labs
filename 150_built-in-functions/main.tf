terraform {

}
variable "str" {
  type    = string
  default = ""
}
variable "items" {
  type    = list(any)
  default = [null, null, "hello", "", "last"]

}
variable "stuff" {
  type = map(any)
  default = {
    "animal" = "koala"
    "insect" = "butterfly"
  }
}
