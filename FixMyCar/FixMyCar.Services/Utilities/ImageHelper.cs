using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Utilities
{
    public class ImageHelper
    {
        public static byte[] GetImageData(string path)
        {
            return File.ReadAllBytes(path);
        }
    }
}
