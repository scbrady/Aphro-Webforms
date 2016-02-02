<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Guest.EventSignup" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="EventName" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventDescription" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventLocation" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventPrice" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>
    
    <asp:ListView ID="EventDateListview" runat="server">
        <LayoutTemplate>         
            <div id="EventDateContainer" runat="server">              
                <div ID="itemPlaceholder" runat="server">              
                </div>         
            </div>      
        </LayoutTemplate>
        <ItemTemplate>
            <asp:HyperLink runat="server" ID="EventDateLink" NavigateUrl='<%# "#"+ Eval("event_id") %>' Text='<%# Eval("event_datetime") %>'></asp:HyperLink>
            <br/>
        </ItemTemplate>
    </asp:ListView>

    <asp:HiddenField ID="SelectedSection" runat="server" />
    <asp:HiddenField ID="SelectedSubsection" runat="server" />
    <asp:HiddenField ID="SelectedRow" runat="server" />
    <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="1" max="20" step="1" value="1"/>
    <button id="refresh">Refresh</button>
    
    <div id="container" style="max-width: 1000px"></div>
    <asp:Button ID="Submit" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %>

    <script type="text/javascript">
        
        $(function () {
            var selectedRow;
            refreshMap();

            $('#refresh').click(function(event) {
                refreshMap();
                event.preventDefault();
            });
        });

        function refreshMap() {
            $.getJSON('EmptySeats.ashx?eventId=<%= EventId %>&buildingKey=<%= BuildingKey %>', function (data) {
                var buildingDataMap = [];
                var buildingDataArray = [];
                $.each(data.data, function (i) {
                    if (this.seats >= $("#MainContent_TicketQuantity").val()) {
                        var metaData = {}
                        metaData["name"] = this.name;
                        metaData["join"] = this.section + "-" + this.subsection;
                        metaData["section"] = this.section;
                        metaData["subsection"] = this.subsection;
                        metaData["value"] = this.seats;
                        metaData["drilldown"] = this.section;
                        buildingDataArray.push(metaData);
                    }

                    var mapData = {}
                    mapData["join"] = this.section + "-" + this.subsection;
                    mapData["path"] = this.path;
                    buildingDataMap.push(mapData);
                });
            
                $('#container').highcharts('Map', {
                    chart: {
                        events: {
                            drilldown: function (e) {
                                if (!e.seriesOptions) {
                                    var chart = this;

                                    $.getJSON('EmptySeats.ashx?eventId=<%= EventId %>&sectionKey=' + e.point.section + '&subsection=' + e.point.subsection, function (data) {
                                        var sectionDataMap = [];
                                        var sectionDataArray = [];
                                        $.each(data.data, function (i) {
                                            if (this.seats >= $("#MainContent_TicketQuantity").val()) {
                                                var metaData = {}
                                                metaData["name"] = this.row;
                                                metaData["section"] = this.section;
                                                metaData["subsection"] = this.subsection;
                                                metaData["row"] = this.row;
                                                metaData["join"] = this.row;
                                                metaData["value"] = this.seats;
                                                sectionDataArray.push(metaData);
                                            }

                                            var mapData = {}
                                            mapData["join"] = this.row;
                                            mapData["path"] = this.path;
                                            sectionDataMap.push(mapData);
                                        });
                                        chart.addSeriesAsDrilldown(e.point, {
                                            name: e.point.row,
                                            mapData: sectionDataMap,
                                            data: sectionDataArray,
                                            joinBy: ["join"],
                                            allowPointSelect: true,
                                            cursor: 'pointer',
                                            states: {
                                                hover: {
                                                    color: '#BADA55'
                                                },
                                                select: {
                                                    color: '#006D91',
                                                    borderColor: 'black',
                                                    dashStyle: 'dot'
                                                }
                                            },
                                            tooltip: {
                                                headerFormat: 'Row {point.key}<br/>',
                                                pointFormat: '{point.value} Empty Seats'
                                            }
                                        });
                                    });
                                }
                                this.setTitle(null, { text: e.point.name });
                            },
                            drillup: function () {
                                this.setTitle(null, { text: '' });
                                clearFields();
                                //$('#test').text('');
                            }
                        }
                    },
                    plotOptions: {
                        series: {
                            point: {
                                events: {
                                    select: function () {
                                        selectedRow = this;
                                        $('#MainContent_SelectedSection').val(this.section);
                                        $('#MainContent_SelectedSubsection').val(this.subsection);
                                        $('#MainContent_SelectedRow').val(this.row);
                                        //$('#test').text('You selected Section: ' + this.section + ' Subsection: ' + this.subsection + ' Row: ' + this.row);
                                    },
                                    unselect: function () {
                                        if (selectedRow === this) {
                                            clearFields();
                                            //$('#test').text('');
                                            selectedRow = null;
                                        }
                                    }
                                }
                            }
                        }
                    },
                    title: {
                        text: "<%= Building %>"
                    },
                    legend: {
                        enabled: false
                    },
                    mapNavigation: {
                        enabled: false
                    },
                    series: [
                        {
                            name: "<%= Building %>",
                            type: "map",
                            mapData: buildingDataMap,
                            data: buildingDataArray,
                            joinBy: ["join"],
                            tooltip: {
                                headerFormat: '{point.key}<br/>',
                                pointFormat: '{point.value} Empty Seats'
                            }
                        }
                    ],
                    drilldown: {
                        drillUpButton: {
                            relativeTo: 'spacingBox',
                            position: {
                                x: 0,
                                y: 60
                            }
                        }
                    }

                });
            });
        }

        function clearFields() {
            $('#MainContent_SelectedSection').val('');
            $('#MainContent_SelectedSubsection').val('');
            $('#MainContent_SelectedRow').val('');
        }
    </script>
</asp:Content>
