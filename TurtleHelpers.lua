label = os.computerLabel()
print(label .. " online")

local hasBlock
local originalBlockData

-- Get settings
local LOW_FUEL_THRESHOLD = settings.get("LOW_FUEL_THRESHOLD")
local HIGH_FUEL_THRESHOLD = settings.get("HIGH_FUEL_THRESHOLD")
local HARVEST_ROW_LENGTH = settings.get("HARVEST_ROW_LENGTH")
local HARVEST_MAX_AGE = settings.get("HARVEST_MAX_AGE")
local HARVEST_MODE = settings.get("HARVEST_MODE")
local MAX_FUEL = settings.get("MAX_FUEL")

function consider()
	inspectMode()
	
	if(HARVEST_MODE == "bottom") then
		if hasBlock and originalBlockData.state.age ~= nil then
			if HARVEST_MAX_AGE ~= nil then
				if originalBlockData.state.age >= HARVEST_MAX_AGE then
					digMode()
				end
			else
				digMode()
			end
			
		else
			digMode()
			
		end
		
		turtle.placeDown()
	else
		digMode()
	end
	
	
	turtle.forward()
end

function inspectMode()
	if(HARVEST_MODE == "bottom") then
		has_block, originalBlockData = turtle.inspectDown()
	else 
		--has_block, originalBlockData = turtle.inspect()
	end
end

function digMode()
	if(HARVEST_MODE == "bottom") then
		turtle.digDown()
	else
		turtle.dig()
	end
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
	for i = 1, steps, 1 do
		turtle.forward()
	end
	
	turtle.turnRight()
	IsLowOnFuel()
end

function dropInventory()
	print(label .. " is unloading inventory.")
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
end

function printFuel()
	print(label .. " fuel: " .. turtle.getFuelLevel() .. "/" .. MAX_FUEL)
end


function IsLowOnFuel()

	local fuelLevel = math.floor(turtle.getFuelLevel())
	
	if fuelLevel < LOW_FUEL_THRESHOLD then
		printFuel()
		print(label .. " is fueling up.")
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
                turtle.suckUp(1)
				turtle.refuel(1)
				os.sleep(1)
				turtle.dropDown()
            end
			
			printFuel()
		
            return false
        end

        printError(
            "\n\n" .. label .. " is running low on fuel. all operations have been stopped until fuel is provided on the chest above.\n")
        while toint(turtle.getFuelLevel()) < HIGH_FUEL_THRESHOLD do
            if getFuel() then
                break
            end
        end
		
		print(label .. " is sufficiently refueled.")
		consider()
	else 
		printFuel()
		print(label .. " fuel is within threshold.")
		consider()
    end
end


function initTurtle() 
	print ("LOW_FUEL_THRESHOLD: " .. LOW_FUEL_THRESHOLD .. ".")
	print ("HIGH_FUEL_THRESHOLD: " .. HIGH_FUEL_THRESHOLD .. ".")
	print ("MAX_FUEL: " .. MAX_FUEL .. ".")
	print ("HARVEST_ROW_LENGTH: " .. HARVEST_ROW_LENGTH .. ".")
	print ("HARVEST_MAX_AGE: " .. HARVEST_MAX_AGE .. ".")
	print ("HARVEST_MODE: " .. HARVEST_MODE .. ".")
	IsLowOnFuel()
end