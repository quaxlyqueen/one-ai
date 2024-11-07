# syntax=docker/dockerfile:1

FROM golang:1.22.5

# Set destination for COPY
WORKDIR /tmp/docker/security-layer

# Download Go modules
COPY ./container/go.mod ./container/go.sum ./
RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/reference/dockerfile/#copy
COPY ./container/*.go ./

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /security-layer

# Optional:
# To bind to a TCP port, runtime parameters must be supplied to the docker command.
# But we can document in the Dockerfile what ports
# the application is going to listen on by default.
# https://docs.docker.com/reference/dockerfile/#expose

# TODO: Need to dynamically expose ports based upon ~/.config/one-ai/test.json
EXPOSE 1111
EXPOSE 1112
EXPOSE 1113
EXPOSE 1114

# Run
CMD ["/security-layer"]
