
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# https://www.terraform.io/docs/language/values/variables.html
# https://oracle-base.com/articles/misc/terraform-variables

# https://faun.pub/using-terraform-to-deploy-your-s3-website-using-cloudfront-cf2c1dfc6334
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
  profile = "indira"
}

# Create a S3 bucket
resource "aws_s3_bucket" "samples3bucket" {
  bucket = "shiuhlin-public-bucket-rzh1113"
  
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.samples3bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "public_website" {  
  bucket = aws_s3_bucket.samples3bucket.id   

  policy = jsonencode({
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.samples3bucket.id}/*"            
          ]        
      }    
    ]
  })
}

output "s3_bucket_domain_name" {
    # value = "https://${aws_s3_bucket.samples3bucket.bucket_domain_name}"
    value = "http://${aws_s3_bucket.samples3bucket.website_endpoint}"
}