variable state_bucket_name {
  type    = string
  # A random bucket name by default
  default = "it-agile-terraform-state-kyeongmin"
}

variable state_lock_table_name {
  type    = string
  default = "tf-serverless-jenkins-lock"
}