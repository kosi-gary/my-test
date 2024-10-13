ARG EXPOSE_PORT=8080
ARG DOCKER_WORKDIR=/app
ARG USER_ID=1000



#
# Build stage
#
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG DOCKER_WORKDIR

# Set the base directory that will be used from now on
WORKDIR /source

# Copy csproj and restore as distinct layers
COPY WebApplicationDemo/*.csproj ./
RUN dotnet restore

# Copy everything else
COPY WebApplicationDemo/ ./

# Build and publish a release
RUN dotnet publish --no-restore -o $DOCKER_WORKDIR



#
# Final stage
#
FROM mcr.microsoft.com/dotnet/aspnet:8.0

ARG DOCKER_WORKDIR
ARG EXPOSE_PORT
ENV TZ=Asia/Hong_Kong
ARG USER_ID=app

USER $USER_ID
WORKDIR $DOCKER_WORKDIR

COPY --chown=$USER_ID --from=build \
    $DOCKER_WORKDIR/ .

EXPOSE $EXPOSE_PORT
CMD ["./WebApplicationDemo"]
