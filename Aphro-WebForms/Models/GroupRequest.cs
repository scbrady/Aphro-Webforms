using System;

namespace Aphro_WebForms.Models
{
    public class GroupRequest
    {
        public long group_id { get; set; }
        public long group_leader_id { get; set; }
        public string group_leader_firstname { get; set; }
        public string group_leader_lastname { get; set; }
        public int guest_tickets { get; set; }
        public int faculty_tickets { get; set; }
        public long requested_id { get; set; }
        public string requested_firstname { get; set; }
        public string requested_lastname { get; set; }
        public int has_accepted { get; set; }
    }
}