#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["API/Website.API/Website.API.csproj", "API/Website.API/"]
COPY ["Common/Model/Website.Common.Model/Website.Common.Model.csproj", "Common/Model/Website.Common.Model/"]
RUN dotnet restore "API/Website.API/Website.API.csproj"
COPY . .
WORKDIR "/src/API/Website.API"
RUN dotnet build "Website.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Website.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Website.API.dll"]