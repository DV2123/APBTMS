function view(e)
{
    var uid = (e.parentNode.parentNode.firstElementChild.innerHTML);
    getDriverPhoto(uid);
}

async function getDriverPhoto(bUID)
{
    document.getElementById("driverPic").style.visibility = "hidden";
    var url = "https://3cuv2rjor4.execute-api.ap-south-1.amazonaws.com/prod/getBusInsideImage?busUID=" + bUID
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