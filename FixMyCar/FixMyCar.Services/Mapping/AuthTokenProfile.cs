using AutoMapper;
using FixMyCar.Model.DTOs.AuthToken;
using FixMyCar.Model.Entities;

namespace FixMyCar.Services.Mapping
{
    public class AuthTokenProfile : Profile
    {
        public AuthTokenProfile()
        {
            CreateMap<AuthTokentInsertDTO, AuthToken>();
            CreateMap<AuthTokenUpdateDTO, AuthToken>();
            CreateMap<AuthTokenGetDTO, AuthToken>();
            CreateMap<AuthToken, AuthTokentInsertDTO>();
            CreateMap<AuthToken, AuthTokenUpdateDTO>();
            CreateMap<AuthToken, AuthTokenGetDTO>();
        }
    }
}