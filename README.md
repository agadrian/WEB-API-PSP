
# Crear proyecto

dotnet new webapi -n MyAPI --framework net8.0 --use-controllers


# Pasos seguidos

dotnet new webapi --use-controllers -o MyAPI

cd TodoApi

dotnet add package Microsoft.EntityFrameworkCore.InMemory

code -r ../MyAPI


----

dotnet dev-certs https --trust  y dotnet run --launch-profile https


#### Crear model/Jugador
```
namespace MyAPI.models;

public class Jugador
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int MaxScore { get; set; }
    }
```

#### Contexto base de datos en model/JugadorContext

```
using Microsoft.EntityFrameworkCore;

namespace MyAPI.models  
{
    public class JugadorContext : DbContext
    {
        public JugadorContext(DbContextOptions<JugadorContext> options) : base(options) { }

        public DbSet<Jugador> Jugadores { get; set; }
    }
}
```

#### Registro contexto base de datos Program.cs

``` 
using  Microsoft.EntityFrameworkCore;
using MyAPI.models;

var builder = WebApplication.CreateBuilder(args);

// Bd en memoria
builder.Services.AddDbContext<JugadorContext>(options =>
    options.UseInMemoryDatabase("JugadoresDB"));

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();



var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseSwagger();
app.UseSwaggerUI();


//app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

```

### Por consola

dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet tool uninstall -g dotnet-aspnet-codegenerator
dotnet tool install -g dotnet-aspnet-codegenerator
dotnet tool update -g dotnet-aspnet-codegenerator


### Compilar
dotnet aspnet-codegenerator controller -name JugadoresController -async -api -m Jugador -dc JugadorContext -outDir Controllers


## Crear Dockerfile

**Compilación**
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

**Copiar archivos de proyecto y restaurar dependencias**
COPY api/*.csproj ./api/
WORKDIR /app/api
RUN dotnet restore

**Copiar todo el código fuente y compilar la aplicación**
COPY api/. ./
RUN dotnet publish -c Release -o /out

**Imagen final con runtime**
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out ./
EXPOSE 8080
ENTRYPOINT ["dotnet", "MyAPI.dll"]


### Construir la imagen

docker build -t myapi .

docker run -p 5000:8080 myapi


### Capturas pruebas

[**Prueba**](res/1.png)

[**Prueba**](res/2.png)

[**Prueba**](res/3.png)