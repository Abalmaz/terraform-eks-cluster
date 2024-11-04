[
  {
    "name": "${name}",
    "image": "${docker_image_url}",
    "essential": true,
    "links": [],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "environment": []
  }
]