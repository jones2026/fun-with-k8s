
[![Drone (cloud)](https://img.shields.io/drone/build/jones2026/fun-with-k8s)](https://cloud.drone.io/jones2026/fun-with-k8s)
[![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/jones2026/fun-with-k8s)](https://hub.docker.com/r/jones2026/fun-with-k8s/tags?page=1&ordering=last_updated)
[![Docker Pulls](https://img.shields.io/docker/pulls/jones2026/fun-with-k8s)](https://hub.docker.com/r/jones2026/fun-with-k8s)
# fun-with-k8s
API running on K8s



## Building Locally

This project is built using Golang 1.15 (https://golang.org/doc/install)

To run the server locally you can just use:

```
go run main.go
```
and then navigate to `localhost:8080\automate`

To build the binary locally use the following build command:

```
GOOS=linux CGO_ENABLED=0 go build -o main
```

Lastly if you would like to build the docker image after building the binary you can then run:

```
docker build -t fun-with-k8s .
docker run -p 80:8080 fun-with-k8s
```


## Acceptance Tests
For acceptance tests this project uses newman(https://github.com/postmanlabs/newman)

To run these tests locally you can use the following docker command:

```
docker run --rm --network="host" -t -v $(pwd):/etc/newman postman/newman run fun-with-k8s.postman_collection.json
```

When running locally the acceptance tests assume the api is running at `localhost` and that the `/version` endpoint is using the default placeholder value


## Building K8s Stack
This application is built using Terraform(https://www.terraform.io/downloads.html) for being deployed to GCP (https://cloud.google.com/)

To build and deploy the application to a K8s cluster at Google make sure you have setup local credentials (https://cloud.google.com/docs/authentication/getting-started) and then you can simply run:

```
cd terraform
terraform init
terraform apply
```
If deploying to your own Google account you will need to change the backend bucket name:
```
terraform {
  backend "gcs" {
    bucket = "jones2026-tf-state" \\ REPLACE THIS VALUE
    prefix = "fun-with-k8s"
  }
}
```


## CI/CD Pipeline

This project uses Drone (https://www.drone.io/) for its pipeline. To run the pipeline locally you need to have `docker` installed and then you can install the drone cli(https://docs.drone.io/cli/install/)

After installing the drone cli you can run the following command to run the pipeline locally:

```
drone exec
```

You can see each of the build steps in the `.drone.yml` file in the root of the repo
