ESX = nil
local food = 0
local thirst = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

RegisterNetEvent("esx_status:onTick")
AddEventHandler("esx_status:onTick", function(status)
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        food = status.val / 10000
    end)
	
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        thirst = status.val / 10000
    end)
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
		
        local IsInCar = false
		local speed = 0
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            IsInCar = true
			local pedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			speed = math.ceil(GetEntitySpeed(pedVehicle) * 3.6)
        end
		
        SendNUIMessage({
            armour = GetPedArmour(PlayerPedId()),
            health = GetEntityHealth(PlayerPedId()) - 100,
            food = food,
            thirst = thirst,
			InCar = IsInCar,
			speed = speed
        })
    end
end)