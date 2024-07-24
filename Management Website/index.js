import axios from "axios";
import express from "express";
import { dirname } from "path";
import { fileURLToPath } from "url";
import bodyParser from "body-parser";

const __dirname = dirname(fileURLToPath(import.meta.url));

const app = express();
const port = 3000;

app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: true}));

var arr;

app.get("/Home", async (req, res) => 
{
    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        arr = data;
        
        res.render(__dirname + "/home.ejs", {data, data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }
});

app.get("/Bus", async (req, res) => {

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        arr = data;
        
        res.render(__dirname + "/buses.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }
});

app.get("/Drivers", async (req, res) => {

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        
        res.render(__dirname + "/drivers.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }
});

app.get("/UserNotification", async (req, res) => {

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Notifications", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        
        res.render(__dirname + "/userNotification.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }
});

app.get("/AdminNotification", async (req, res) => {

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/ManagementNotifications", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        
        res.render(__dirname + "/adminNotification.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }
});

app.get("/SensorsData", async (req, res) => {

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        
        res.render(__dirname + "/sensors.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }
});

app.get("/buses/list", async (req, res) => 
{
    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        arr = data;
        
        res.send(arr);
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }

    
});

app.post("/sendNoti", async (req, res) => 
{

    var body = req.body;
    var not = [];

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Notifications", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];

        for(var i =0; i<data.length; i++)
        {
            var temp = data[i]["notifUID"];
            not.push(temp.slice(1));
        }

        var id = 0;

        while(true)
        {
            if(id in not)
            {
                id = id+1;
                continue;
            }

            else
            {
                id = id + 1;
                break;
            }

        }

        body["notifUID"] =  "n"+String(id);

        fetch("https://ap-south-1.aws.neurelo.com/rest/Notifications/__one", {
            method: "POST",
            headers: {
                "X-API-KEY": "NERRELO-API-KEY-HERE",
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body)
        })
        .then(async response => {
            if (!response.ok) {
                console.error("HTTP error:", response.status);
            }
        });

        res.render(__dirname + "/userNotification.ejs",{Arr: data});
        
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }

});


app.post("/submitpic", async (req, res) => {
    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        
        res.render(__dirname + "/drivers.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }

    
});

app.post("/submit", (req, res) => {

    var body = req.body;

    for(var i=0;i<arr.length;i++)
    {
        if(body["busUID"] == arr[i]["busUID"])
        {
            body["driverLN"] = arr[i]["driverLN"];
            body["driverMN"] = arr[i]["driverMN"];
            body["driverName"] = arr[i]["driverName"];
            body["temporaryNotification"] = arr[i]["temporaryNotification"];
        }
    }
    body["totalPassengerCapacity"] = Number(body["totalPassengerCapacity"]);

    body = Object.keys(body).filter(objKey =>
        objKey !== 'currentNumberOfPassenger').reduce((newObj, key) =>
        {
            newObj[key] = body[key];
            return newObj;
        }, {}
    );

    fetch("https://ap-south-1.aws.neurelo.com/custom/update-bus-info", {
        method: "POST",
        headers: {
            "X-API-KEY": "NERRELO-API-KEY-HERE",
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(body)
    })
    .then(async response => {
        if (!response.ok) {
            console.error("HTTP error:", response.status);
            return response.text().then(text => {
                throw new Error(text);
            });
        }
        return response.json();
    })
    .then(async data => {
        console.log('Success:', data);
        try
        {
            const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
            const dat = (response.data)["data"];
            arr = dat;
            
            res.render(__dirname + "/buses.ejs",{Arr: dat});
        }
        catch(error)
        {
            console.log("Error occured.",error.message);
        }
    })
    .catch(error => {
        // Handle errors
        console.error("Error:", error.message);

    });
});


app.post("/delNoti", async (req,res) =>
{
    var body = req.body;
    console.log("body");

    fetch(`https://ap-south-1.aws.neurelo.com/rest/Notifications/${body["id"]}`, {
        method: "DELETE",
        headers: {
            "X-API-KEY": "NERRELO-API-KEY-HERE",
        },
    })
    .then(async response => {
        if (!response.ok) {
            console.error("HTTP error:", response.status);
        }

    })

    try
    {
        const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Notifications", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
        const data = (response.data)["data"];
        
        res.render(__dirname + "/userNotification.ejs",{Arr: data});
    }
    catch(error)
    {
        console.log("Error occured.",error.message);
    }


});

app.post("/submitdriver", (req, res) => {

    var body = req.body;

    for(var i=0;i<arr.length;i++)
    {
        if(body["busUID"] == arr[i]["busUID"])
        {
            body["busNumberPlate"] = arr[i]["busNumberPlate"];
            body["busRouteEnd"] = arr[i]["busRouteEnd"];
            body["busRouteStart"] = arr[i]["busRouteStart"];
            body["totalPassengerCapacity"] = arr[i]["totalPassengerCapacity"];
            body["temporaryNotification"] = arr[i]["temporaryNotification"];
        }
    }

    body["totalPassengerCapacity"] = Number(body["totalPassengerCapacity"]);

    body = Object.keys(body).filter(objKey =>
        objKey !== 'currentNumberOfPassenger').reduce((newObj, key) =>
        {
            newObj[key] = body[key];
            return newObj;
        }, {}
    );

    fetch("https://ap-south-1.aws.neurelo.com/custom/update-bus-info", {
        method: "POST",
        headers: {
            "X-API-KEY": "NERRELO-API-KEY-HERE",
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(body)
    })
    .then(async response => {
        if (!response.ok) {
            console.error("HTTP error:", response.status);
            return response.text().then(text => {
                throw new Error(text);
            });
        }
        return response.json();
    })
    .then(async data => {
        console.log('Success:', data);
        try
        {
            const response = await axios.get("https://ap-south-1.aws.neurelo.com/rest/Buses", {headers: {"X-API-KEY": "NERRELO-API-KEY-HERE"}});
            const dat = (response.data)["data"];
            arr = dat;
            
            res.render(__dirname + "/drivers.ejs",{Arr: dat});
        }
        catch(error)
        {
            console.log("Error occured.",error.message);
        }
    })
    .catch(error => {
        // Handle errors
        console.error("Error:", error.message);

    });
});

app.listen(port, () => {
    console.log(`Server running on ${port}`);
});