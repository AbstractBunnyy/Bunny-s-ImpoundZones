local QBCore = exports['qb-core']:GetCoreObject()


QBCore.Functions.CreateCallback('QBCore:HasVehicleOwner', function(source, cb, plate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        cb(true)
    else
        cb(false)
    end
end)