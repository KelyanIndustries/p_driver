local activate_regulator = false
RegisterCommand("activate_regulator", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local speed = 0.0
    activate_regulator = not activate_regulator
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
        id = 'activate_regulator',
        title = 'Regulator activated',
        description = 'The regulator is now activated, you can now relax',
        showDuration = true,
        position = 'top',
        icon = 'check',
        iconColor = '#2ECC71'
    })
    speed = GetEntitySpeed(vehicle)
    while activate_regulator do
        Wait(0)

        SetVehicleForwardSpeed(vehicle, speed)

        if IsControlPressed(0, 72) then
            SetEntityMaxSpeed(vehicle, 999.9)
            activate_regulator = false
            lib.notify({
                id = 'deactivate_regulator',
                title = 'Regulator deactivated',
                description = 'The regulator is now deactivated',
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

RegisterKeyMapping('activate_regulator', 'Activate the regulator', 'keyboard', 'k')
