# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS - You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "alb_name" {
  description = "The name of the ALB and all its resources"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}
