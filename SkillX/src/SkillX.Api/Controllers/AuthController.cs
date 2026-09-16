using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using SkillX.Application.DTOs;
using SkillX.Domain.Entities;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
namespace SkillX.Api.Controllers;
[ApiController, Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _users; private readonly IConfiguration _config;
    public AuthController(UserManager<ApplicationUser> users, IConfiguration config) { _users = users; _config = config; }
    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterRequest request) { var user = new ApplicationUser { UserName=request.Email, Email=request.Email, FullName=request.FullName, EmailConfirmed=true }; var r=await _users.CreateAsync(user,request.Password); if(!r.Succeeded) return BadRequest(r.Errors); await _users.AddToRoleAsync(user,"Student"); return Ok(new { user.Id, user.Email, user.FullName }); }
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request) { var user=await _users.FindByEmailAsync(request.Email); if(user is null || !await _users.CheckPasswordAsync(user,request.Password)) return Unauthorized(); var claims=new List<Claim>{new(JwtRegisteredClaimNames.Sub,user.Id.ToString()),new(JwtRegisteredClaimNames.Email,user.Email!),new(ClaimTypes.Name,user.UserName!)}; foreach(var role in await _users.GetRolesAsync(user)) claims.Add(new Claim(ClaimTypes.Role,role)); var key=new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!)); var creds=new SigningCredentials(key,SecurityAlgorithms.HmacSha256); var expires=DateTime.UtcNow.AddMinutes(int.Parse(_config["Jwt:Minutes"]!)); var token=new JwtSecurityToken(_config["Jwt:Issuer"],_config["Jwt:Audience"],claims,expires:expires,signingCredentials:creds); return Ok(new AuthResponse(new JwtSecurityTokenHandler().WriteToken(token),expires)); }
}
