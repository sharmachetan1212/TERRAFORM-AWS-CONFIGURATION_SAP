# output "ebs_vol_id" {
#   description = "ebs volume related to Ec2"
#   value = aws_ebs_volume.ebs_vol_as.id
# }

# Error if no match is found in the loop
# output "instacne_type_error_check" {
#   description = "Check if the instance type is valid"
#   value       = length(local.instance_type_as) > 0 ? "Instance type is valid." : "Error: Instance type is not valid."
# }

# output "count" {
#   description = "Check if the count is valid"
#   value = length(aws_instance.app_server_as) > 0 ? "Count is valid." : "Error: Count is not valid."
# }

# Output Public IP of the Instance
# output "sap_web_dispatcher_public_ips" {
#   value = aws_instance.app_server_as[*].public_ip
# }