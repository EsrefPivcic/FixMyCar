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

            var repairs = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "repairs.png");
            var diagnostics = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "diagnostics.png");
            byte[] repairsImage = ImageHelper.GetImageData(repairs);
            byte[] diagnosticsImage = ImageHelper.GetImageData(diagnostics);

            modelBuilder.Entity<ServiceType>().HasData(
                new ServiceType
                {
                    Id = 1,
                    Name = "Repairs",
                    Image = ImageHelper.Resize(repairsImage, 100)
                }
            );

            modelBuilder.Entity<ServiceType>().HasData(
                new ServiceType
                {
                    Id = 2,
                    Name = "Diagnostics",
                    Image = ImageHelper.Resize(diagnosticsImage, 100)
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 1,
                    Name = "Mostar"
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 2,
                    Name = "Sarajevo"
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 3,
                    Name = "Banja Luka"
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 4,
                    Name = "Zenica"
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 5,
                    Name = "Livno"
                }
            );

            modelBuilder.Entity<City>().HasData(
                new City
                {
                    Id = 6,
                    Name = "Trebinje"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 1,
                    Name = "admin"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 2,
                    Name = "client"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 3,
                    Name = "carrepairshop"
                }
            );

            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 4,
                    Name = "carpartsshop"
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
            var salt3 = Hashing.GenerateSalt();
            var salt4 = Hashing.GenerateSalt();

            modelBuilder.Entity<Admin>().HasData(
                new Admin
                {
                    Id = 1,
                    Name = "John",
                    Surname = "Doe",
                    Username = "admin",
                    Created = DateTime.Now.Date,
                    Email = "admin@fixmycar.com",
                    Phone = "+387 63 555 444",
                    Gender = "Male",
                    Address = "Bulevar 1",
                    PostalCode = "88000",
                    CityId = 1,
                    PasswordSalt = salt,
                    PasswordHash = Hashing.GenerateHash(salt, "test"),
                    RoleId = 1,
                    Active = true
                }       
            );
            
            modelBuilder.Entity<CarPartsShop>().HasData(
                new CarPartsShop
                {
                    Id = 2,
                    Name = "Jim",
                    Surname = "Johnson",
                    Username = "carpartsshop",
                    Created = DateTime.Now.Date,
                    Email = "carpartsshop@fixmycar.com",
                    Phone = "+387 63 666 444",
                    Gender = "Male",
                    Address = "Bulevar 2",
                    PostalCode = "88000",
                    CityId = 1,
                    PasswordSalt = salt2,
                    PasswordHash = Hashing.GenerateHash(salt2, "test"),
                    Image = Array.Empty<byte>(),
                    RoleId = 4,
                    WorkDaysAsString = string.Join(",", new[] { (int)DayOfWeek.Monday, (int)DayOfWeek.Tuesday, (int)DayOfWeek.Wednesday, (int)DayOfWeek.Thursday, (int)DayOfWeek.Friday }),
                    OpeningTime = new TimeSpan(8, 0, 0),
                    ClosingTime = new TimeSpan(16, 0, 0),
                    WorkingHours = new TimeSpan(8, 0, 0),
                    Active = true
                }
            );

            modelBuilder.Entity<CarRepairShop>().HasData(
                new CarRepairShop
                {
                    Id = 3,
                    Name = "Nicole",
                    Surname = "Perkins",
                    Username = "carrepairshop",
                    Created = DateTime.Now.Date,
                    Email = "carrepairshop@fixmycar.com",
                    Phone = "+387 63 777 444",
                    Gender = "Female",
                    Address = "Bulevar 3",
                    PostalCode = "88000",
                    CityId = 1,
                    PasswordSalt = salt3,
                    PasswordHash = Hashing.GenerateHash(salt2, "test"),
                    Image = Array.Empty<byte>(),
                    RoleId = 3,
                    WorkDaysAsString = string.Join(",", new[] { (int)DayOfWeek.Monday, (int)DayOfWeek.Tuesday, (int)DayOfWeek.Wednesday, (int)DayOfWeek.Thursday, (int)DayOfWeek.Friday }),
                    OpeningTime = new TimeSpan(8, 0, 0),
                    ClosingTime = new TimeSpan(16, 0, 0),
                    WorkingHours = new TimeSpan(8, 0, 0),
                    Employees = 2,
                    Active = true
                }
            );

            modelBuilder.Entity<Client>().HasData(
                new Client
                {
                    Id = 4,
                    Name = "Nancy",
                    Surname = "Cole",
                    Username = "client",
                    Created = DateTime.Now.Date,
                    Email = "nancycole@fixmycar.com",
                    Phone = "+387 63 888 444",
                    Gender = "Female",
                    Address = "Bulevar 4",
                    PostalCode = "88000",
                    CityId = 1,
                    PasswordSalt = salt4,
                    PasswordHash = Hashing.GenerateHash(salt2, "test"),
                    RoleId = 2,
                    Active = true
                }
            );

            modelBuilder.Entity<StoreItemCategory>().HasData(
                new StoreItemCategory
                {
                    Id = 1,
                    Name = "Brakes",
                },
                new StoreItemCategory
                {
                    Id = 2,
                    Name = "Engine Parts",
                },
                new StoreItemCategory
                {
                    Id = 3,
                    Name = "Suspension",
                },
                new StoreItemCategory
                {
                    Id = 4,
                    Name = "Exhaust Systems",
                },
                new StoreItemCategory
                {
                    Id = 5,
                    Name = "Transmission",
                },
                new StoreItemCategory
                {
                    Id = 6,
                    Name = "Electrical Systems",
                },
                new StoreItemCategory
                {
                    Id = 7,
                    Name = "Tires",
                },
                new StoreItemCategory
                {
                    Id = 8,
                    Name = "Wipers",
                },
                new StoreItemCategory
                {
                    Id = 9,
                    Name = "Filters",
                },
                new StoreItemCategory
                {
                    Id = 10,
                    Name = "Cooling Systems",
                }
            );

            modelBuilder.Entity<CarManufacturer>().HasData(
                new CarManufacturer
                {
                    Id = 1,
                    Name = "Volkswagen"
                },
                new CarManufacturer
                {
                    Id = 2,
                    Name = "Toyota"
                },
                new CarManufacturer
                {
                    Id = 3,
                    Name = "Ford"
                },
                new CarManufacturer
                {
                    Id = 4,
                    Name = "Honda"
                },
                new CarManufacturer
                {
                    Id = 5,
                    Name = "BMW"
                },
                new CarManufacturer
                {
                    Id = 6,
                    Name = "Mercedes-Benz"
                },
                new CarManufacturer
                {
                    Id = 7,
                    Name = "Opel"
                },
                new CarManufacturer
                {
                    Id = 8,
                    Name = "Nissan"
                },
                new CarManufacturer
                {
                    Id = 9,
                    Name = "Hyundai"
                },
                new CarManufacturer
                {
                    Id = 10,
                    Name = "Audi"
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
                    Name = "Passat B5/B5.5",
                    ModelYear = "1996-2005"
                },
                new CarModel
                {
                    Id = 3,
                    CarManufacturerId = 1,
                    Name = "Passat B2",
                    ModelYear = "1981-1988"
                },
                new CarModel
                {
                    Id = 4,
                    CarManufacturerId = 1,
                    Name = "Phaeton GP0/GP1",
                    ModelYear = "2002-2007"
                },
                new CarModel
                {
                    Id = 5,
                    CarManufacturerId = 1,
                    Name = "Tiguan (AD/BW)",
                    ModelYear = "2016-present"
                },
                new CarModel
                {
                    Id = 6,
                    CarManufacturerId = 1,
                    Name = "Polo Mk5",
                    ModelYear = "2009–2017"
                },
            
                new CarModel
                {
                    Id = 7,
                    CarManufacturerId = 2,
                    Name = "Corolla (E140)",
                    ModelYear = "2006-2013"
                },
                new CarModel
                {
                    Id = 8,
                    CarManufacturerId = 2,
                    Name = "Camry XV70",
                    ModelYear = "2017-2023"
                },
                new CarModel
                {
                    Id = 9,
                    CarManufacturerId = 2,
                    Name = "Land Cruiser J100",
                    ModelYear = "1998-2007"
                },
                new CarModel
                {
                    Id = 10,
                    CarManufacturerId = 2,
                    Name = "GR Yaris",
                    ModelYear = "2020-present"
                },
                new CarModel
                {
                    Id = 11,
                    CarManufacturerId = 2,
                    Name = "Supra A80",
                    ModelYear = "1993-2002"
                },
                new CarModel
                {
                    Id = 12,
                    CarManufacturerId = 2,
                    Name = "Prius XW30",
                    ModelYear = "2009-2015"
                },
            
                new CarModel
                {
                    Id = 13,
                    CarManufacturerId = 3,
                    Name = "Mustang (5th gen)",
                    ModelYear = "2004-2014"
                },
                new CarModel
                {
                    Id = 14,
                    CarManufacturerId = 3,
                    Name = "Fiesta (3rd gen)",
                    ModelYear = "1989-1997"
                },
                new CarModel
                {
                    Id = 15,
                    CarManufacturerId = 3,
                    Name = "Focus (2nd gen)",
                    ModelYear = "2011-2014"
                },
                new CarModel
                {
                    Id = 16,
                    CarManufacturerId = 3,
                    Name = "F-150 (11th gen)",
                    ModelYear = "2004–2008"
                },
                new CarModel
                {
                    Id = 17,
                    CarManufacturerId = 3,
                    Name = "Explorer (4th gen)",
                    ModelYear = "2006–2010"
                },
            
                new CarModel
                {
                    Id = 18,
                    CarManufacturerId = 4,
                    Name = "Civic (6th gen)",
                    ModelYear = "1996-2000"
                },
                new CarModel
                {
                    Id = 19,
                    CarManufacturerId = 4,
                    Name = "Accord (9th gen)",
                    ModelYear = "2012–2017"
                },
                new CarModel
                {
                    Id = 20,
                    CarManufacturerId = 4,
                    Name = "CR-V (3rd gen)",
                    ModelYear = "2006–2012"
                },
                new CarModel
                {
                    Id = 21,
                    CarManufacturerId = 4,
                    Name = "Fit (1st gen)",
                    ModelYear = "2001–2008"
                },
                new CarModel
                {
                    Id = 22,
                    CarManufacturerId = 4,
                    Name = "Honda NSX (NA1/2)",
                    ModelYear = "1991–2005"
                },

                new CarModel
                {
                    Id = 23,
                    CarManufacturerId = 5,
                    Name = "E30",
                    ModelYear = "1982–1994"
                },
                new CarModel
                {
                    Id = 24,
                    CarManufacturerId = 5,
                    Name = "E34",
                    ModelYear = "1988–1995"
                },
                new CarModel
                {
                    Id = 25,
                    CarManufacturerId = 5,
                    Name = "X5 (E70)",
                    ModelYear = "2007–2013"
                },
                new CarModel
                {
                    Id = 26,
                    CarManufacturerId = 5,
                    Name = "i8",
                    ModelYear = "2014-2020"
                },
                new CarModel
                {
                    Id = 27,
                    CarManufacturerId = 5,
                    Name = "M4 (F82)",
                    ModelYear = "2014-2020"
                },

                new CarModel
                {
                    Id = 28,
                    CarManufacturerId = 6,
                    Name = "C-Class (W202)",
                    ModelYear = "1993-2000"
                },
                new CarModel
                {
                    Id = 29,
                    CarManufacturerId = 6,
                    Name = "C-Class (W203)",
                    ModelYear = "2000-2007"
                },
                new CarModel
                {
                    Id = 30,
                    CarManufacturerId = 6,
                    Name = "E-Class (W210)",
                    ModelYear = "1995-2002"
                },
                new CarModel
                {
                    Id = 31,
                    CarManufacturerId = 6,
                    Name = "E-Class (W211)",
                    ModelYear = "2002-2009"
                },
                new CarModel
                {
                    Id = 32,
                    CarManufacturerId = 6,
                    Name = "S-Class (W220)",
                    ModelYear = "1999-2005"
                },
                new CarModel
                {
                    Id = 33,
                    CarManufacturerId = 6,
                    Name = "S-Class (W221)",
                    ModelYear = "2005-2013"
                },
                new CarModel
                {
                    Id = 34,
                    CarManufacturerId = 6,
                    Name = "G-Class (W463)",
                    ModelYear = "1990-present"
                },
                
                new CarModel
                {
                    Id = 35,
                    CarManufacturerId = 7,
                    Name = "Corsa A",
                    ModelYear = "1982-1993"
                },
                new CarModel
                {
                    Id = 36,
                    CarManufacturerId = 7,
                    Name = "Corsa B",
                    ModelYear = "1993-2000"
                },
                new CarModel
                {
                    Id = 37,
                    CarManufacturerId = 7,
                    Name = "Astra F",
                    ModelYear = "1991-1998"
                },
                new CarModel
                {
                    Id = 38,
                    CarManufacturerId = 7,
                    Name = "Astra G",
                    ModelYear = "1998-2004"
                },
                new CarModel
                {
                    Id = 39,
                    CarManufacturerId = 7,
                    Name = "Insignia A",
                    ModelYear = "2008-2017"
                },
                new CarModel
                {
                    Id = 40,
                    CarManufacturerId = 7,
                    Name = "Zafira A",
                    ModelYear = "1999-2005"
                },
                new CarModel
                {
                    Id = 41,
                    CarManufacturerId = 7,
                    Name = "Mokka X",
                    ModelYear = "2016-2019"
                },

                new CarModel
                {
                    Id = 42,
                    CarManufacturerId = 8,
                    Name = "Altima L31",
                    ModelYear = "2001-2006"
                },
                new CarModel
                {
                    Id = 43,
                    CarManufacturerId = 8,
                    Name = "Altima L32",
                    ModelYear = "2006-2012"
                },
                new CarModel
                {
                    Id = 44,
                    CarManufacturerId = 8,
                    Name = "GT-R R35",
                    ModelYear = "2007-present"
                },
                new CarModel
                {
                    Id = 45,
                    CarManufacturerId = 8,
                    Name = "Pathfinder R50",
                    ModelYear = "1995-2004"
                },
                new CarModel
                {
                    Id = 46,
                    CarManufacturerId = 8,
                    Name = "Pathfinder R52",
                    ModelYear = "2012-present"
                },
                new CarModel
                {
                    Id = 47,
                    CarManufacturerId = 8,
                    Name = "370Z Z34",
                    ModelYear = "2009-2020"
                },
                
                new CarModel
                {
                    Id = 48,
                    CarManufacturerId = 9,
                    Name = "Elantra HD",
                    ModelYear = "2006-2010"
                },
                new CarModel
                {
                    Id = 49,
                    CarManufacturerId = 9,
                    Name = "Elantra MD",
                    ModelYear = "2010-2015"
                },
                new CarModel
                {
                    Id = 50,
                    CarManufacturerId = 9,
                    Name = "Tucson JM",
                    ModelYear = "2004-2009"
                },
                new CarModel
                {
                    Id = 51,
                    CarManufacturerId = 9,
                    Name = "Tucson TL",
                    ModelYear = "2015-2020"
                },
                new CarModel
                {
                    Id = 52,
                    CarManufacturerId = 9,
                    Name = "Santa Fe DM",
                    ModelYear = "2012-2018"
                },
                new CarModel
                {
                    Id = 53,
                    CarManufacturerId = 9,
                    Name = "Santa Fe TM",
                    ModelYear = "2018-present"
                },
                new CarModel
                {
                    Id = 54,
                    CarManufacturerId = 9,
                    Name = "Kona OS",
                    ModelYear = "2017-present"
                },

                new CarModel
                {
                    Id = 55,
                    CarManufacturerId = 10,
                    Name = "A4 B6",
                    ModelYear = "2000–2006"
                },
                new CarModel
                {
                    Id = 56,
                    CarManufacturerId = 10,
                    Name = "Quattro",
                    ModelYear = "1980–1991"
                },
                new CarModel
                {
                    Id = 57,
                    CarManufacturerId = 10,
                    Name = "200 C4",
                    ModelYear = "1983–1992"
                },
                new CarModel
                {
                    Id = 58,
                    CarManufacturerId = 10,
                    Name = "TT (8N)",
                    ModelYear = "1998-2006"
                },
                new CarModel
                {
                    Id = 59,
                    CarManufacturerId = 10,
                    Name = "R8 (Typ 42)",
                    ModelYear = "2006-2015"
                },
                new CarModel
                {
                    Id = 60,
                    CarManufacturerId = 10,
                    Name = "A7 (Typ 4K8)",
                    ModelYear = "2019-present"
                }
            );
        }
    }
}
