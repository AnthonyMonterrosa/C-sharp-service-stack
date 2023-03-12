FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /Build

# Copy everything
COPY ./Source .

# Restore as distinct layers
RUN dotnet restore

# Build and publish a release
RUN dotnet publish --configuration Debug --output Release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as runtime

LABEL org.opencontainers.image.source https://github.com/AnthonyMonterrosa/c-sharp-service-stack

WORKDIR /Build

COPY --from=build /Build/Release .

EXPOSE 5101 5102

ENV ASPNETCORE_ENVIRONMENT "Development"
ENTRYPOINT ["dotnet", "Website.API.dll"]