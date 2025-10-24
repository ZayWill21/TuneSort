# EKS Cluster Security Group
resource "aws_security_group" "control_plane" {
  name        = "${var.stack_name}-eks-control-plane-sg"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-eks-control-plane-sg"
    }
  )
}

resource "aws_security_group_rule" "control_plane_self" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.control_plane.id
}

# EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.stack_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "${var.stack_name}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_cluster_version

  vpc_config {
    security_group_ids = [aws_security_group.control_plane.id]
    subnet_ids = [
      aws_subnet.public1.id,
      aws_subnet.public2.id,
      aws_subnet.public3.id,
      aws_subnet.private1.id,
      aws_subnet.private2.id,
      aws_subnet.private3.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]
}

# Node Group IAM Role
resource "aws_iam_role" "node_instance_role" {
  name = "${var.stack_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node_instance_role.name
}

# Launch Template
resource "aws_launch_template" "node_group" {
  name = "${var.stack_name}-LaunchTemplate"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 80
      volume_type = "gp3"
      iops        = 3000
      throughput  = 125
    }
  }

  metadata_options {
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
  }

  user_data = base64encode(<<-EOF
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

    --==MYBOUNDARY==
    Content-Type: text/x-shellscript; charset="us-ascii"

    #!/bin/bash
    # Wait for EKS bootstrap to complete (AL2023 may take longer)
    sleep 600
    # Create troubleshooting scenario - disable kubelet
    systemctl disable kubelet
    systemctl stop kubelet
    chmod 000 /usr/bin/kubelet

    --==MYBOUNDARY==--
  EOF
  )

  vpc_security_group_ids = [aws_security_group.control_plane.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name                            = "ekshandson-ng-${var.stack_name}-Node"
      "alpha.eksctl.io/nodegroup-name" = "ng-${var.stack_name}"
      "alpha.eksctl.io/nodegroup-type" = "managed"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name                            = "ekshandson-ng-${var.stack_name}-Node"
      "alpha.eksctl.io/nodegroup-name" = "ng-${var.stack_name}"
      "alpha.eksctl.io/nodegroup-type" = "managed"
    }
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = {
      Name                            = "ekshandson-ng-${var.stack_name}-Node"
      "alpha.eksctl.io/nodegroup-name" = "ng-${var.stack_name}"
      "alpha.eksctl.io/nodegroup-type" = "managed"
    }
  }
}

# EKS Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "ng-${var.stack_name}"
  node_role_arn   = aws_iam_role.node_instance_role.arn
  ami_type        = "AL2023_x86_64_STANDARD"
  instance_types  = [var.node_group_instance_types]

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id,
    aws_subnet.private3.id
  ]

  launch_template {
    id      = aws_launch_template.node_group.id
    version = aws_launch_template.node_group.latest_version
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  labels = {
    "alpha.eksctl.io/cluster-name"   = aws_eks_cluster.main.name
    "alpha.eksctl.io/nodegroup-name" = "ng-${var.stack_name}"
  }

  tags = {
    "alpha.eksctl.io/nodegroup-name" = "ng-${var.stack_name}"
    "alpha.eksctl.io/nodegroup-type" = "managed"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only
  ]
}
