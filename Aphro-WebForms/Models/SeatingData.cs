using Newtonsoft.Json;
using System.Collections.Generic;

namespace Aphro_WebForms.Models
{
    public class SeatingData
    {
        [JsonProperty("type")]
        public string Type { get; set; }

        [JsonProperty("data")]
        public List<RowRecord> Data { get; set; }
    }

    public class RowRecord
    {
        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("section")]
        public int Section_Key { get; set; }

        [JsonProperty("subsection")]
        public int Subsection { get; set; }

        [JsonProperty("path")]
        public string Path { get; set; }

        [JsonProperty("seats")]
        public int Empty_Seats { get; set; }

        [JsonProperty("row")]
        public string Seat_Row { get; set; }

        [JsonProperty("prime")]
        public int Prime_Row { get; set; }

        [JsonProperty("prime-seat")]
        public string Is_Prime_Seat { get; set; }
    }
}