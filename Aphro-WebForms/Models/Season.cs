using System.Collections.Generic;

namespace Aphro_WebForms.Models
{
    public class Season
    {
        public long season_id { get; set; }
        public string name { get; set; }
        public float price { get; set; }
        public int ticket_count { get; set; }

        public string event_name { get; set; }
        public List<string> event_names { get; set; }
    }
}