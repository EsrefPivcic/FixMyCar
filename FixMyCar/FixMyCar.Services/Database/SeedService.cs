using FixMyCar.Model.Entities;
using FixMyCar.Services.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Database
{
    public class SeedService
    {
        private readonly FixMyCarContext _context;

        public SeedService(FixMyCarContext context)
        {
            _context = context;
        }

        public async Task SeedData()
        {
            await _context.Database.EnsureCreatedAsync();

            if (!_context.StoreItems.Any())
            {
                var ebcTurboPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "EBC-Turbo.png");
                var monsterMotorsportPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "Monster-motorsport.png");
                var oem_r32 = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "OEM-R32.png");

                await _context.StoreItems.AddRangeAsync(
                    new StoreItem
                    {
                        Name = "EBC-Turbo",
                        ImageData = ImageHelper.GetImageData(ebcTurboPath),
                        State = "draft",
                        Price = 350,
                        Discount = 0,
                        DiscountedPrice = 350,
                        Details = "The Turbo Groove Discs have unique wide slots which help cool the discs and brake pads alike, " +
                        "and together with the blind drilled dimples help clear surface gases without affecting the structure of the disc unlike through drilled discs. " +
                        "Dirt, dust gases, grit or debris from heavy braking exit the pad braking area through the slots that extend to the outer edge of the disc – " +
                        "a unique feature of the EBC discs. This ensures brakes pads wear flat and parallel throughout their use, in turn improving your braking. " +
                        "Anodised by gold zinc; these discs are also protected from corrosion in the areas not swept by the brake pad. " +
                        "As with most sport discs a small amount of noise can be produced, but this gradually diminishes and is minimal at around 1,000 miles of road use. " +
                        "These EBC discs offer outstanding performance and are often favoured by performance drivers. " +
                        "Want the best braking performance use Turbo Groove Discs with Yellowstuff Pads.",
                        CarPartsShopId = 2,
                        StoreItemCategoryId = 1,
                    },
                    new StoreItem
                    {
                        Name = "Monster-Motorsport",
                        ImageData = ImageHelper.GetImageData(monsterMotorsportPath),
                        State = "draft",
                        Price = 250,
                        Discount = 0.1,
                        DiscountedPrice = 250 - (250 * 0.1),
                        Details = "Black Diamond DISCS. These award winning brake discs are made to the most exacting standards using computer aided design and computerised " +
                        "production whether you buy a Black Diamond X Drilled range for extra cooling Black Diamond 6- & 12-Groove range for more instant response and greater " +
                        "friction or Black Diamond's award winning Combination range for extra cooling extra friction and instant response you will always get Black Diamond's " +
                        "unique compound and extra heat treatment to provide you with awesome braking performance.",
                        CarPartsShopId = 2,
                        StoreItemCategoryId = 1,
                    },
                    new StoreItem
                    {
                        Name = "OEM-R32 Brembo",
                        ImageData = ImageHelper.GetImageData(oem_r32),
                        State = "draft",
                        Price = 400,
                        Discount = 0,
                        DiscountedPrice = 400,
                        Details = "Pair of Mk4 Golf R32 334mm x 32mm Front Brake Discs. Mk4 Golf R32 Front Brake Disc Set - 334mm x 32mm. " +
                        "These are replacement discs for Mk4 Golf R32, or vehicles running this brake set up with 334mm front brake discs. " +
                        "This Kit Consists of: LH Brake Disc, RH Brake Disc.",
                        CarPartsShopId = 2,
                        StoreItemCategoryId = 1,
                    }
                );
                await _context.SaveChangesAsync();
            }

            if (!_context.StoreItemCarModels.Any())
            {
                await _context.StoreItemCarModels.AddRangeAsync(
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
                await _context.SaveChangesAsync();
            }
        }
    }
}
