local apps = require("configuration.apps")
local filesystem = require("gears.filesystem")

-- List of apps to start once on start-up
return {
  run_on_start_up = {

    "picom --config " .. filesystem.get_configuration_dir() .. "configuration/picom.conf",
    "numlockx on",                                                                                                                      -- enable numlock
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1  & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)", -- credential manager

    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    "/bin/bash -c "
    .. filesystem.get_configuration_dir()
    .. "scripts/autostartonce.sh", -- Spawn "dirty" apps that can linger between sessions
    "/bin/bash -c "
    .. filesystem.get_configuration_dir()
    .. "scripts/autolock.sh",
  },
}
