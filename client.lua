local QBCore = exports['qb-core']:GetCoreObject()
local currentZone = nil
local currentWarningTime = Config.DefaultWarningTime * 1000 -- Default warning time in milliseconds

CreateThread(function()
    for _, zone in pairs(Config.Zones) do
        local polyZone = BoxZone:Create(zone.center, zone.length, zone.width, {
            name = zone.name,
            heading = zone.heading,
            debugPoly = zone.debug,
            minZ = zone.minz,
            maxZ = zone.maxz,
        })

        polyZone:onPlayerInOut(function(isPointInside)
            local playerPed = PlayerPedId()
            if isPointInside then
                if not currentZone then
                    if IsPedInAnyVehicle(playerPed, false) then
                        currentZone = zone
                        currentWarningTime = (zone.warningTime or Config.DefaultWarningTime) * 1000
                        StartWarning()
                    end
                end
            else
                if currentZone and currentZone.name == zone.name then
                    if IsPedInAnyVehicle(playerPed, false) then
                        StopWarning(false)
                    else
                        StopWarning(true)
                    end
                end
            end
        end)
    end
end)

function StartWarning()
    QBCore.Functions.Notify("Warning: Leave the area or your vehicle will be impounded!", "error", currentWarningTime)
    print("StartWarning: Timer started for " .. currentWarningTime .. " milliseconds.")

    -- Start a new thread for the timer
    CreateThread(function()
        local startTime = GetGameTimer()
        while currentZone and (GetGameTimer() - startTime < currentWarningTime) do
            Wait(500)
        end
        
        local elapsedTime = GetGameTimer() - startTime
        print("StartWarning: Timer waited for " .. elapsedTime .. " milliseconds.")
        
        if currentZone and (elapsedTime >= currentWarningTime) then
            print("StartWarning: Timer elapsed, checking vehicle state.")
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                ImpoundVehicle()
            else
                print("StartWarning: Player not in vehicle, impounding skipped.")
            end
        else
            print("StartWarning: Timer canceled or conditions not met.")
            print("Elapsed Time: " .. elapsedTime)
            print("Current Warning Time: " .. currentWarningTime)
        end
    end)
end

function StopWarning(fromImpound)
    if not fromImpound then
        QBCore.Functions.Notify("You have left the restricted area.", "success")
    end
    currentZone = nil
    print("StopWarning: Warning deactivated.")
end

function ImpoundVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        local plate = QBCore.Functions.GetPlate(vehicle)
        local bodyHealth = GetVehicleBodyHealth(vehicle)
        local engineHealth = GetVehicleEngineHealth(vehicle)
        local fuelLevel = GetVehicleFuelLevel(vehicle)
        local cost = currentZone.cost or 0

        QBCore.Functions.TriggerCallback('QBCore:HasVehicleOwner', function(isOwned)
            if isOwned then
               -- QBCore.Functions.Notify("Your vehicle has been impounded and taken to the depot!", "error")
                TriggerServerEvent('police:server:Impound', plate, false, cost, bodyHealth, engineHealth, fuelLevel)
            else
                QBCore.Functions.Notify("The vehicle has been seized!", "error")
                TriggerServerEvent('police:server:Impound', plate, true, 0, bodyHealth, engineHealth, fuelLevel)
            end
            print("ImpoundVehicle: Vehicle processed with plate " .. plate)
            Wait(1000) -- Wait for the server to process the impound
            DeleteEntity(vehicle)
        end, plate)
    else
        print("ImpoundVehicle: No vehicle found to impound.")
    end
    StopWarning(true)
end
