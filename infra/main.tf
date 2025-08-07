provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "trusted_bucket" {
  bucket = var.trusted_data_bucket_name
}

resource "aws_glue_job" "glue_job" {
  name     = "my-first-gluejob-s3-to-s3"
  role_arn = var.glue_job_role_arn 

  command {
    name            = "glueetl"
    script_location = var.script_location_bucket_name
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}
