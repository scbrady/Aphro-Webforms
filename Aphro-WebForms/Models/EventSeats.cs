namespace Aphro_WebForms.Models
{
    public class EventSeats
    {
        public long person_id { get; set; }
        public string firstname { get; set; }
        public string lastname { get; set; }
        public string description { get; set; }
        public string door { get; set; }
        public string seat_row { get; set; }
        public int seat_number { get; set; }
        public int guest_tickets { get; set; }
        public int faculty_tickets { get; set; }
    }
}