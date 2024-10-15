terraform {

}
variable "planets" {
  type = list(any)
}

variable "planet_map" {
  type = map(any)
}
variable "planet_splats" {
  type = list(any)
}
