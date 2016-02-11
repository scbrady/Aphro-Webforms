$(function () {
    var selectedRow;
    var eventId = $('#eventid').val();
    var buildingkey = $('#buildingkey').val();
    $.getJSON('../Shared/EmptySeats.ashx?eventId=' + eventId + '&buildingKey=' + buildingkey, function (data) {
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

                            $.getJSON('../Shared/EmptySeats.ashx?eventId=' + eventId + '&sectionKey=' + e.point.section + '&subsection=' + e.point.subsection, function (data) {
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
                                        pointFormat: ''
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
                        pointFormat: ''
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
});

function clearFields() {
    $('#MainContent_SelectedSection').val('');
    $('#MainContent_SelectedSubsection').val('');
    $('#MainContent_SelectedRow').val('');
}