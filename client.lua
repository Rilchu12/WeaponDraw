local Config = {
    DefaultAnimation = {
        Dict = 'reaction@intimidation@cop@unarmed',
        Name = 'intro',
        Duration = 1200
    },
    Animations = {
        [416676503] = { -- GROUP_PISTOL
            Dict = 'reaction@intimidation@1h',
            Name = 'intro',
            Duration = 1200
        },
        [860033945] = { -- GROUP_SMG
            Dict = 'reaction@intimidation@1h',
            Name = 'intro',
            Duration = 1200
        },
        [970310034] = { -- GROUP_MG
            Dict = 'reaction@intimidation@1h',
            Name = 'intro',
            Duration = 1200
        },
        [1159398588] = { -- GROUP_RIFLE
            Dict = 'reaction@intimidation@1h',
            Name = 'intro',
            Duration = 1200
        },
        [-2066285827] = { -- GROUP_SHOTGUN
            Dict = 'reaction@intimidation@cop@unarmed',
            Name = 'intro',
            Duration = 1400
        },
        [-1569042529] = { -- GROUP_MELEE
            Dict = 'reaction@intimidation@cop@unarmed',
            Name = 'intro',
            Duration = 900
        },
        [1119849093] = { -- GROUP_STUNGUN
            Dict = 'reaction@intimidation@cop@unarmed',
            Name = 'intro',
            Duration = 1000
        },
        [3082541095] = { -- GROUP_SNIPER
            Dict = 'reaction@intimidation@cop@unarmed',
            Name = 'intro',
            Duration = 1600
        },
        [2725924767] = { -- GROUP_HEAVY
            Dict = 'missfam4',
            Name = 'base',
            Duration = 1500
        }
    },
    Cooldown = 500,
    RequireQBLogin = true
}

local lastWeapon = `WEAPON_UNARMED`
local lastPlayed = 0

local function getAnimationForWeapon(weapon)
    local animation = Config.DefaultAnimation
    local group = GetWeapontypeGroup(weapon)

    if group and Config.Animations[group] then
        animation = Config.Animations[group]
    end

    return animation
end

local function isPlayerReady()
    if not Config.RequireQBLogin then
        return true
    end

    if GetResourceState('qb-core') ~= 'started' then
        return true
    end

    local qbLocalPlayer = LocalPlayer

    if qbLocalPlayer and qbLocalPlayer.state and qbLocalPlayer.state.isLoggedIn == false then
        return false
    end

    return true
end

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

        if not DoesEntityExist(player) or not isPlayerReady() then
            Wait(500)
        else
            local weapon = GetSelectedPedWeapon(player)
            local now = GetGameTimer()

            if weapon ~= `WEAPON_UNARMED` and weapon ~= lastWeapon then
                local animation = getAnimationForWeapon(weapon)

                if (now - lastPlayed) > Config.Cooldown and ensureAnimDictLoaded(animation.Dict) then
                    TaskPlayAnim(
                        player,
                        animation.Dict,
                        animation.Name,
                        8.0,
                        1.0,
                        animation.Duration or Config.DefaultAnimation.Duration,
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
