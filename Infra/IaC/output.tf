output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.control_plane.id
}

output "eks_node_group_id" {
  description = "EKS Node Group ID"
  value       = aws_eks_node_group.main.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
}
