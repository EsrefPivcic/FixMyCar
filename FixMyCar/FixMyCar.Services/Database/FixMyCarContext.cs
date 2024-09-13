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
        public virtual DbSet<CarRepairShopDiscount> CarRepairShopDiscounts { get; set; }
        public virtual DbSet<CarRepairShopService> CarRepairShopServices { get; set; }
        public virtual DbSet<ServiceType> ServiceTypes { get; set; }
        public virtual DbSet<Reservation> Reservations { get; set; }
        public virtual DbSet<ReservationDetail> ReservationDetails { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<City>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired();
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.HasOne(u => u.City)
                      .WithMany()
                      .HasForeignKey(u => u.CityId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

            modelBuilder.Entity<Order>()
                .HasOne(o => o.CarPartsShop)
                .WithMany()
                .HasForeignKey(o => o.CarPartsShopId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<CarRepairShopDiscount>()
                .HasOne(o => o.Client)
                .WithMany()
                .HasForeignKey(o => o.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Reservation>()
                .HasOne(o => o.Client)
                .WithMany()
                .HasForeignKey(o => o.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<ReservationDetail>()
                .HasOne(rd => rd.Reservation)
                .WithMany(r => r.ReservationDetails)
                .HasForeignKey(rd => rd.ReservationId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Order>()
                .HasOne(o => o.CarRepairShop)
                .WithMany()
                .HasForeignKey(o => o.CarRepairShopId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Order>()
                .HasOne(o => o.Client)
                .WithMany()
                .HasForeignKey(o => o.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Order>()
                .HasOne(o => o.ClientDiscount)
                .WithMany()
                .HasForeignKey(o => o.ClientDiscountId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Order>()
                .HasOne(o => o.City)
                .WithMany()
                .HasForeignKey(o => o.CityId)
                .OnDelete(DeleteBehavior.Restrict);

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

            var repairs = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "repairs.png");
            var diagnostics = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "diagnostics.png");
            byte[] repairsImage = ImageHelper.GetImageData(repairs);
            byte[] diagnosticsImage = ImageHelper.GetImageData(diagnostics);

            modelBuilder.Entity<ServiceType>().HasData(
                new ServiceType
                {
                    Id = 1,
                    Name = "Repairs",
                    Image = ImageHelper.Resize(repairsImage, 150)
                }
            );

            modelBuilder.Entity<ServiceType>().HasData(
                new ServiceType
                {
                    Id = 2,
                    Name = "Diagnostics",
                    Image = ImageHelper.Resize(diagnosticsImage, 150)
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 1,
                    Name = "Livno"
                }
            );

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
                    Created = DateTime.Now.Date,
                    Email = "esrefpivcic@gmail.com",
                    Phone = "063111222",
                    Gender = "Male",
                    Address = "Goricka 71",
                    PostalCode = "80101",
                    CityId = 1,
                    PasswordSalt = salt,
                    PasswordHash = Hashing.GenerateHash(salt, "admin"),
                    RoleId = 1
                }       
            );
            
            modelBuilder.Entity<CarPartsShop>().HasData(
                new CarPartsShop
                {
                    Id = 2,
                    Name = "Esref",
                    Surname = "Pivcic",
                    Username = "carpartsshop",
                    Created = DateTime.Now.Date,
                    Email = "esrefpivcic@gmail.com",
                    Phone = "063111222",
                    Gender = "Male",
                    Address = "Goricka 71",
                    PostalCode = "80101",
                    CityId = 1,
                    PasswordSalt = salt2,
                    PasswordHash = Hashing.GenerateHash(salt2, "carpartsshop"),
                    RoleId = 4
                }
            );

            modelBuilder.Entity<CarRepairShop>().HasData(
                new CarRepairShop
                {
                    Id = 3,
                    Name = "Esref",
                    Surname = "Pivcic",
                    Username = "carrepairshop",
                    Created = DateTime.Now.Date,
                    Email = "esrefpivcic@gmail.com",
                    Phone = "063111222",
                    Gender = "Male",
                    Address = "Goricka 71",
                    PostalCode = "80101",
                    CityId = 1,
                    PasswordSalt = salt2,
                    PasswordHash = Hashing.GenerateHash(salt2, "carrepairshop"),
                    RoleId = 3,
                    WorkDaysAsString = string.Join(",", new[] { (int)DayOfWeek.Monday, (int)DayOfWeek.Tuesday, (int)DayOfWeek.Wednesday, (int)DayOfWeek.Thursday, (int)DayOfWeek.Friday }),
                    OpeningTime = new TimeSpan(8, 0, 0),
                    ClosingTime = new TimeSpan(16, 0, 0),
                    WorkingHours = new TimeSpan(8, 0, 0)
                }
            );

            modelBuilder.Entity<Client>().HasData(
                new Client
                {
                    Id = 4,
                    Name = "Esref",
                    Surname = "Pivcic",
                    Username = "client",
                    Created = DateTime.Now.Date,
                    Email = "esrefpivcic@gmail.com",
                    Phone = "063111222",
                    Gender = "Male",
                    Address = "Goricka 71",
                    PostalCode = "80101",
                    CityId = 1,
                    PasswordSalt = salt2,
                    PasswordHash = Hashing.GenerateHash(salt2, "client"),
                    RoleId = 2
                }
            );

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
