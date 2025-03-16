# Compilación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copiar archivos de proyecto y restaurar dependencias
COPY api/*.csproj ./api/
WORKDIR /app/api
RUN dotnet restore

# Copiar todo el código fuente y compilar la aplicación
COPY api/. ./
RUN dotnet publish -c Release -o /out

# Imagen final con runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out ./
EXPOSE 8080
ENTRYPOINT ["dotnet", "MyAPI.dll"]

