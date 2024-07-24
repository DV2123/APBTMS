function del(e)
{
    var elem = e.parentNode.parentNode.firstElementChild.innerHTML;

    url = `https://ap-south-1.aws.neurelo.com/rest/Notifications/${elem}`;

    var elem = e.parentNode.parentNode; 
    elem.style.display = "none";
}