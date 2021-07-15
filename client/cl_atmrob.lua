ESX = nil
PlayerData = {}
local atm = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('nb_atmrob:client:getatm')
AddEventHandler('nb_atmrob:client:getatm', function(atm)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if atm then 
        atm = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
        if Config.UseProgressBar then 
            exports['progressBars']:startUI(10000, "Hackování")
        end
        Citizen.Wait(10000)
        ClearPedTasks(playerPed)
        startmihra(atm)
        if Config.CallPDonStart then
            TriggerServerEvent('esx_phone:send', "police", _U('robbery'), true, coords)    
        end
    end
end)

RegisterNetEvent('nb_atmrob:client:ATMCheck')
AddEventHandler('nb_atmrob:client:ATMCheck', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for k, v in pairs(Config.Models) do
        local model = GetHashKey(v)
        entity = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.5, model, false, false, false)

        if entity ~= 0 then
            atmFound = true
            break
        else
            atmFound = false
        end
    end
    TriggerEvent('nb_atmrob:client:getatm', atmFound)
end)
