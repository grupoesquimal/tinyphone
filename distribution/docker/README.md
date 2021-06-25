## Build Docker Image

```
docker build  -f Dockerfile.base -t dotnet3.5-vs17:latest  .
docker build  -f Dockerfile.build -t tinyphone  .
```

## Run Docker

```
./release.sh
```
