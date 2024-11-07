FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5148
ENV ASPNETCORE_URLS=http://+:5148
ENV STRIPE_SECRET_KEY=""
ENV STRIPE_PUBLISHABLE_KEY=""

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "FixMyCar.API/FixMyCar.API.csproj"
RUN dotnet build "FixMyCar.API/FixMyCar.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FixMyCar.API/FixMyCar.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

RUN mkdir -p /app/RecommenderModels && \
    chmod 777 /app/RecommenderModels

COPY FixMyCar.API/RecommenderModels/. /app/RecommenderModels/

ENTRYPOINT ["dotnet", "FixMyCar.API.dll"]