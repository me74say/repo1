namespace SkillX.Domain.Entities;
public class Applicant
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public string City { get; set; } = string.Empty;
    public string? Phone { get; set; }
    public string? ProfilePhotoPath { get; set; }
    public string? IdentityCardFrontPath { get; set; }
    public string? IdentityCardBackPath { get; set; }
    public string Status { get; set; } = "Pending";
    public DateTime SubmittedAtUtc { get; set; } = DateTime.UtcNow;
    public ApplicationUser? User { get; set; }
}
