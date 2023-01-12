ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback('void:getMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cb(xPlayer.getMoney())
end)