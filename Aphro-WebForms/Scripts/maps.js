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

    var groupSizeElement;
    if ($("#MainContent_GroupSize").length)
        groupSizeElement = $("#MainContent_GroupSize");
    else
        groupSizeElement = $("#MainContent_GuestTicketsSize");

    clearFields();

    $.getJSON('../Shared/EmptySeats.ashx?eventId=' + eventId + '&buildingKey=' + buildingkey + '&balcony=' + balcony, function (data) {
        var buildingDataMap = [];
        var buildingDataArray = [];
        $.each(data.data, function (i) {
            if (this.seats >= groupSizeElement.val()) {
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
                                    if (this.seats >= groupSizeElement.val()) {
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
                                            color: '#3BFFB0' // light emerald
                                        },
                                        select: {
                                            color: '#6464D1',      // light purple
                                            borderColor: '#B0B0B0', // border grey
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
            lang: {
                drillUpText: 'Back'
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
                    color: '#BDE5F2', // light blue
                    name: 'Regular'
                }, {
                    from: 1,
                    to: 1,
                    color: '#E4BDF2', // light purple
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
                    },
                    theme: {
                        fill: '#32a3dc',
                        stroke: 'silver',
                        r: 3,
                        states: {
                            hover: {
                                fill: '#2e6da4'
                            },
                            select: {
                                fill: '#2e6da4'
                            }
                        },
                        style: {
                            color: 'white'
                        }
                    }
                }
            },
            colors: ['#E8E5E3'] // light grey
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

    var guests = tryParseInt($("#MainContent_GuestTicketsSize").val(), 10);
    var seasonTickets = tryParseInt($("#MainContent_SeasonTickets").val(), 10);
    var price;
    if (selectedSeat.prime == 0)
        price = tryParseFloat($("#MainContent_EventPrice").text().replace("$", ""));
    else
        price = tryParseFloat($("#MainContent_EventPrimePrice").text().replace("$", ""));

    $('#priceField').text(((guests > seasonTickets ? guests-seasonTickets : 0) * price).toFixed(2));
}

function tryParseInt(number) {
    var parsed;
    parsed = parseFloat(number);
    if (!isNaN(parsed))
        return parsed;
    else
        return 0;
}

function tryParseFloat(number) {
    var parsed;
    parsed = parseFloat(number);
    if (!isNaN(parsed))
        return parsed;
    else
        return 0;
}