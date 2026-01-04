# Etapa de construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos del proyecto
COPY ["backend.csproj", "."]
RUN dotnet restore "backend.csproj"

COPY . .
RUN dotnet build "backend.csproj" -c Release -o /app/build

# Publicar la aplicación
RUN dotnet publish "backend.csproj" -c Release -o /app/publish

# Etapa de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 5000

# Copiar desde la etapa de build
COPY --from=build /app/publish .

# Variables de entorno por defecto
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production

# Usuario no root por seguridad
USER 1000

ENTRYPOINT ["dotnet", "backend.dll"]