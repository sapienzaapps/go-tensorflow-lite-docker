GO_VERSION=1.17
TF_VERSION=2.5.0

BUILDAH_ARGS=--layers=true --build-arg GO_VERSION=${GO_VERSION} --build-arg TF_VERSION=${TF_VERSION} -f Dockerfile
TAG=go${GO_VERSION}-tf${TF_VERSION}

docker:
	buildah manifest create go-tensorflow-lite:${TAG}

	buildah bud ${BUILDAH_ARGS} --arch amd64 -t go-tensorflow-lite-amd64:${TAG} .
	buildah manifest add go-tensorflow-lite:${TAG} go-tensorflow-lite-amd64:${TAG}

	buildah bud ${BUILDAH_ARGS} --arch arm --variant v7 -t go-tensorflow-lite-armv7:${TAG} .
	buildah manifest add go-tensorflow-lite:${TAG} go-tensorflow-lite-armv7:${TAG}

	buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8 -t go-tensorflow-lite-arm64:${TAG} .
	buildah manifest add go-tensorflow-lite:${TAG} go-tensorflow-lite-arm64:${TAG}


push:
	buildah manifest push --all --format=docker go-tensorflow-lite:${TAG} docker://docker.io/enrico204/go-tensorflow-lite:${TAG}

clean:
	-buildah rmi go-tensorflow-lite:${TAG}

inspect:
	buildah manifest inspect go-tensorflow-lite:${TAG}