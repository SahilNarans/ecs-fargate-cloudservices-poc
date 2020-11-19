Github Actions + ECS Fargate JSON API POC
==========


## Build & Local Run Dependencies
* JDK 8
* sbt `brew install sbt` for macOS, `choco install sbt` for win

## Prod Run Dependencies
* JDK 8

## Testing
This will run automated tests
```shell
sbt test
```

## Running Locally
This will run on localhost:9000
```shell
sbt run
```

## Live Check
This will test for liveness.
```
curl localhost:9000/live
```

## Packaging Up As Zip
Play Framework uses sbt-native-packager underneath the hood. `dist` can be used for packaging up which is equivalent to `universal:packageBin`.
```shell
sbt dist
```

## Packaging Up For Docker
Play Framework uses sbt-native-packager underneath the hood. We can use this directly.
```shell
sbt stage
```

## Running in Prod
Note the secret key can be anything within the spec. It should be kept in SSM. The below is only for EXAMPLE and not for real production. Can also use ENV variables, etc..
Reference: https://www.playframework.com/documentation/2.8.x/ApplicationSecret

```shell
# need to set it as executable if we zipped it beforehand
chmod +x bin/ecs-fargate-cloudservices-poc

# run executable script
target/universal/stage/bin/ecs-fargate-cloudservices-poc -Dplay.http.secret.key='QCY?tAnfk?aZ?iwrNwnxIlR6CTf:G3gf:90Latabg@5241AB`R5W:1uDFN];Ik@n'
```

For Docker purposes, can add `$WORKSPACE/target/universal/stage/`.
