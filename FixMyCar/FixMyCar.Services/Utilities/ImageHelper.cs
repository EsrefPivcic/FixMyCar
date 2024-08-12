using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;
using SkiaSharp;

namespace FixMyCar.Services.Utilities
{
    public class ImageHelper
    {
        public static byte[] GetImageData(string path)
        {
            return File.ReadAllBytes(path);
        }

        public static byte[]? Resize(byte[] imageBytes, int size, int quality = 95)
        {
            using var input = new MemoryStream(imageBytes);
            using var inputStream = new SKManagedStream(input);
            using var original = SKBitmap.Decode(inputStream);

            int width, height;
            if (original.Width > original.Height)
            {
                width = size;
                height = original.Height * size / original.Width;
            }
            else
            {
                width = original.Width * size / original.Height;
                height = size;
            }

            using var resized = original.Resize(new SKImageInfo(width, height), SKFilterQuality.Medium);
            if (resized == null)
            {
                return null;
            }  

            using var image = SKImage.FromBitmap(resized);
            return image.Encode(SKEncodedImageFormat.Png, quality).ToArray();
        }
    }
}
