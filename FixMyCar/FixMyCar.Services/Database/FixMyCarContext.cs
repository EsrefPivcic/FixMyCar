using FixMyCar.Model.Entities;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
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
        public virtual DbSet<ChatMessage> ChatMessages { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

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

            modelBuilder.Entity<User>()
             .HasDiscriminator<int>("RoleId")
             .HasValue<User>(0)
             .HasValue<Admin>(1)
             .HasValue<Client>(2)
             .HasValue<CarRepairShop>(3)
             .HasValue<CarPartsShop>(4);
        }
    }
}
