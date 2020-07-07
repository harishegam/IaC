resource "aws_launch_configuration" "ecs-launch-configuration" {
name = "ecs-launch-configuration"
image_id = "ami-64300001"
instance_type = "t2.medium"
iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

root_block_device {
volume_type = "standard"
volume_size = 100
delete_on_termination = true
}

lifecycle {
create_before_destroy = true
}

associate_public_ip_address = "false"
key_name = "IAC"

#
# register the cluster name with ecs-agent which will in turn coord
# with the AWS api about the cluster
#
user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("templates/user-data.sh")

}
#
# need an ASG so we can easily add more ecs host nodes as necessary
#
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
name = "ecs-autoscaling-group"
max_size = "2"
min_size = "1"
desired_capacity = "1"

vpc_zone_identifier = ["subnet-827408f8"]
#vpc_zone_identifier = ["${module.new-vpc.private_subnets}"]
launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
health_check_type = "ELB"

tag {
key = "Name"
value = "ECS-myecscluster"
propagate_at_launch = true
}
}

resource "aws_ecs_cluster" "test-ecs-cluster" {
name = "myecscluster"
}
