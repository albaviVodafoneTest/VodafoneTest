# ------------------------------------------
# Write your Terraform variable inputs here
# ------------------------------------------

variable "pathJson" {
  description = "Path to the JSON files containing A type reg"
  type        = string
  default     = "/examples/exercise/input-json/"
}