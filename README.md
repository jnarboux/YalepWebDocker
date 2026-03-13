
To build the Dockerfile for different architectures and tag it at the same time:

```docker build -t jnarboux/yalepweb --platform=linux/amd64,linux/arm64 . ```

Then, to push on Docker Hub:

```docker push jnarboux/yalepweb```

To run the image locally:
```docker run -p 8080:8080 jnarboux/yalepweb```

