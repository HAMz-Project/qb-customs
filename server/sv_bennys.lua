RegisterNetEvent('qb-customs:attemptPurchase', function(type, upgradeLevel, vehiclePrice)
    local source = source
    local Player = ESX.GetPlayerFromId(source)
    local balance = Player.getMoney()
    
    if type == "repair" then
        local toolkit  = Player.getInventoryItem('toolkit')
        if toolkit.count > 0 then
            Player.removeInventoryItem('toolkit', 1)
            TriggerClientEvent('qb-customs:repairSuccessful', source)
        else
            TriggerClientEvent('qb-customs:repairFailed', source)
        end
    elseif type == "performance" then
        local price = math.floor((vehicleCustomisationPrices[type].prices[upgradeLevel] * vehiclePrice) / 100)
        if balance >= price then
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
            Player.removeMoney(price)
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    else
        local price = math.floor((vehicleCustomisationPrices[type].price * vehiclePrice) / 100)
        if balance >= price then
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
            Player.removeMoney(price)
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    return retval
end