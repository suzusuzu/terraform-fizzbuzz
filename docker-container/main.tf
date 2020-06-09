terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
  required_version = ">= 0.13"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "hello" {
  count = 15
  image = docker_image.hello.latest
  name  = "name-${count.index}"
  labels {
    label = "label-${count.index}"
    value = (count.index + 1) % 15 == 0 ? "FizzBuzz" : (count.index + 1) % 5 == 0 ? "Buzz" : (count.index + 1) % 3 == 0 ? "Fizz" : (count.index + 1)
  }
}

resource "docker_image" "hello" {
  name = "hello-world:latest"
}

output "out" {
  value = [for o in docker_container.hello : o.labels.*.value]
}
