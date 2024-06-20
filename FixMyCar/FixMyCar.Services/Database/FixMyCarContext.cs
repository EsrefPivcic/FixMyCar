using FixMyCar.Model.Entities;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Database
{
    public partial class FixMyCarContext : DbContext
    {
        public FixMyCarContext() 
        { 
        }

        public FixMyCarContext(DbContextOptions<FixMyCarContext> options) : base(options) 
        { 
        }

        public virtual DbSet<StoreItem> StoreItems { get; set; }
        public virtual DbSet<Discount> Discounts { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<AuthToken> AuthTokens { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            var ebcTurboPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "EBC-Turbo.png");
            var monsterMotorsportPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "Monster-motorsport.png");
            var oem_r32 = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "OEM-R32.png");

            modelBuilder.Entity<StoreItem>().HasData(
                new StoreItem
                {
                    Id = 1,
                    Name = "EBC-Turbo",
                    ImageData = ImageHelper.GetImageData(ebcTurboPath),
                    ImageMimeType = "image/png",
                    State = "draft"
                },
                new StoreItem
                {
                    Id = 2,
                    Name = "Monster-Motorsport",
                    ImageData = ImageHelper.GetImageData(monsterMotorsportPath),
                    ImageMimeType = "image/png",
                    State = "draft"
                },
                new StoreItem
                {
                    Id = 3,
                    Name = "OEM-R32 Brembo",
                    ImageData = ImageHelper.GetImageData(oem_r32),
                    ImageMimeType = "image/png",
                    State = "draft"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 1,
                    Name = "Admin"
                }
            );

            var salt = Hashing.GenerateSalt();

            modelBuilder.Entity<User>().HasData(
                new User
                {
                    Id = 1,
                    Name = "Esref",
                    Surname = "Pivcic",
                    Username = "eshi",
                    PasswordSalt = salt,
                    PasswordHash = Hashing.GenerateHash(salt, "eshi"),
                    RoleId = 1
                }
            );
        }
    }
}
