using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SkillX.Domain.Entities;
namespace SkillX.Infrastructure.Persistence;
public class SkillXDbContext : IdentityDbContext<ApplicationUser, Microsoft.AspNetCore.Identity.IdentityRole<Guid>, Guid>
{
    public SkillXDbContext(DbContextOptions<SkillXDbContext> options) : base(options) { }
    public DbSet<Applicant> Applicants => Set<Applicant>();
    public DbSet<Course> Courses => Set<Course>();
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        builder.Entity<Applicant>().HasIndex(x => x.UserId).IsUnique();
        builder.Entity<Applicant>().HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
        builder.Entity<Course>().HasIndex(x => x.Code).IsUnique();
    }
}
