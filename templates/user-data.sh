#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=myecscluster"
} >> /etc/ecs/ecs.config

start ecs

echo "Done"
