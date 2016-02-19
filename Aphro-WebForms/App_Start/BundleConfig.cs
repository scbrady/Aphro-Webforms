using System.Web.Optimization;

namespace Aphro_WebForms
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/carousel").Include(
                        "~/Scripts/carousel.js"));
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/moment.js",
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jquery-ui").Include(
                        "~/Scripts/jquery-ui-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/highmaps").Include(
                       "~/Scripts/highmaps/highmaps.js",
                       "~/Scripts/highmaps/data.js",
                       "~/Scripts/highmaps/drilldown.js"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js"));

            bundles.Add(new ScriptBundle("~/bundles/datepicker").Include(
                      "~/Scripts/bootstrap-datetimepicker.js"));

            bundles.Add(new ScriptBundle("~/bundles/map").Include(
                      "~/Scripts/maps.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/bootstrap-datetimepicker.css",
                      "~/Content/site.css"));

            bundles.Add(new StyleBundle("~/Content/font-awesome").Include(
                      "~/Content/font-awesome.css"));

            bundles.Add(new StyleBundle("~/Content/event-css").Include(
                      "~/Content/event.css"));
            bundles.Add(new StyleBundle("~/Content/guest-css").Include(
                      "~/Content/guest.css"));
            bundles.Add(new StyleBundle("~/Content/student-css").Include(
                      "~/Content/student.css"));
            bundles.Add(new StyleBundle("~/Content/faculty-css").Include(
                      "~/Content/faculty.css"));
            bundles.Add(new StyleBundle("~/Content/jquery-ui").Include(
                      "~/Content/themes/base/all.css"));
            bundles.Add(new StyleBundle("~/Content/carousel").Include(
                      "~/Content/carousel.css"));
        }
    }
}