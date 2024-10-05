using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Utilities
{
    public class ProductEntry
    {
        [KeyType(count: 10)]
        public uint ProductId { get; set; }

        [KeyType(count: 10)]
        public uint CoPurchaseProductId { get; set; }

        public float Label { get; set; }
    }
}
