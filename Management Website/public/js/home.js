let map;
var availableBuses = [];

    async function initMap(buses)
    {

    const position = { lat: 23.2026, lng: 72.5838 };
    // Request needed libraries.
    //@ts-ignore
    const { Map } = await google.maps.importLibrary("maps");

    // The map, centered at Uluru
    map = new Map(document.getElementById("map"), {
        zoom: 16,
        center: position,
        mapId: "DEMO_MAP_ID",
    });

    const trafficLayer = new google.maps.TrafficLayer();
    trafficLayer.setMap(map);

    // The marker, positioned at Uluru
}

initMap();

function changeCenter(e)
{
    var lati;
    var long;

    for(var i=0; i<availableBuses.length;i++)
    {
        if(availableBuses[i]['busNumberPlate']==e.innerHTML)
        {
            lati = availableBuses[i]['currentLatitude'];
            long = availableBuses[i]['currentLongitude'];
        }
    }

    setTimeout(() => {
        map.setZoom(18);
        map.setCenter({lat: lati, lng: long});},500);

    
}

fetch('/buses/list')
    .then(response => response.json())
    .then(data => {
        for(var i=0; i<data.length;i++)
        {
            markers(data[i]);
            availableBuses.push(data[i]);
        }
    })
    .catch(error => {
        console.error('Error fetching value:', error);
    });

async function markers(buses)
{

    var image;
    var color;

    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    if( (buses['currentNumberOfPassenger']/buses['totalPassengerCapacity'])*100 <= 30)
    {
        image = document.createElement("img");
        image.src = "https://i.ibb.co/71wGv8T/Buslogo1.png";
        color = "lime";
    }

    else if( ((buses['currentNumberOfPassenger']/buses['totalPassengerCapacity'])*100 > 30) && ((buses['currentNumberOfPassenger']/buses['totalPassengerCapacity'])*100 <= 70) )
    {
        image = document.createElement("img");
        image.src = "https://i.ibb.co/j5zpXxN/Buslogo2.png";
        color = "orange";
    }     

    else
    {
        image = document.createElement("img");
        image.src = "https://i.ibb.co/BGV1zPw/Buslogo3.png";
        color = "red";
    }

    image.style.width = "60%";

    const marker = new AdvancedMarkerElement({
    map: map,
    position: { lat: buses['currentLatitude'], lng: buses['currentLongitude'] },
    content: image,
    });
}

