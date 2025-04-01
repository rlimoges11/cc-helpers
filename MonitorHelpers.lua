function logger(msg, scheme) 
	if scheme == nil then
			scheme=""
	end

	if windows ~= nil then
print("")
		term.setTextColor(colors.black)
		term.write(getTime())
print("")
		term.setTextColor(colors.lime)
		fastprint(msg, 0.02)
print("")

	else
		term.setTextColor(colors.white)
		term.write(getTime() .. " ")
		term.setTextColor(colors.lime)
		term.write(msg)
		term.setTextColor(colors.green)
	end
end

function display_clear(label)
	screen.clear()
	screen.setBackgroundColor(colors.black)
	
	screen.setTextColor(colors.white)

	if label == "Jumbotron" then 
		screen.setTextScale(2)
	elseif label == "medivac" then 
		screen.setTextScale(1)
	else
		screen.setTextScale(0.5)
	end

end

function recalibrate()
	screen.setTextScale(2)
	screen.setBackgroundColor(colors.blue)
	screen.setTextColor(colors.white)
	screen.clear()
	screen.setCursorPos(1,3)

	write_center(getTime())
	write_center(os.computerLabel())
	print("")
	write_center("Recalibrating")

	os.sleep(0.5)
	screen.setTextScale(0.5)	
	screen.setCursorPos(1,1)
	screen.setTextColor(colors.white)
	
  paintutils.drawFilledBox(1,1,9,4, colors.black)
	screen.setCursorPos(1,1)
	screen.setBackgroundColor(colors.black)
	print(screen.getSize())
 	print("Monitor")
 	print("Detected")
 	os.sleep(1)
 	screen.setBackgroundColor(colors.purple)
 	screen.clear()
end

function fastprint(text, delay)
    delay = delay or 0.02  -- Default delay between chunks
    local chunkSize = 5    -- Characters to print at once
    
    -- Print in chunks and let print() handle wrapping
    for i = 1, #text, chunkSize do
        local chunk = text:sub(i, i + chunkSize - 1)
        write(chunk)  -- Use write instead of print to avoid auto-newlines
        
        -- Small delay but skip if delay is 0
        if delay > 0 then
            sleep(delay)
        end
    end
end

function write_center(text)
  local x, y = term.getCursorPos()
  local width, height = term.getSize()
  term.setCursorPos(math.floor((width - #text) / 2) + 1, y)
  term.write(text)
  term.setCursorPos(math.floor((width - #text) / 2) + 1, y+1)
end

function print_center(text, bg)
  local x, y = term.getCursorPos()
  local width, height = term.getSize()

  term.setBackgroundColor(bg)
  term.setCursorPos(math.floor((width - #text) / 2) + 1, y)
  print(text)
  term.setCursorPos(1, y+1)

end

function getTime()
	return tostring(textutils.formatTime(os.time("local"), true))
end 

function setScreenColor(screen, color )
			if color == "white" then
				screen.setTextColor(colors.white)
			end
			if color == "orange" then
				screen.setTextColor(colors.orange)
			end
			if color == "magenta" then
				screen.setTextColor(colors.magenta)
			end
			if color == "lightBlue" then
				screen.setTextColor(colors.lightBlue)
			end
			if color == "yellow" then
				screen.setTextColor(colors.yellow)
			end
			if color == "lime" then
				screen.setTextColor(colors.lime)
			end
			if color == "pink" then
				screen.setTextColor(colors.pink)
			end
			if color == "gray" then
				screen.setTextColor(colors.gray)
			end
			if color == "lightGray" then
				screen.setTextColor(colors.lightGray)
			end
			if color == "cyan" or color == "teal" then
				screen.setTextColor(colors.cyan)
			end
			if color == "purple" then
				screen.setTextColor(colors.purple)
			end
			if color == "blue" then
				screen.setTextColor(colors.blue)
			end
			if color == "brown" then
				screen.setTextColor(colors.brown)
			end
			if color == "green" then
				screen.setTextColor(colors.green)
			end
			if color == "red" then
				screen.setTextColor(colors.red)
			end
			if color == "black" then
				screen.setTextColor(colors.black)
			end
end


function getScreen()
	screen = peripheral.find("monitor") or nil
	return screen
end

function paintScreen(offsetX, offsetY)
	local w, h = term.getSize()
	local imga = paintutils.loadImage("images/glowsteel.nfp")
	local imgb = paintutils.loadImage("images/glowsteel-2.nfp")
	local c = 0

	term.setCursorPos(1,1)
	-- 15x10 ?
	for y = 1, h + 10, 10 do
		for x = 1, w + 16, 16 do
			if math.random(100) > 50 then
				paintutils.drawImage(imga, x - offsetX, y - offsetY)
			else
				paintutils.drawImage(imgb, x - offsetX, y - offsetY)
			end
			c = c + 1
		end
	end
end

local screen = getScreen()

return { reset = reset, write_center = write_center, print_center = print_center, display_clear = display_clear, writeTime = writeTime, recalibrate = recalibrate, wordprint = wordprint }