terraform {
  
}
variable "planet" {
    type = list
    default = ["mars", "pluto", "moon"]
}
variable "plans" {
    type = map 
    default =  {
        "PlanA" = "Beach party",
        "PlanB" = "Pool party",
        "PlanC" = "Star Wars Marathon"
    }
}
variable "plans_object" {
    type = object({
      PlanA = string
      PlanB = string
      PlanC = string 
    }) 
    default =  {
        "PlanA" = "Beach party",
        "PlanB" = "Pool party",
        "PlanC" = "Star Wars Marathon"
    }
}
variable "misc_object" {
    type = object({
      PlanName = string
      PlanNumber = number
    }) 
    default =  {
        "PlanName" = "Adelaide",
        "PlanNumber" = 100
    }
}
variable "random" {
    type = tuple([ string, number, bool ])
    default = [ "word", 0, false ]
}