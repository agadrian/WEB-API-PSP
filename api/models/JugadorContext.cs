using Microsoft.EntityFrameworkCore;

namespace MyAPI.models  
{
    public class JugadorContext : DbContext
    {
        public JugadorContext(DbContextOptions<JugadorContext> options) : base(options) { }

        public DbSet<Jugador> Jugadores { get; set; }
    }
}