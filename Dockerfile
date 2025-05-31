# # Fetch
# FROM golang:latest AS fetch-stage
# WORKDIR /usr/src/app
# COPY go.mod go.sum ./
# RUN go mod download && go mod verify

# # Build
# FROM golang:latest AS build-stage
# WORKDIR /usr/src/app
# COPY . .
# RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o /usr/local/bin/app cmd/main.go

# # Deploy
# FROM gcr.io/distroless/static-debian12 AS deploy-stage
# WORKDIR /
# COPY --chown=nonroot --from=build-stage /usr/local/bin/app .
# ENV PORT 8080
# EXPOSE ${PORT}
# USER nonroot:nonroot
# ENTRYPOINT [ "/app" ]


# Fetch
FROM golang:latest AS fetch-stage
WORKDIR /usr/src/app
COPY go.mod go.sum ./ 
RUN go mod download && go mod verify

# Build
FROM golang:latest AS build-stage
WORKDIR /usr/src/app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o /usr/local/bin/app cmd/main.go

# Deploy (FIXED)
FROM gcr.io/distroless/static-debian12 AS deploy-stage
WORKDIR /usr/src/app
COPY --chown=nonroot --from=build-stage /usr/local/bin/app /usr/src/app/
# If you have configs, templates, or other required runtime files, copy them too.
# COPY --chown=nonroot --from=build-stage /usr/src/app/path/to/files /usr/src/app/path/to/files
ENV PORT 8080
EXPOSE ${PORT}
USER nonroot:nonroot
ENTRYPOINT [ "/usr/src/app/app" ]
