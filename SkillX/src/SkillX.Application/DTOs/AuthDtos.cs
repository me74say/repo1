namespace SkillX.Application.DTOs;
public record RegisterRequest(string Email, string Password, string FullName);
public record LoginRequest(string Email, string Password);
public record AuthResponse(string AccessToken, DateTime ExpiresAtUtc);
public record CreateApplicantRequest(Guid UserId, string City, string? Phone, string? ProfilePhotoPath, string? IdentityCardFrontPath, string? IdentityCardBackPath);
