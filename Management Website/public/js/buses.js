var availableBuses = [];

function hello(e)
{
    var uid = e.parentNode.parentNode.firstElementChild.innerHTML; 

    for(var i=0;i<availableBuses.length;i++)
    {
        if(uid == availableBuses[i]["busUID"])
        {
            document.getElementById("busUID").value = availableBuses[i]["busUID"];
            document.getElementById("noPlate").value = availableBuses[i]["busNumberPlate"];
            document.getElementById("pass").value = availableBuses[i]["currentNumberOfPassenger"];
            document.getElementById("capacity").value = availableBuses[i]["totalPassengerCapacity"];
            document.getElementById("source").value = availableBuses[i]["busRouteStart"];
            document.getElementById("dest").value = availableBuses[i]["busRouteEnd"];    
            break;
        }
    }
}

fetch('/buses/list')
    .then(response => response.json())
    .then(data => {
        for(var i=0; i<data.length;i++)
        {
            availableBuses.push(data[i]);
        }
    })
    .catch(error => {
        console.error('Error fetching value:', error);
    });


