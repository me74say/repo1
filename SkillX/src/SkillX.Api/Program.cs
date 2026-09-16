using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SkillX.Domain.Entities;
using SkillX.Infrastructure.Persistence;
using System.Text;
var builder=WebApplication.CreateBuilder(args);
var cs=builder.Configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("DefaultConnection is missing.");
builder.Services.AddDbContext<SkillXDbContext>(o=>o.UseNpgsql(cs));
builder.Services.AddIdentityCore<ApplicationUser>(o=>{o.User.RequireUniqueEmail=true;o.Password.RequiredLength=8;}).AddRoles<IdentityRole<Guid>>().AddEntityFrameworkStores<SkillXDbContext>().AddDefaultTokenProviders();
var jwt=builder.Configuration.GetSection("Jwt");
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(o=>o.TokenValidationParameters=new TokenValidationParameters{ValidateIssuer=true,ValidateAudience=true,ValidateLifetime=true,ValidateIssuerSigningKey=true,ValidIssuer=jwt["Issuer"],ValidAudience=jwt["Audience"],IssuerSigningKey=new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt["Key"]!))});
builder.Services.AddAuthorization();builder.Services.AddControllers();builder.Services.AddEndpointsApiExplorer();builder.Services.AddSwaggerGen();
var app=builder.Build();
using(var scope=app.Services.CreateScope()){await DbSeeder.SeedAsync(scope.ServiceProvider.GetRequiredService<SkillXDbContext>(),scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>(),scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole<Guid>>>());}
if(app.Environment.IsDevelopment()){app.UseSwagger();app.UseSwaggerUI();}
app.UseHttpsRedirection();app.UseAuthentication();app.UseAuthorization();app.MapControllers();app.MapGet("/",()=>Results.Ok(new{application="SkillX API",status="running"}));app.Run();
