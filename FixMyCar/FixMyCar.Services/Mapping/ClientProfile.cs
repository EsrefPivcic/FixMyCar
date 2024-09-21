using AutoMapper;
using FixMyCar.Model.DTOs.Client;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class ClientProfile : Profile
    {
        public ClientProfile()
        {
            CreateMap<ClientInsertDTO, Client>()
                .ForMember(dest => dest.CityId, opt => opt.Ignore())
                .ForMember(dest => dest.City, opt => opt.Ignore())
                .ForMember(dest => dest.Image, opt => opt.Ignore());
            CreateMap<ClientUpdateDTO, Client>()
                .ForMember(dest => dest.Username, opt => opt.Ignore())
                .ForMember(dest => dest.City, opt => opt.Ignore())
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<Client, ClientInsertDTO>();
            CreateMap<Client, ClientUpdateDTO>();
            CreateMap<Client, ClientGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name))
                .ForMember(dest => dest.City, opt => opt.MapFrom(src => src.City.Name))
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
        }
    }
}
