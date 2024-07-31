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
            CreateMap<ClientInsertDTO, Client>();
            CreateMap<ClientUpdateDTO, Client>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<Client, ClientInsertDTO>();
            CreateMap<Client, ClientUpdateDTO>();
            CreateMap<Client, ClientGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name));
        }
    }
}
