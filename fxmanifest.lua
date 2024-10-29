fx_version "cerulean"
game "gta5"

author "Porka"
description "A Driver Set for FiveM"
version "v1.0"

lua54 "yes"

client_scripts {
  "client/autopilot.lua",
  "client/limitator.lua",
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
}

shared_scripts {
  "@ox_lib/init.lua"
}
