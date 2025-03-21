label = os.computerLabel()
print(label .. " online")

-- Get settings
local LauncherCoordinates = settings.get("LauncherCoordinates")
local LOW_FUEL_THRESHOLD = settings.get("LOW_FUEL_THRESHOLD")
local HIGH_FUEL_THRESHOLD = settings.get("HIGH_FUEL_THRESHOLD")
local HARVEST_ROW_LENGTH = settings.get("HARVEST_ROW_LENGTH")
local HARVEST_MAX_AGE = settings.get("HARVEST_MAX_AGE")
local HARVEST_MODE = settings.get("HARVEST_MODE")
local MAX_FUEL = settings.get("MAX_FUEL")
local HARVEST_CROP = settings.get("HARVEST_CROP")


-- Turtle Self-tracking System created by Latias1290.
local xPos, yPos, zPos = nil
face = 1
cal = false
state = "Seeking launchpad"



function consider()
	if(HARVEST_MODE == "bottom") then
		local has_block, originalBlockData = turtle.inspectDown()
		if has_block and originalBlockData.state.age ~= nil then
			if originalBlockData.state.age >= HARVEST_MAX_AGE then
				-- Harvest
				turtle.digDown()
			end
		else
			turtle.digDown()
		end
		
		turtle.placeDown()
	else
		-- Front
		turtle.dig()
	end
	
	turtle.forward()
	
	if HARVEST_CROP ~= nil and HARVEST_CROP ~= "" then
		if turtle.getItemDetail() ~= nil then
			if turtle.getItemDetail(i).name ~= HARVEST_CROP then
				-- Wrong thing selected
				SelectItem(HARVEST_CROP)
			end
		else
			-- Nothig selected
			SelectItem(HARVEST_CROP)
		end
	end
end


--Locate an item by the minespace
function SelectItem(itemName)
    for i = 1, 16, 1 do
        if (turtle.getItemDetail(i) ~= nil ) then
			if(itemName == turtle.getItemDetail(i).name) then
				turtle.select(i)
				return true
			end
        end
    end

    return false
end


function harvestRow() 
	local i = 0
	while i < HARVEST_ROW_LENGTH do
		i = i + 1
		consider()
	end
end

function turnAroundRight()
	turtle.turnRight()
	consider()
	turtle.turnRight()
end

function turnAroundLeft()
	turtle.turnLeft()
	consider()
	turtle.turnLeft()
end

function cross()
	turtle.turnLeft()
	consider()
	turtle.forward()
	turtle.turnLeft()
end


function dock() 
	consider()
	turtle.turnRight()
	dropInventory()
end

function bringHome(steps)
	turtle.turnRight()
	gotoLaunchPad()
end

function dropInventory()
	local monitor = peripheral.find("monitor") or nil
	if(monitor) then
		monitor.setTextScale(0.5)
		monitor.clear()
		monitor.setCursorPos(1,1)
		term.redirect(monitor)
		monitor.setTextColor(colors.lime)
	end
	print(label .. " docked \n")
	term.setTextColor(colors.green)

	print("Unloading... \n")
	local container = peripheral.wrap("bottom")
	if container == nil then
		print(label .. " Alert: Drop chest not found.")
		--TurtleGPS.ReturnToPreviousPosition(previousData)
		return
	end

	for i = 1, 16, 1 do
		if turtle.getItemCount(i) > 0 then
			turtle.select(i)
		end
		turtle.dropDown()
	end

	term.setTextColor(colors.lime)
	print(label)
	print("Fully unloaded")

	term.redirect(term.native())
	monitor = nil
end

function printFuel()
	local f = math.floor(turtle.getFuelLevel() / 1000)
	if(turtle.getFuelLevel() <= HIGH_FUEL_THRESHOLD) then
		term.setTextColor(colors.orange)
	else
		term.setTextColor(colors.green)
	end
	
	print("Fuel: " .. f .. "/" .. MAX_FUEL / 1000)
	term.setTextColor(colors.green)
end


