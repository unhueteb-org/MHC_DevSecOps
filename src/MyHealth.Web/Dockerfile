FROM microsoft/aspnetcore:1.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:1.0 AS build
WORKDIR /src
COPY ["src/MyHealth.Web/MyHealth.Web.csproj", "src/MyHealth.Web/"]
COPY ["src/MyHealth.API/MyHealth.API.csproj", "src/MyHealth.API/"]
COPY ["src/MyHealth.Data/MyHealth.Data.csproj", "src/MyHealth.Data/"]
COPY ["src/MyHealth.Model/MyHealth.Model.csproj", "src/MyHealth.Model/"]
RUN dotnet restore "src/MyHealth.Web/MyHealth.Web.csproj"
COPY . .
WORKDIR "/src/src/MyHealth.Web"
RUN dotnet build "MyHealth.Web.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "MyHealth.Web.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "MyHealth.Web.dll"]
