# Dockerfile.alpine
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

# Copiar .csprojs 
COPY *.csproj .

# Limpiar y restaurar (desde cero)
# RUN rm -rf bin obj && \
#    dotnet restore --force
RUN dotnet restore

# Copiar todo
COPY . .

# Publicar
RUN dotnet publish -c Release -o /app/publish

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000 \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

RUN apk add --no-cache icu-libs=76.1-r1

COPY --from=build /app/publish .

RUN adduser -u 1000 -D -H dotnetuser && chown -R dotnetuser /app
USER dotnetuser

ENTRYPOINT ["dotnet", "backend.dll"]
