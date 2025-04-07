

local function wait_for_keyPress()
    repeat
    	os.sleep(0.01)
        local _, key = os.pullEvent("key")

		if key == keys.a then 
			notice("Displaying", "Page 1 on Jumbotron")
			--modem.transmit(43, 15, "Jumbotron page 1")
		end
		if key == keys.b then 
			notice("Displaying", "Page 2 on Jumbotron")
			--modem.transmit(43, 15, "Jumbotron page 2")
		end
		if key == keys.c then 
			notice("Clearing", "Jumbotron")
			--modem.transmit(43, 15, "Jumbotron clear")
		end
		if key == keys.e then 
			notice("Requesting", "Sensors report")
			--modem.transmit(43, 15, "Sensors report")
		end
		if key == keys.r then 
			notice("Rebooting", "Network computers")
			--modem.transmit(43, 15, "Jumbotron reboot")
		end

    until key == keys.q
    print("Terminating!")
end



local function wait_for_click()
	repeat
		os.sleep(0.01)
		local event, button, x, y = os.pullEvent( "mouse_click" )
		printNative(button .. " at " .. x .. "," .. y, colors.lightBlue, colors.gray)
		
		if isInBounds(x,y, 2, 1, 7, 1) then
			togglePaletteGUI()
		end

		if x == 26 and y == 1 then
			toggleMenu()
		end
		
	until 2 == 1
end


function wait_for_transmissions()
	repeat
		os.sleep(1)
		local id, message = rednet.receive()

	    if id ~= nil then			
			 notice(("Computer %d sent message %s"):format(id, message))
		end
	until 2 == 1
end


return { wait_for_keyPress = wait_for_keyPress, wait_for_click = wait_for_click, wait_for_transmissions = wait_for_transmissions }