Config = {}

Config.Zones = { -- it will use the timers in the Zones.
    { 
        name = "Zone1", -- use the polyzone creater tool to get precise zones. Check their doc.
        center = vector3(303.72, -1078.71, 29.35), 
        length = 15.2, 
        width = 19.4, 
        heading = 355.0, 
        warningTime = 3, -- in seconds
        debug = false,
        minz = 27.5,
        maxz = 31.5,
        cost = 300 -- minimum $1 or else the cars dont always go to depot.
    },
    { 
        name = "Zone2", 
        center = vector3(10.0, 10.0, 10.0), 
        length = 10.0, 
        width = 10.0, 
        heading = 10.0, 
        warningTime = 0, 
        debug = false,
        minz = 27.5,
        maxz = 31.5,
        cost = 200
    }
}


Config.ExemptVehicles = {
    "vsgran",
    "police"
}

Config.DefaultWarningTime = 5 -- Time in seconds before the car gets impounded / it will use the zone timers over this.


