output "public_instance_info" {
  description = "Info instàncies públiques"
  value = {
    for i in aws_instance.public_instances :
    i.id => {
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }
  }
}

output "private_instance_info" {
  description = "Info instàncies privades"
  value = {
    for i in aws_instance.private_instances :
    i.id => {
      private_ip = i.private_ip
    }
  }
}

output "s3_bucket_name" {
  description = "Nom del bucket creat (si s'ha creat)"
  value       = try(aws_s3_bucket.bucket[0].bucket, null)
}
