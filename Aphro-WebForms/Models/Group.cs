using System.Collections.Generic;

namespace Aphro_WebForms.Models
{
    public class Group
    {
        public long group_id { get; set; }
        public string group_leader_firstname { get; set; }
        public string group_leader_lastname { get; set; }
        public int guests { get; set; }
        public List<GroupRequest> group_requests { get; set; }
    }
}