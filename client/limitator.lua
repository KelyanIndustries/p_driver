local activate_limitator = false
RegisterCommand("activate_limitator", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local speed = 0.0
    activate_limitator = not activate_limitator
    if not IsPedInVehicle(ped, vehicle, false) then
        lib.notify({
            id = 'no_vehicle',
            title = 'Not in vehicle',
            description = 'You must be in a vehicle to activate the regulator',
            showDuration = true,
            position = 'top',
            icon = 'ban',
            iconColor = '#C53030'
        })
        goto clear
    end

    lib.notify({
        id = 'activate_limitator',
        title = 'limitator activated',
        description = 'The limitator is now activated, you can now relax',
        showDuration = true,
        position = 'top',
        icon = 'check',
        iconColor = '#2ECC71'
    })
    speed = GetEntitySpeed(vehicle)
    while activate_limitator do
        Wait(0)
        SetEntityMaxSpeed(vehicle, speed)

        if IsControlPressed(0, 72) then
            SetEntityMaxSpeed(vehicle, 999.9)
            activate_limitator = false
            lib.notify({
                id = 'deactivate_limitator',
                title = 'limitator deactivated',
                description = 'The limitator is now deactivated',
                showDuration = true,
                position = 'top',
                icon = 'check',
                iconColor = '#2ECC71'
            })
            goto clear
        end
    end
    SetEntityMaxSpeed(vehicle, 999.9)

    ::clear::
end, false)

RegisterKeyMapping('activate_limitator', 'Activate the limitator', 'keyboard', 'k')
