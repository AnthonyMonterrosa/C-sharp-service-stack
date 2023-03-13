FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

COPY . .

# Restore as distinct layers
RUN dotnet restore

# Create SSL certificate.
RUN dotnet dev-certs https -ep /.aspnet/https/aspnetapp.pfx -p "local-password"

# Build and publish a release
RUN dotnet publish --configuration Debug --output /Release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as runtime

LABEL org.opencontainers.image.source https://github.com/AnthonyMonterrosa/c-sharp-service-stack

# Copy dotnet build artifacts.
COPY --from=build /Release .

EXPOSE 443

# Copy local SSL certificate.
COPY --from=build /.aspnet/https /
# Create environment variables for SSL certificate use.
ENV ASPNETCORE_Kestrel__Certificates__Default__Password "local-password"
ENV ASPNETCORE_Kestrel__Certificates__Default__Path "/aspnetapp.pfx"

ENV ASPNETCORE_ENVIRONMENT "Development"
ENTRYPOINT ["dotnet", "Website.API.dll"]