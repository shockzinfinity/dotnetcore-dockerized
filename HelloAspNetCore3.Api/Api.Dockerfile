FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["HelloAspNetCore3.Api.csproj", "./"]
RUN dotnet restore "./HelloAspNetCore3.Api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloAspNetCore3.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloAspNetCore3.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "HelloAspNetCore3.Api.dll"]