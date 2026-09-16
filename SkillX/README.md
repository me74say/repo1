# SkillX API

A ready-to-run ASP.NET Core Web API starter for SkillX using .NET 10, PostgreSQL, EF Core, ASP.NET Core Identity, and JWT authentication.

## Requirements
- .NET 10 SDK
- PostgreSQL 15+

## Run
1. Create a PostgreSQL database named `skillx`.
2. Update `ConnectionStrings:DefaultConnection` and JWT settings in `src/SkillX.Api/appsettings.json` or use environment variables.
3. From `SkillX/` run:

```bash
dotnet restore
dotnet build
dotnet run --project src/SkillX.Api
```

Swagger: `http://localhost:5000/swagger`

The API seeds roles and a development admin account on startup.

Default development admin: `admin@skillx.local` / `Admin123!`

Change this password before any real deployment.
