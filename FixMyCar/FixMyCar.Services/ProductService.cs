using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public class ProductService : IProductService
    {
        FixMyCarContext _context;
        IMapper _mapper;
        public ProductService(FixMyCarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public IList<Product> Get()
        {
            var products = _context.Products.ToList();
            return products;
        }

        public Product Insert(ProductInsertDTO request)
        {
            var product = _mapper.Map<Product>(request);
            
            _context.Products.Add(product);
            _context.SaveChanges();

            return product;
        }

        public Product Update(int id, ProductUpdateDTO request)
        {
            var product = _context.Products.Find(id);

            _mapper.Map(request, product);

            _context.SaveChanges();

            return product;
        }
    }
}