function IsLowOnFuel()
	local fuelLevel = math.floor(turtle.getFuelLevel())
	local monitor = peripheral.find("monitor") or print("No monitor attached")
	
	if(monitor) then
		monitor.setTextScale(0.5)
		monitor.clear()
		monitor.setCursorPos(1,1)
		term.redirect(monitor)
	
		monitor.setTextColor(colors.lime)
	end
	print(label .. " docked \n")
	
	
	if fuelLevel < LOW_FUEL_THRESHOLD then
		printFuel()
		print(label .. " fueling...")
        TryRefillIfLow = false
        --local previousData = TurtleGPS.ReturnToOrigin(true)

		local container = peripheral.wrap("top")
        if container == nil then
			print("ALERT: " .. label .. " fuel chest not found.")
            TryRefillIfLow = true
            --TurtleGPS.ReturnToPreviousPosition(previousData)
            return
        end

        local function getFuel()
            for i = 1, container.size(), 1 do
				if(turtle.getFuelLevel() <= HIGH_FUEL_THRESHOLD) then
					turtle.suckUp(1)
					turtle.refuel(1)
					os.sleep(1)

					turtle.dropDown()
					if(i % 5 == 0) then
						printFuel()	
					end
				end
            end
		
            return false
        end

        printError(
            "\n\n" .. label .. " low fuel: ")
        while (turtle.getFuelLevel() <= HIGH_FUEL_THRESHOLD) do
			printFuel()
            if getFuel() then
            	turtle.dropDown()
                break
            end
        end
		monitor.setTextColor(colors.green)
		print(label .. " refueled")
		
		
		deploy()
		monitor = nil
	else 
		deploy()
		monitor = nil
    end
end

function deploy()
	printFuel()
	print("Fuel acceptable\n")
	term.setCursorBlink(true)
	print("Deploying ...")
	print(label)
	print()
	state = "Harvesting"
	sleep(3)
	term.setCursorBlink(false)
	term.setTextColor(colors.lime)
	print(label)
	print("Deployed")
	
	term.redirect(term.native())
	consider()
end

function gotoLaunchPad()
	if LauncherCoordinates ~= nil then
		term.setTextColor(colors.lime)
		print("seeking launchpad at")
		print(getLaunchCoorString())
	else
		term.setTextColor(colors.red)
		print("Missing Coordinates")
	end
	
	
	setLocation()
	correctYPosition()


	correctXPosition()
	turtle.back()
	turtle.turnLeft()
	
	correctZPosition()
	
	
	turtle.turnRight()
	turtle.forward()

	setLocation()
	
	-- Docked, check Fuel and harvest
	state = "Fueling"
	IsLowOnFuel()
	
end

function correctYPosition()
	while math.floor(LauncherCoordinates[2]) ~=  math.floor(yPos) do
		getLocation()
		if math.floor(LauncherCoordinates[2]) <  math.floor(yPos) and yPos < 70 then
			turtle.down()
			setLocation()
		elseif math.floor(LauncherCoordinates[2]) >  math.floor(yPos) and yPos > 60 then
			turtle.up()
			setLocation()
		else
			return
		end
	end
end

function correctZPosition()
	while math.floor(LauncherCoordinates[3]) ~=  math.floor(zPos) do
		getLocation()
		if math.floor(LauncherCoordinates[3]) <  math.floor(zPos) then
			turtle.forward()
			setLocation()
		elseif math.floor(LauncherCoordinates[3]) >  math.floor(zPos)then
			turtle.back()
			setLocation()
		else
			return
		end
	end
end

function correctXPosition()
	while math.floor(LauncherCoordinates[1]) ~=  math.floor(xPos) do
		getLocation()
		if math.floor(LauncherCoordinates[1]) <  math.floor(xPos) then
			turtle.back()
			setLocation()
		elseif math.floor(LauncherCoordinates[1]) >  math.floor(xPos) then
			turtle.forward()
			setLocation()
		else
		end
	end
end

function getLaunchCoorString()
	if LauncherCoordinates ~= nil then
		local x = tostring(LauncherCoordinates[1])
		local y = tostring(LauncherCoordinates[2])
		local z = tostring(LauncherCoordinates[3])
		return x .. ", " .. y.. ", "  .. z
	else
		return nil
	end
end

function setLocation()
	xPos, yPos, zPos = gps.locate()
	cal = true
end

function manSetLocation(x, y, z)
	xPos = x
	yPos = y
	zPos = z
	cal = true
end

function getLocation()
	if xPos ~= nil then
		return xPos, yPos, zPos
	else
		return nil
	end
end
 
function jump() -- perform a jump. useless? yup!
	turtle.up()
	turtle.down()
end

function initTurtle() 
	term.setTextColor(colors.green)
	print ("Launcher Coordinates: " .. getLaunchCoorString() .. ".")
	print ("LOW_FUEL_THRESHOLD: " .. LOW_FUEL_THRESHOLD .. ".")
	print ("HIGH_FUEL_THRESHOLD: " .. HIGH_FUEL_THRESHOLD .. ".")
	print ("MAX_FUEL: " .. MAX_FUEL .. ".")
	print ("HARVEST_ROW_LENGTH: " .. HARVEST_ROW_LENGTH .. ".")
	print ("HARVEST_MAX_AGE: " .. HARVEST_MAX_AGE .. ".")
	print ("HARVEST_MODE: " .. HARVEST_MODE .. ".")
	print ("HARVEST_CROP: " .. HARVEST_CROP .. ".")
	
	gotoLaunchPad()
end