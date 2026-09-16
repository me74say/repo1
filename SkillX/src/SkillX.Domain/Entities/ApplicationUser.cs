using Microsoft.AspNetCore.Identity;
namespace SkillX.Domain.Entities;
public class ApplicationUser : IdentityUser<Guid>
{
    public string FullName { get; set; } = string.Empty;
    public string? ProfilePhotoPath { get; set; }
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}
