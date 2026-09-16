using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SkillX.Infrastructure.Persistence;
namespace SkillX.Api.Controllers;
[ApiController, Route("api/courses")]
public class CoursesController : ControllerBase
{
    private readonly SkillXDbContext _db; public CoursesController(SkillXDbContext db)=>_db=db;
    [HttpGet] public async Task<IActionResult> GetAll()=>Ok(await _db.Courses.AsNoTracking().ToListAsync());
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id){var x=await _db.Courses.FindAsync(id);return x is null?NotFound():Ok(x);}
    public record CourseRequest(string Name,string Code,string? Description);
    [HttpPost,Authorize(Roles="Admin,Coordinator")] public async Task<IActionResult> Create(CourseRequest r){var x=new SkillX.Domain.Entities.Course{Name=r.Name,Code=r.Code,Description=r.Description};_db.Courses.Add(x);await _db.SaveChangesAsync();return CreatedAtAction(nameof(Get),new{id=x.Id},x);}
}
