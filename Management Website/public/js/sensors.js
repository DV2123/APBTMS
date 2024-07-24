var a = document.getElementsByClassName("flame");

for(var i=0;i<a.length;i++)
{
    if(a[i].innerHTML<10)
    {
        a[i].innerHTML = `<i class="fa-solid fa-triangle-exclamation" style="color: #ff0000;"></i> &nbsp;` + a[i].innerHTML;
        a[i].style.color = "red";
        a[i].style.fontWeight = "800";
    }
    
}

a = document.getElementsByClassName("temp");

for(var i=0;i<a.length;i++)
{
    if(a[i].innerHTML>65)
    {
        a[i].innerHTML = `<i class="fa-solid fa-triangle-exclamation" style="color: #ff0000;"></i> &nbsp;` + a[i].innerHTML;
        a[i].style.color = "red";
        a[i].style.fontWeight = "800";
    }
    
}

var a = document.getElementsByClassName("sound");

for(var i=0;i<a.length;i++)
{
    if(a[i].innerHTML>80)
    {
        a[i].innerHTML = `<i class="fa-solid fa-triangle-exclamation" style="color: #ff0000;"></i> &nbsp;` + a[i].innerHTML;
        a[i].style.color = "red";
        a[i].style.fontWeight = "800";
    }
    
}
