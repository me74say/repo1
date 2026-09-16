using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SkillX.Application.DTOs;
using SkillX.Domain.Entities;
using SkillX.Infrastructure.Persistence;
namespace SkillX.Api.Controllers;
[ApiController, Route("api/applicants")]
[Authorize]
public class ApplicantsController : ControllerBase
{
    private readonly SkillXDbContext _db; public ApplicantsController(SkillXDbContext db)=>_db=db;
    [HttpGet] public async Task<ActionResult<IEnumerable<Applicant>>> GetAll()=>Ok(await _db.Applicants.AsNoTracking().ToListAsync());
    [HttpGet("{id:guid}")] public async Task<ActionResult<Applicant>> Get(Guid id){var x=await _db.Applicants.FindAsync(id); return x is null?NotFound():Ok(x);}
    [HttpPost] public async Task<ActionResult<Applicant>> Create(CreateApplicantRequest r){if(await _db.Applicants.AnyAsync(x=>x.UserId==r.UserId))return Conflict("Applicant already exists for this user."); var x=new Applicant{UserId=r.UserId,City=r.City,Phone=r.Phone,ProfilePhotoPath=r.ProfilePhotoPath,IdentityCardFrontPath=r.IdentityCardFrontPath,IdentityCardBackPath=r.IdentityCardBackPath}; _db.Applicants.Add(x); await _db.SaveChangesAsync(); return CreatedAtAction(nameof(Get),new{id=x.Id},x);}
    [HttpPatch("{id:guid}/status")] [Authorize(Roles="Admin,Coordinator")] public async Task<IActionResult> Status(Guid id,[FromBody]string status){var x=await _db.Applicants.FindAsync(id);if(x is null)return NotFound();x.Status=status;await _db.SaveChangesAsync();return Ok(x);}
}
