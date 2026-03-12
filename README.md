
To build the Dockerfile for different architectures:

```docker build -t jnarboux/yalepweb --platform=linux/amd64,linux/arm64 . ```

Then to push on Docker Hub:

```docker push jnarboux/yalepweb```


