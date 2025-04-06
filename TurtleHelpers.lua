require ("../cc-helpers/MonitorHelpers")
label = os.computerLabel()
logger(label .. " online")

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
local xOld, yOld, zOld = nil
face = -1
cal = false
state = "Finding facing direction"


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
	print("arrived")
	launch()
end

function dropInventory()
	local monitor = peripheral.find("monitor") or nil
	if(monitor) then
		term.redirect(monitor)
		recalibrate(monitor)
		logger(label)
		write_center(term, "UNLOADING\n\n")
	end
	

	
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

	term.setTextColor(colors.green)
	logger(label)
	write_center(term, "UNLOADED")
	write_center(term, "DEPLOYED \n")

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
	local monitor = peripheral.find("monitor") or nil
	
	if monitor ~= nil then
		term.redirect(monitor)
		term.setTextScale(0.5)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.lime)
	end
	logger(label)
	
	
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
					printFuel()	
					os.sleep(1)
					turtle.dropDown()
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
		logger(label)
		write_center(term, "REFUELED")
		deploy()
		monitor = nil
	else 
		deploy()
		monitor = nil
    end
end

function deploy()
	printFuel()
	term.setCursorBlink(true)
	write_center(term, label)
	write_center(term, "READY")
	print("")
	print("")
	state = "Harvesting"
	sleep(2)
	term.setCursorBlink(false)
	logger(label)
	write_center(term, "DEPLOYED")
	print("")
	term.redirect(term.native())
	consider()
end

function gotoLaunchPad()
	if LauncherCoordinates ~= nil then
		term.setTextColor(colors.lime)
		logger("seeking launchpad (" .. getLaunchCoorString() .. ")")
	else
		
		term.setTextColor(colors.red)
		print("Missing Coordinates")
	end

	setLocation()
	

	correctXPosition()
	turtle.back()
	turtle.turnLeft()
	


	correctZPosition()
	
	correctYPosition()
	
	
	

	setLocation()
	
	launch()

end

function correctYPosition()
	while math.floor(LauncherCoordinates[2]) ~=  yPos do
		if math.floor(LauncherCoordinates[2]) <  yPos then
			turtle.down()
			setLocation()
		elseif math.floor(LauncherCoordinates[2]) >  yPos then
			turtle.up()
			setLocation()
		else
			return
		end
	end
end

function correctZPosition()
	while math.floor(LauncherCoordinates[3]) ~=  zPos do
		getLocation()
		if math.floor(LauncherCoordinates[3]) <  zPos then
			turtle.forward()
			setLocation()
		elseif math.floor(LauncherCoordinates[3]) > zPos then
			turtle.back()
			setLocation()
		else
			return
		end
	end
end

function correctXPosition()
	while math.floor(LauncherCoordinates[1]) ~=  xPos do
		getLocation()
		if math.floor(LauncherCoordinates[1]) <  xPos then
			turtle.back()
			setLocation()
		elseif math.floor(LauncherCoordinates[1]) >  xPos then
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
	xOld, yOld, zOld = xPos, yPos, zPos
	xPos, yPos, zPos = gps.locate()

	if xPos ~= nil and yPos ~= nil and zPos ~= nil then
		xPos = math.floor(xPos)
		yPos = math.floor(yPos)
		zPos = math.floor(zPos)
	else
		xOld, yOld, zOld = xPos, yPos, zPos
	end

	if xPos == nil then
		xPos = 0
	end
	if yPos == nil then
		yPos = 0
	end
	if zPos == nil then
		zPos = 0
	end
end

function manSetLocation(x, y, z)
	xPos = x
	yPos = y
	zPos = z
	cal = true
end

function getLocation()
	return xPos, yPos, zPos
end
 
function jump() -- perform a jump. useless? yup!
	turtle.up()
	turtle.down()
end

function flyToY(newY)
	setLocation()
	while newY ~=  yPos do
		getLocation()
		if newY <  yPos then
			turtle.down()
			setLocation()

			-- stuck
			while(yOld == yPos) do
				turtle.forward()
				turtle.down()
				setLocation()
			end
		elseif newY > yPos then
			turtle.up()
			setLocation()

			-- stuck
			while(yOld == yPos) do
				turtle.forward()
				turtle.down()
				setLocation()
			end
		else
			return
		end
	end
end

function flyToX(newX)
	setLocation()
	while newX ~= xPos do
		getLocation()
		if newX < xPos then
			turtle.back()
			setLocation()

			-- stuck
			while(xOld == xPos) do
				turtle.up()
				turtle.forward()
				setLocation()
			end
		elseif newX > xPos then
			turtle.forward()
			setLocation()

			-- stuck
			while(xOld == XPos) do
				turtle.down()
				turtle.back()
				setLocation()
			end
		else
			return
		end
	end
end

function flyToZ(newZ)
	setLocation()
	while newZ ~= zPos do
		getLocation()
		if newZ < zPos then
			turtle.back()
			setLocation()

			-- stuck
			while(zOld == zPos) do
				turtle.up()
				turtle.forward()
				setLocation()
			end
		elseif newZ > zPos then
			turtle.forward()
			setLocation()

			-- stuck
			while(zOld == ZPos) do
				turtle.down()
				turtle.back()
				setLocation()
			end
		else
			return
		end
	end
end

function printLocation()
	getLocation()
	setLocation()
	if xPos ~= nil and yPos ~= nil and zPos ~= nil then
		logger ("" .. xPos .. "," .. yPos .. "," .. zPos)
	end

end

function getFacing()
	getLocation()
	while xOld >= xPos do
		getLocation()
		print (xOld .. " " .. xPos)
		turtle.turnLeft()
		turtle.forward()
		setLocation()
	end
end

function launch()
	-- Docked, check Fuel and harvest
	print("launched")
	state = "Scanning"
	recalibrate()
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
	printLocation()

	local x = (LauncherCoordinates[1])
	local y = (LauncherCoordinates[2])
	local z = (LauncherCoordinates[3])

	launch()
end

function flyTo(x,y,z)
	flyToY(y)
	getFacing()
	flyToY(y)
	flyToX(x)
	turtle.turnRight()
	flyToZ(z)

	setLocation()
end

