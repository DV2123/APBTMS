var availableBuses = [];

function hello(e)
{
    var uid = e.parentNode.parentNode.firstElementChild.innerHTML; 

    for(var i=0;i<availableBuses.length;i++)
    {
        if(uid == availableBuses[i]["busUID"])
        {
            document.getElementById("busUID").value = availableBuses[i]["busUID"];
            document.getElementById("noPlate").value = availableBuses[i]["driverName"];
            document.getElementById("pass").value = availableBuses[i]["driverMN"];
            document.getElementById("capacity").value = availableBuses[i]["driverLN"];   
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

function view(e)
{
    var uid = (e.parentNode.parentNode.firstElementChild.innerHTML);
    getDriverPhoto(uid);
}

async function getDriverPhoto(bUID)
{
    document.getElementById("driverPic").style.visibility = "hidden";
    var url = "https://3cuv2rjor4.execute-api.ap-south-1.amazonaws.com/prod/getDriverPhoto?busUID=" + bUID
    var x = await fetch(url, {
        method: 'POST'
    })
    .then(response => response.arrayBuffer())
    .then(buffer => {
        const uint8Array = new Uint8Array(buffer);
        let x = uint8ArrayToJpg(uint8Array);

        document.getElementById("driverPic").style.visibility = "visible";
        document.getElementById("driverPic").src = x;
        document.getElementById("driverPic").alt = bUID;
    })

}

function uint8ArrayToJpg(uint8Array)
{
  const blob = new Blob([uint8Array], { type: 'image/jpeg' });
  const url = URL.createObjectURL(blob);
  return url;
}

let base64String = "";

function submitPic(btn)
{
    let file = document.getElementById("inputPic")['files'][0];
    let reader = new FileReader();

    reader.onload = function () {
        base64String = reader.result.replace("data:", "")
            .replace(/^.+,/, "");

        imageBase64Stringsep = base64String;

        // alert(imageBase64Stringsep);
        sendPhoto(document.getElementById("driverPic").alt, base64String);
        // console.log(base64String);
    }
    reader.readAsDataURL(file);  
}

function sendPhoto(bID, DATA)
{

    url = "https://3cuv2rjor4.execute-api.ap-south-1.amazonaws.com/prod/uploadDriverPhoto?busUID=" + bID;
    
    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'text/plain'},
        body: DATA
    };

    fetch(url, requestOptions);
}