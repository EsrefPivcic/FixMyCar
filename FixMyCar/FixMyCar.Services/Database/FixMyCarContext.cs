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
        public virtual DbSet<CarRepairShop> CarRepairShops { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

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


            var ebcTurboPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "EBC-Turbo.png");
            var monsterMotorsportPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "Monster-motorsport.png");
            var oem_r32 = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "OEM-R32.png");

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

            modelBuilder.Entity<StoreItem>().HasData(
                new StoreItem
                {
                    Id = 1,
                    Name = "EBC-Turbo",
                    ImageData = ImageHelper.GetImageData(ebcTurboPath),
                    ImageMimeType = "image/png",
                    State = "draft",
                    Discount = 0,
                    Details = "The Turbo Groove Discs have unique wide slots which help cool the discs and brake pads alike, " +
                    "and together with the blind drilled dimples help clear surface gases without affecting the structure of the disc unlike through drilled discs. " +
                    "Dirt, dust gases, grit or debris from heavy braking exit the pad braking area through the slots that extend to the outer edge of the disc – " +
                    "a unique feature of the EBC discs. This ensures brakes pads wear flat and parallel throughout their use, in turn improving your braking. " +
                    "Anodised by gold zinc; these discs are also protected from corrosion in the areas not swept by the brake pad. " +
                    "As with most sport discs a small amount of noise can be produced, but this gradually diminishes and is minimal at around 1,000 miles of road use. " +
                    "These EBC discs offer outstanding performance and are often favoured by performance drivers. " +
                    "Want the best braking performance use Turbo Groove Discs with Yellowstuff Pads.",
                    StoreItemCategoryId = 1,
                },
                new StoreItem
                {
                    Id = 2,
                    Name = "Monster-Motorsport",
                    ImageData = ImageHelper.GetImageData(monsterMotorsportPath),
                    ImageMimeType = "image/png",
                    State = "draft",
                    Discount = 0.1,
                    Details = "Black Diamond DISCS. These award winning brake discs are made to the most exacting standards using computer aided design and computerised " +
                    "production whether you buy a Black Diamond X Drilled range for extra cooling Black Diamond 6- & 12-Groove range for more instant response and greater " +
                    "friction or Black Diamond's award winning Combination range for extra cooling extra friction and instant response you will always get Black Diamond's " +
                    "unique compound and extra heat treatment to provide you with awesome braking performance.",
                    StoreItemCategoryId = 1,
                },
                new StoreItem
                {
                    Id = 3,
                    Name = "OEM-R32 Brembo",
                    ImageData = ImageHelper.GetImageData(oem_r32),
                    ImageMimeType = "image/png",
                    State = "draft",
                    Discount = 0,
                    Details = "Pair of Mk4 Golf R32 334mm x 32mm Front Brake Discs. Mk4 Golf R32 Front Brake Disc Set - 334mm x 32mm. " +
                    "These are replacement discs for Mk4 Golf R32, or vehicles running this brake set up with 334mm front brake discs. " +
                    "This Kit Consists of: LH Brake Disc, RH Brake Disc.",
                    StoreItemCategoryId = 1,
                }
            );

            modelBuilder.Entity<StoreItemCarModel>().HasData(
                new StoreItemCarModel
                {
                    StoreItemId = 1,
                    CarModelId = 1
                },
                new StoreItemCarModel
                {
                    StoreItemId = 1,
                    CarModelId = 2
                },
                new StoreItemCarModel
                {
                    StoreItemId = 2,
                    CarModelId = 1
                },
                new StoreItemCarModel
                {
                    StoreItemId = 2,
                    CarModelId = 2
                },
                new StoreItemCarModel
                {
                    StoreItemId = 3,
                    CarModelId = 1
                },
                new StoreItemCarModel
                {
                    StoreItemId = 3,
                    CarModelId = 2
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
