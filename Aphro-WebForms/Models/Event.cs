using System;

namespace Aphro_WebForms.Models
{
    public class Event
    {
        public long event_id { get; set; }
        public long series_id { get; set; }
        public int building_key { get; set; }
        public long event_type_id { get; set; }
        public long season_id { get; set; }
        public string name { get; set; }
        public string description { get; set; }
        public DateTime event_datetime { get; set; }
        public string friendly_date { get; set; }
        public float regular_price { get; set; }
        public float prime_price { get; set; }
        public string event_picture { get; set; }

        public string event_type { get; set; }
        public string building { get; set; }
    }
}