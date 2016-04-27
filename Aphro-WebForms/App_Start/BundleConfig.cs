using System.Web.Optimization;

namespace Aphro_WebForms
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
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

            bundles.Add(new ScriptBundle("~/bundles/event_creation").Include(
                      "~/Scripts/event_creation.js",
                      "~/Scripts/rome.standalone.js"));

            bundles.Add(new ScriptBundle("~/bundles/map").Include(
                      "~/Scripts/maps.js",
                      "~/Scripts/plus_minus_buttons.js"));

            bundles.Add(new ScriptBundle("~/bundles/group_requests").Include(
                      "~/Scripts/group_requests.js"));

            bundles.Add(new ScriptBundle("~/bundles/slick").Include(
                      "~/Scripts/slick.js",
                      "~/Scripts/slick-init.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/sei.css"));

            bundles.Add(new StyleBundle("~/Content/datepicker").Include(
                      "~/Content/rome.css"));

            bundles.Add(new StyleBundle("~/Content/font-awesome").Include(
                      "~/Content/font-awesome.css"));

            bundles.Add(new StyleBundle("~/Content/event-css").Include(
                      "~/Content/event.css",
                      "~/Content/pcci-styles.css"));

            bundles.Add(new StyleBundle("~/Content/guest-css").Include(
                      "~/Content/guest.css",
                      "~/Content/pcci-styles.css"));

            bundles.Add(new StyleBundle("~/Content/student-css").Include(
                      "~/Content/student.css"));

            bundles.Add(new StyleBundle("~/Content/faculty-css").Include(
                      "~/Content/faculty.css"));

            bundles.Add(new StyleBundle("~/Content/jquery-ui").Include(
                      "~/Content/themes/base/autocomplete.css",
                      "~/Content/themes/base/theme.css",
                      "~/Content/themes/base/core.css",
                      "~/Content/themes/base/menu.css"));

            bundles.Add(new StyleBundle("~/Content/slick").Include(
                      "~/Content/slick.css",
                      "~/Content/slick-theme.css"));

            bundles.Add(new StyleBundle("~/Content/home").Include(
                      "~/Content/home.css"));

            bundles.Add(new StyleBundle("~/Content/map-css").Include(
                      "~/Content/map-modal.css"));

            bundles.Add(new StyleBundle("~/Content/group-requests").Include(
                      "~/Content/group-requests.css"));

            bundles.Add(new StyleBundle("~/Content/group-removals").Include(
                      "~/Content/group-removals.css"));
        }
    }
}