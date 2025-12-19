local Config = {
    AnimationDict = 'reaction@intimidation@cop@unarmed',
    AnimationName = 'intro',
    DrawDuration = 1200,
    Cooldown = 500
}

local lastWeapon = `WEAPON_UNARMED`
local lastPlayed = 0

local function ensureAnimDictLoaded(dict)
    if HasAnimDictLoaded(dict) then
        return true
    end

    RequestAnimDict(dict)
    local start = GetGameTimer()

    while not HasAnimDictLoaded(dict) do
        Wait(0)

        if (GetGameTimer() - start) > 5000 then
            print(('Weapon draw animation dictionary %s failed to load.'):format(dict))
            return false
        end
    end

    return true
end

CreateThread(function()
    while true do
        local player = PlayerPedId()

        if not DoesEntityExist(player) then
            Wait(500)
        else
            local weapon = GetSelectedPedWeapon(player)
            local now = GetGameTimer()

            if weapon ~= `WEAPON_UNARMED` and weapon ~= lastWeapon then
                if (now - lastPlayed) > Config.Cooldown and ensureAnimDictLoaded(Config.AnimationDict) then
                    TaskPlayAnim(
                        player,
                        Config.AnimationDict,
                        Config.AnimationName,
                        8.0,
                        1.0,
                        Config.DrawDuration,
                        48,
                        0.0,
                        false,
                        false,
                        false
                    )
                    lastPlayed = now
                end

                lastWeapon = weapon
            elseif weapon == `WEAPON_UNARMED` and lastWeapon ~= `WEAPON_UNARMED` then
                lastWeapon = weapon
            end

            Wait(100)
        end
    end
end)