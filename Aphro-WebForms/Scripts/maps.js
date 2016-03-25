$(function () {
    var selectedRow;
    balcony = false;
    clearFields();
    refreshMap();
});

function changeBalcony(event) {
    event.preventDefault();
    if (balcony) {
        balcony = false;
        $("#mapSwitch").html("Balcony");
    } else {
        balcony = true;
        $("#mapSwitch").html("Main Floor");
    }
    refreshMap();
}

function changeName(btn) {
    btn.Text = (balcony ? "Balcony" : "Main Floor");
    return false;
}

function refreshMap() {
    var eventId = $('#MainContent_EventDateDropDown').val();
    var buildingkey = $('#MainContent_BuildingKeyField').val();
    var eventLocation = $('#MainContent_EventLocation').text();
    clearFields();

    $.getJSON('../Shared/EmptySeats.ashx?eventId=' + eventId + '&buildingKey=' + buildingkey + '&balcony=' + balcony, function (data) {
        var buildingDataMap = [];
        var buildingDataArray = [];
        $.each(data.data, function (i) {
            if (this.seats >= $("#MainContent_GroupSize").val()) {
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

        $('#map').highcharts('Map', {
            chart: {
                events: {
                    drilldown: function (e) {
                        if (!e.seriesOptions) {
                            var chart = this;

                            $.getJSON('../Shared/EmptySeats.ashx?eventId=' + eventId + '&sectionKey=' + e.point.section + '&subsection=' + e.point.subsection, function (data) {
                                var sectionDataMap = [];
                                var sectionDataArray = [];
                                $.each(data.data, function (i) {
                                    if (this.seats >= $("#MainContent_GroupSize").val()) {
                                        var metaData = {}
                                        metaData["name"] = this.row;
                                        metaData["section"] = this.section;
                                        metaData["subsection"] = this.subsection;
                                        metaData["prime"] = this.prime;
                                        metaData["row"] = this.row;
                                        metaData["join"] = this.row;
                                        metaData["value"] = this.value;
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
                    }
                }
            },

            plotOptions: {
                series: {
                    point: {
                        events: {
                            select: function () {
                                selectedRow = this;
                                setFields(selectedRow);
                            },
                            unselect: function () {
                                if (selectedRow === this) {
                                    clearFields();
                                    selectedRow = null;
                                }
                            }
                        }
                    }
                }
            },
            legend: {
                align: 'left',
                y: 10,
                verticalAlign: 'top',
                floating: true,
                layout: 'vertical',
                valueDecimals: 0,
                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || 'rgba(255, 255, 255, 0.85)'
            },
            colorAxis: {
                dataClasses: [{
                    from: 0,
                    to: 0,
                    color: '#C40401',
                    name: 'Regular'
                }, {
                    from: 1,
                    to: 1,
                    color: '#0200D0',
                    name: 'Prime'
                }]
            },
            title: {
                text: eventLocation
            },
            mapNavigation: {
                enabled: false
            },
            series: [
                {
                    name: eventLocation,
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
                        y: 50
                    }
                }
            },
            colors: ['#000']
        });
    });
}

function clearFields() {
    $("#MainContent_GetTicketsForEvent").prop("disabled", true);
    $('#MainContent_SelectedSection').val('');
    $('#MainContent_SelectedSubsection').val('');
    $('#MainContent_SelectedRow').val('');
    $('#priceField').text('0.00');
}

function setFields(selectedSeat) {
    $("#MainContent_GetTicketsForEvent").prop("disabled", false);
    $('#MainContent_SelectedSection').val(selectedSeat.section);
    $('#MainContent_SelectedSubsection').val(selectedSeat.subsection);
    $('#MainContent_SelectedRow').val(selectedSeat.row);

    var groupSize = parseInt($("#MainContent_GroupSize").val(), 10);
    var price;
    if (selectedSeat.prime == 0)
        price = parseFloat($("#MainContent_EventPrice").text().replace("$", ""));
    else
        price = parseFloat($("#MainContent_EventPrimePrice").text().replace("$", ""));

    $('#priceField').text((groupSize * price).toFixed(2));
}