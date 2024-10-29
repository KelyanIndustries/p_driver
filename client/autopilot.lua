local autopilot_activate = false

RegisterCommand('activate_autopilot', function()
    autopilot_activate = not autopilot_activate
    print(autopilot_activate)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    if autopilot_activate then
        if not IsPedInVehicle(ped, vehicle, false) then
            lib.notify({
                id = 'no_vehicle',
                title = 'Not in vehicle',
                description = 'You must be in a vehicle to activate the autopilot',
                showDuration = true,
                position = 'top',
                icon = 'ban',
                iconColor = '#C53030'
            })
            goto clear
        end
        if not IsWaypointActive() then
            lib.notify({
                id = 'no_waypoint',
                title = 'No waypoint set',
                description = 'Please set a waypoint on the map',
                showDuration = true,
                position = 'top',
                icon = 'ban',
                iconColor = '#C53030'
            })
            goto continue
        end
        lib.notify({
            id = 'activate_autopilot',
            title = 'Autopilot activated',
            description = 'The autopilot is now activated, you can now relax',
            showDuration = true,
            position = 'top',
            icon = 'check',
            iconColor = '#2ECC71'
        })
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehCoords = GetEntityCoords(vehicle)

        local speed = GetEntitySpeed(vehicle)
        speed = speed * 2.236936

        local waypoint = GetFirstBlipInfoId(8)
        local waypointCoords = GetBlipInfoIdCoord(waypoint)
        TaskVehicleDriveToCoordLongrange(ped, vehicle, waypointCoords.x, waypointCoords.y, waypointCoords.z, 70.0, 786475,
            20.0)

        -- Ralentir si il y a vehicule devant nous, et se caler à la même vitesse
        local vehFront = GetClosestVehicle(vehCoords.x, vehCoords.y, vehCoords.z, 10.0, 0, 70)
        if vehFront ~= 0 then
            local vehFrontCoords = GetEntityCoords(vehFront)
            local vehFrontSpeed = GetEntitySpeed(vehFront)
            vehFrontSpeed = vehFrontSpeed * 2.236936
        end
    else
        lib.notify({
            id = 'autopilot_deactivated',
            title = 'Autopilot deactivated',
            description = 'The autopilot is now deactivated',
            showDuration = true,
            position = 'top',
            icon = 'ban',
            iconColor = '#C53030'
        })
        goto continue
    end
    while true and autopilot_activate do
        Citizen.Wait(500)
        if not IsWaypointActive() then
            TaskVehicleTempAction(ped, vehicle, 27, 1000)
            local speed = GetEntitySpeed(vehicle)
            if speed < 2 then
                lib.notify({
                    id = 'arrived_at_destination',
                    title = 'Arrived at destination',
                    description = 'You have arrived at your destination',
                    showDuration = true,
                    position = 'top',
                    icon = 'check',
                    iconColor = '#2ECC71'
                })
                lib.notify({
                    id = 'autopilot_deactivated',
                    title = 'Autopilot deactivated',
                    description = 'The autopilot is now deactivated',
                    showDuration = true,
                    position = 'top',
                    icon = 'ban',
                    iconColor = '#C53030'
                })
                break
            end
        end
    end
    ::continue::
    ClearPedTasks(ped)
    ClearVehicleTasks(vehicle)
    ::clear::
    autopilot_activate = false
end, false)

RegisterKeyMapping('activate_autopilot', 'Activate Autopilot', 'keyboard', 'u')
