using FixMyCar.Model.Entities;
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

        public virtual DbSet<Product> Products { get; set; }
        public virtual DbSet<Discount> Discounts { get; set; }
    }
}
