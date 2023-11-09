# First stage: build the Go binary.
FROM golang:1.20 as builder

WORKDIR /go/src/app

# Copy the source code.
COPY . .

# Download dependencies.
RUN go mod tidy -v

# Build the Go program, output to the 'bin' directory.
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -buildvcs=false -o bin/event_exporter .

# Second stage: create a small runtime environment.
FROM debian:stretch-slim

# Copy the built binary from the builder stage.
COPY --from=builder /go/src/app/bin/event_exporter /event_exporter

# Set the user to run your app.
USER nobody

# Set the entrypoint.
ENTRYPOINT ["/event_exporter"]

# Expose the application port.
EXPOSE 9102
