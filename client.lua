local ESX = nil
local stage = 1
local micmuted = false
local voice = {default = 8.0, shout = 15.0, whisper = 3.5, current = 1} 
local Keys = {

    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,

    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,

    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,

    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,

    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,

    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,

    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,

    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,

    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118

}
local voicelevel = 0
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    Wait(3000)
    SendNUIMessage({action = "setVoiceLevel", level = 2});
    ESX.TriggerServerCallback('void:getMoney', function(money)
        SendNUIMessage({action = "setMoney", money = money})
        currentmoney = money
      end)
  end)
  

RegisterNetEvent("adminon")
AddEventHandler('adminon', function()
    SendNUIMessage({action = "adminon"})
end)

RegisterNetEvent("void:togglehud")
AddEventHandler('void:togglehud', function(state)
    if state ~= 'nil' then
      if hiddenhud then
        hiddenhud = false
        SendNUIMessage({action = "showhud"})
        TriggerEvent('notifications', "green", "", "Du siehst nun dein HUD wieder.")
        DisplayRadar(true)
        ESX.TriggerServerCallback('void:getMoney', function(money)
            SendNUIMessage({action = "setMoney", money = money})
            currentmoney = money
          end)
      else
        SendNUIMessage({action = "hidehud"})
        hiddenhud = true
        DisplayRadar(false)
        TriggerEvent('notifications', "green", "", "Du siehst nun dein HUD nicht mehr.")
      end
    else
      if state == 0 then
        SendNUIMessage({action = "hidehud"})
        hiddenhud = true
      else
        SendNUIMessage({action = "showhud"})
        hiddenhud = false
        ESX.TriggerServerCallback('void:getMoney', function(money)
            SendNUIMessage({action = "setMoney", money = money})
            currentmoney = money
          end)
      end
    end
end)

RegisterNetEvent("adminoff")
AddEventHandler('adminoff', function()
    SendNUIMessage({action = "adminoff"})
end)

AddEventHandler("onClientMapStart", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	NetworkSetTalkerProximity(voice.default)
	SendNUIMessage({action = "setVoiceLevel", level = 2});
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)	
	if account.name == "money" then
      if account.money > currentmoney then
        money = account.money - currentmoney
          SendNUIMessage({action = "addMoney", addMoney = money})
      elseif account.money < currentmoney then
        money = currentmoney - account.money
        SendNUIMessage({action = "removeMoney", removeMoney = money})
      end
    currentmoney = account.money
	SendNUIMessage({action = "setMoney", money = account.money})
    Wait(2000)
    SendNUIMessage({action = "hideSetMoney"})
	end
	
	if account.name == "black_money" then
		if account.money > 0 then
			SendNUIMessage({action = "setBlackMoney", black = account.money})
		else
			SendNUIMessage({action = "hideBlackMoney"})
	    end
	end
end)


RegisterNetEvent('SaltyChat_RadioTrafficStateChanged')
AddEventHandler('SaltyChat_RadioTrafficStateChanged', function(SaltyprimaryTransmit)
    local stage = exports.saltychat:GetRadioSpeaker(true)
    if stage then
      print(stage)
    else
      print(stage .. " NOT TALKING")
    end
  end)



RegisterNetEvent('SaltyChat_MicStateChanged')
AddEventHandler('SaltyChat_MicStateChanged', function(SaltyisMicrophoneMuted)

    if SaltyisMicrophoneMuted == true then

      if voice.current == 0 then
        SendNUIMessage({action = "setVoiceLevel", level = 2});
      elseif voice.current == 1 then
        SendNUIMessage({action = "setVoiceLevel", level = 3});
      elseif voice.current == 2 then
        SendNUIMessage({action = "setVoiceLevel", level = 1});
      end
      SendNUIMessage({action = "muted", muted = true})
      micmuted = true

    else
      if voice.current == 0 then
        SendNUIMessage({action = "setVoiceLevel", level = 2});
      elseif voice.current == 1 then
        SendNUIMessage({action = "setVoiceLevel", level = 3});
      elseif voice.current == 2 then
        SendNUIMessage({action = "setVoiceLevel", level = 1});
      end
      SendNUIMessage({action = "nomuted"})
      micmuted = false
    end

  end)

local prox = 26.0
local allowProximityChange = true


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local data = exports.saltychat:GetRadioChannel(true)

if  data == nil or data == '' then
	SendNUIMessage({action = "hide"})

else
	SendNUIMessage({action = "show"})

end

	  end
  end)

local voiceRangeTimer = 0
local voiceRange_ = 0

RegisterNetEvent("SaltyChat_VoiceRangeChanged")
AddEventHandler("SaltyChat_VoiceRangeChanged", function(voiceRange)
    voiceRange_ = voiceRange
    voice.current = (voice.current + 1) % 3
    if voice.current == 0 then
      NetworkSetTalkerProximity(voice.default)
      SendNUIMessage({action = "setVoiceLevel", level = 3});
      print("DEBUG - VoiceRange: " .. voice.current)
      voiceCoords = voice.default
    elseif voice.current == 1 then
      NetworkSetTalkerProximity(voice.shout)
      SendNUIMessage({action = "setVoiceLevel", level = 1});
      voiceCoords = voice.shout
      print("DEBUG - VoiceRange: " .. voice.current)
    elseif voice.current == 2 then
      NetworkSetTalkerProximity(voice.whisper)
      SendNUIMessage({action = "setVoiceLevel", level = 2});
      voiceCoords = voice.whisper
      print("DEBUG - VoiceRange: " .. voice.current)
    end
    if voiceRangeTimer == 0 then
        showVoiceRangeOnGround()
    else
        voiceRangeTimer = GetGameTimer()
    end
end)

function showVoiceRangeOnGround() 
    voiceRangeTimer = GetGameTimer()
    while true do
        Citizen.Wait(0)
        if GetGameTimer() - voiceRangeTimer > 3000 then
            voiceRangeTimer = 0
            return
        end
        local coords = GetEntityCoords(PlayerPedId())
        DrawMarker(1, coords.x, coords.y, coords.z - 1, 0, 0, 0, 0, 0, 0, voiceRange_ * 2, voiceRange_ * 2, 0.75, 255,157,9, 255, 0, 0, 2, 0, 0, 0, 0)
    end
end

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsControlJustPressed(0, 170) then
        TriggerEvent('void:togglehud')
        Wait(100)
      end
    end
  end)