#!/bin/bash

declare CLUSTER_NAME=$1
index=0
taskArn=$(aws ecs list-tasks --cluster ${CLUSTER_NAME} --query "taskArns[${index}]" --output text)

until [ "$taskArn" = "None" ]
do 
  aws ecs stop-task --cluster ${CLUSTER_NAME} --task $taskArn
  ((index++))
  taskArn=$(aws ecs list-tasks --cluster ${CLUSTER_NAME} --query "taskArns[${index}]" --output text)
done