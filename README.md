
To build the Dockerfile for different architectures:

```docker build --platform=linux/amd64,linux/arm64 . ```

To find the number of the image:

```docker images -a```

To create the tag:

```docker tag sha256:.... login/imagename```

Then to push on Docker Hub:

```docker push login/imagename```


