using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SkillX.Domain.Entities;
namespace SkillX.Infrastructure.Persistence;
public static class DbSeeder
{
    public static async Task SeedAsync(SkillXDbContext db, UserManager<ApplicationUser> users, RoleManager<IdentityRole<Guid>> roles)
    {
        await db.Database.MigrateAsync();
        foreach (var role in new[] { "Admin", "Coordinator", "Instructor", "Student" })
            if (!await roles.RoleExistsAsync(role)) await roles.CreateAsync(new IdentityRole<Guid>(role));
        const string email = "admin@skillx.local";
        var admin = await users.FindByEmailAsync(email);
        if (admin is null)
        {
            admin = new ApplicationUser { Id = Guid.NewGuid(), UserName = email, Email = email, EmailConfirmed = true, FullName = "SkillX Administrator" };
            var result = await users.CreateAsync(admin, "Admin123!");
            if (!result.Succeeded) throw new InvalidOperationException(string.Join("; ", result.Errors.Select(e => e.Description)));
            await users.AddToRoleAsync(admin, "Admin");
        }
        if (!await db.Courses.AnyAsync())
            db.Courses.AddRange(new Course { Name = "Web Development", Code = "WEB-101", Description = "Foundations of modern web development." }, new Course { Name = "Data Analytics", Code = "DATA-101", Description = "Practical data analysis fundamentals." });
        await db.SaveChangesAsync();
    }
}
