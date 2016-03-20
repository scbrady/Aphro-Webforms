namespace Aphro_WebForms.Models
{
    public class Person
    {
        public long person_id { get; set; }
        public string firstname { get; set; }
        public string lastname { get; set; }
        public string email { get; set; }
        public Account accountType { get; set; }
    }

    public enum Account
    {
        Guest,
        Student,
        Faculty,
        guest
    }
}