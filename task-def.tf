data "aws_ecs_task_definition" "test" {
task_definition = aws_ecs_task_definition.test.family
depends_on = [aws_ecs_task_definition.test]
}


resource "aws_ecs_task_definition" "test" {
  family = "test-family"

  container_definitions = <<EOF
[
  {
    "name": "nginx",
    "image": "${var.image}",
    "cpu": 128,
    "memory": 128
  }
]
EOF
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello_world"
  cluster         = "myecscluster"
  task_definition = aws_ecs_task_definition.test.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
