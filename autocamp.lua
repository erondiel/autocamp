local mq = require('mq')

local function gate(method)
  local classShortName = mq.TLO.Me.Class.ShortName()
  local classSpecificMethod = {
      BRD = '/casting 511|alt', -- Throne of Heroes
      BST = '/casting 511|alt',
      BER = '/casting 511|alt',
      MNK = '/casting 511|alt',
      PAL = '/casting 511|alt',
      RNG = '/casting 511|alt',
      ROG = '/casting 511|alt',
      SHD = '/casting 511|alt',
      WAR = '/casting 511|alt',
      CLR = '/casting gate 8', -- Gate Spell
      DRU = '/casting gate 8',
      ENC = '/casting gate 8',
      MAG = '/casting gate 8',
      NEC = '/casting gate 8',
      SHM = '/casting gate 8',
      WIZ = '/casting gate 8'
  }

  -- Pause class-specific plugin if necessary
  if classSpecificMethod[classShortName] then
      pauseClassPlugin()
  end

  -- Execute the gate method
  if method == 'AAgate' then
      mq.cmd('/casting 1217|alt')
  elseif method == 'Primary' then
      mq.cmd('/casting 57851|item')
  elseif method == 'Secondary' then
      mq.cmd('/casting 57852|item')
  else
      mq.cmd(classSpecificMethod[classShortName] or '/casting gate 8') -- Default to Gate Spell if class not found
  end
end

function pauseClassPlugin()
  local classShortName = mq.TLO.Me.Class.ShortName()

  local pauseCommands = {
      DRU = '/dru pause on',
      ENC = '/enc pause on',
      NEC = '/nec pause on',
      MAG = '/mag pause on',
      ROG = '/rog pause on',
      PAL = '/pal pause on',
      CLR = '/clr pause on',
      MNK = '/mnk pause on',
      WAR = '/war pause on',
      
      
  }

  local pauseCommand = pauseCommands[classShortName]
  if pauseCommand then
      mq.cmd(pauseCommand)
      print('Pausing plugin for camping: ' .. classShortName)
  end
end

local function setClassMode()
  local classShortName = mq.TLO.Me.Class.ShortName()
  local classModeCommands = {
      PAL = '/pal mode 4',  -- Setting Paladin to Tank mode
      WAR = '/war mode 4',  -- Setting Warrior to Tank mode
      MNK = '/mnk mode 1',  -- Setting Monk to assist mode
  }

  local modeCommand = classModeCommands[classShortName]
  if modeCommand then
      mq.cmd(modeCommand)
      print("Setting " .. classShortName .. " to specific mode.")
  end
end
function CampToDesktop()
  pauseClassPlugin()
  mq.cmd('/end')
  mq.cmd('casting 57851|item')
  mq.cmd('/camp desktop')
  print('Camping')
end

function StartCampTimer(seconds, gateMethod)
    local startTime = os.time()
    local endTime = startTime + seconds
    local lastPrintTime = 0
    local setModeTriggered = false
    local gateTriggered = false -- To ensure gate function is called only once

    while os.time() < endTime do
        local currentTime = os.time()
        local timeLeft = endTime - currentTime

        -- Check if there are exactly 5 minutes left and setClassMode has not been triggered
        if timeLeft == 300 and not setModeTriggered then
            setClassMode() -- Set the class mode
            setModeTriggered = true -- Prevent multiple calls
            print("Class mode set for the final 5 minutes.")
        end
        
        -- Check for 2 minutes remaining to execute gate
        if timeLeft == 120 and not gateTriggered then
            gate(gateMethod)
            gateTriggered = true
            print("Executing gate method.")
        end

        -- Determine the print interval
        local printInterval = 10  -- Default to 10 seconds
        if timeLeft > 60 then
            printInterval = 600  -- Change to 10 minutes if more than 1 minute left
        end

        if currentTime - lastPrintTime >= printInterval then
            local message = ""
            if timeLeft >= 3600 then
                -- More than 1 hour remaining
                local timeLeftHours = math.floor(timeLeft / 3600)
                local timeLeftMinutes = math.floor((timeLeft % 3600) / 60)
                message = string.format("%02d:%02d hours remaining to camp to desktop", timeLeftHours, timeLeftMinutes)
            elseif timeLeft >= 60 then
                -- Less than 1 hour but more than 1 minute remaining
                local timeLeftMinutes = math.floor(timeLeft / 60)
                message = string.format("%d minutes remaining to camp to desktop", timeLeftMinutes)
            else
                -- Less than 1 minute remaining
                message = string.format("%d seconds remaining to camp to desktop", timeLeft)
            end

            print(message)
            lastPrintTime = currentTime  -- Update the last printed time
        end

        mq.delay(100) -- Short delay to prevent script from hogging CPU resources
    end

    CampToDesktop()
end

-- Function to convert various time formats to seconds
function parseTimeArgument(arg)
    local hours, minutes, seconds
    -- Match HH:MM format
    hours, minutes = arg:match("^(%d+):(%d+)$")
    if hours and minutes then
        return (tonumber(hours) * 3600) + (tonumber(minutes) * 60)
    end

    -- Match single number followed by 'h' or 'm' or default to seconds
    hours = arg:match("^(%d+)%s*h$")
    minutes = arg:match("^(%d+)%s*m$")
    seconds = arg:match("^(%d+)%s*s$")

    if hours then return tonumber(hours) * 3600 end
    if minutes then return tonumber(minutes) * 60 end
    if seconds then return tonumber(seconds) end

    -- Default to raw seconds if no unit is given
    return tonumber(arg)
end

local args = {...} -- This captures any arguments passed to the script
local timerDurationInSeconds = parseTimeArgument(args[1])
local gateMethod = args[2] or "class-specific" -- Default to class-specific if no gate method argument is provided

-- Check if the timer duration is at least 10 minutes (600 seconds)
if timerDurationInSeconds and timerDurationInSeconds >= 600 then
    print("Starting autocamp with a delay of " .. timerDurationInSeconds .. " seconds.")
    print("Gate method selected: " .. gateMethod)
    StartCampTimer(timerDurationInSeconds, gateMethod)
else
    print("Error: Timer duration must be at least 10 minutes.")
end
