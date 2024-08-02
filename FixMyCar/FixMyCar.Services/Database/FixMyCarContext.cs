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
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<AuthToken> AuthTokens { get; set; }
        public virtual DbSet<Order> Orders { get; set; }
        public virtual DbSet<OrderDetail> OrderDetails { get; set; }
        public virtual DbSet<City> Cities { get; set; }
        public virtual DbSet<CarModel> CarModels { get; set; }
        public virtual DbSet<StoreItemCarModel> StoreItemCarModels { get; set; }
        public virtual DbSet<CarManufacturer> CarManufacturers { get; set; }
        public virtual DbSet<StoreItemCategory> StoreItemCategory { get; set; }
        public virtual DbSet<CarPartsShopClientDiscount> CarPartsShopClientDiscounts { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 1,
                    Name = "Admin"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 2,
                    Name = "Client"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 3,
                    Name = "Car Repair Shop"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 4,
                    Name = "Car Parts Shop"
                }
            );

            modelBuilder.Entity<User>()
             .HasDiscriminator<int>("RoleId")
             .HasValue<User>(0)
             .HasValue<Admin>(1)
             .HasValue<Client>(2)
             .HasValue<CarRepairShop>(3)
             .HasValue<CarPartsShop>(4);

            var salt = Hashing.GenerateSalt();
            var salt2 = Hashing.GenerateSalt();

            modelBuilder.Entity<Admin>().HasData(
                new Admin
                {
                    Id = 1,
                    Name = "Esref",
                    Surname = "Pivcic",
                    Username = "admin",
                    PasswordSalt = salt,
                    PasswordHash = Hashing.GenerateHash(salt, "admin"),
                    RoleId = 1
                }       
            );
            
            modelBuilder.Entity<CarRepairShop>().HasData(
                new CarRepairShop
                {
                    Id = 2,
                    Name = "Esref",
                    Surname = "Pivcic",
                    Username = "carpartsshop",
                    PasswordSalt = salt2,
                    PasswordHash = Hashing.GenerateHash(salt2, "carpartsshop"),
                    RoleId = 4
                }
            );

            modelBuilder.Entity<OrderDetail>()
                .HasOne(od => od.Order)
                .WithMany(o => o.OrderDetails)
                .HasForeignKey(od => od.OrderId)
                .OnDelete(DeleteBehavior.Cascade);


            modelBuilder.Entity<OrderDetail>()
                .HasOne(od => od.StoreItem)
                .WithMany(si => si.OrderDetails)
                .HasForeignKey(od => od.StoreItemId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<StoreItem>()
                .HasMany(s => s.CarModels)
                .WithMany(c => c.StoreItems)
                .UsingEntity<StoreItemCarModel>(
                    j => j
                        .HasOne(pt => pt.CarModel)
                        .WithMany(t => t.StoreItemCarModels)
                        .HasForeignKey(pt => pt.CarModelId),
                    j => j
                        .HasOne(pt => pt.StoreItem)
                        .WithMany(p => p.StoreItemCarModels)
                        .HasForeignKey(pt => pt.StoreItemId),
                    j =>
                    {
                        j.HasKey(t => new { t.StoreItemId, t.CarModelId });
                    });

            modelBuilder.Entity<StoreItemCategory>().HasData(
                new StoreItemCategory
                {
                    Id = 1,
                    Name = "Brakes",
                }
            );

            modelBuilder.Entity<CarManufacturer>().HasData(
                new CarManufacturer
                {
                    Id = 1,
                    Name = "Volkswagen"
                }
            );

            modelBuilder.Entity<CarModel>().HasData(
                new CarModel
                {
                    Id = 1,
                    CarManufacturerId = 1,
                    Name = "Golf Mk4",
                    ModelYear = "1997-2003"
                },
                new CarModel
                {
                    Id = 2,
                    CarManufacturerId = 1,
                    Name = "Bora",
                    ModelYear = "1999-2006"
                },
                new CarModel
                {
                    Id = 3,
                    CarManufacturerId = 1,
                    Name = "Passat B5",
                    ModelYear = "1997-2000"
                },
                new CarModel
                {
                    Id = 4,
                    CarManufacturerId = 1,
                    Name = "Passat B5.5",
                    ModelYear = "2000-2005"
                }
            );
        }
    }
}
