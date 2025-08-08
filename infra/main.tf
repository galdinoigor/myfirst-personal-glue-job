provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "trusted_bucket" {
  bucket = var.trusted_data_bucket_name
}

resource "aws_s3_bucket" "script_bucket" {
  bucket = var.script_location_bucket_name
}

resource "aws_glue_job" "glue_job" {
  name     = "my-first-gluejob-s3-to-s3"
  role_arn = var.glue_job_role_arn 

  command {
    name            = "glueetl"
    script_location = "s3://${var.script_location_bucket_name}/trusted_s3_to_s3.py"
    python_version  = "3"
  }

  default_arguments = {
    "--RAW_BUCKET_PATH"                = "s3://${var.raw_data_bucket_name}/${var.raw_file_name}"
    "--TRUSTED_BUCKET_PATH"            = "s3://${var.trusted_data_bucket_name}"
    "--TRUSTED_SUBFOLDER"              = var.trusted_folder_name
    "--enable-continuous-logging"      = "true"
    "--enable-metrics"                 = "true"
    "--enable-glue-datacatalog"        = "true"
    "--continuous-log-logGroup"        = "/aws-glue/jobs/output"
    "--continuous-log-logStreamPrefix" = "glue-job-logs
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}
