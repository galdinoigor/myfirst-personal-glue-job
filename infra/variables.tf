variable "raw_data_bucket_name" {
    description = "Bucket for RAW data file"
    type = string
}

variable "raw_file_name" {
    description = "RAW CSV File name"
    type = string
}

variable "trusted_data_bucket_name" {
    description = "Bucket for TRUSTED data file (target)"
    type = string
}

variable "trusted_folder_name" {
    description = "Subfolder from trusted bucket"
    type = string
}

variable "script_location_bucket_name" {
    description = "Bucket for Glue Job Python Script"
    type = string
}

variable "glue_job_role_arn" {
    description = "IAM Role ARN for Glue Job"
    type = string
}

variable "region" {
    description = "AWS Region"
    type = string
}