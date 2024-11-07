FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7013

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["FixMyCar.HelperAPI/FixMyCar.HelperAPI.csproj", "FixMyCar.HelperAPI/"]
COPY ["FixMyCar.Model/FixMyCar.Model.csproj", "FixMyCar.Model/"]
COPY ["FixMyCar.Services/FixMyCar.Services.csproj", "FixMyCar.Services/"]
RUN dotnet restore "FixMyCar.HelperAPI/FixMyCar.HelperAPI.csproj"
COPY . .
RUN dotnet build "FixMyCar.HelperAPI/FixMyCar.HelperAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FixMyCar.HelperAPI/FixMyCar.HelperAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FixMyCar.HelperAPI.dll"]