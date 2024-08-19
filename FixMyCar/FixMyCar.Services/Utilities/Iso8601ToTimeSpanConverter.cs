using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Utilities
{
    public class Iso8601ToTimeSpanConverter
    {
        public TimeSpan Convert(string source, TimeSpan destination, ResolutionContext context)
        {
            return source != null ? XmlConvert.ToTimeSpan(source) : TimeSpan.Zero;
        }
    }
}
