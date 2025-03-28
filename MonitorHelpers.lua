function logger(msg) 
	if windows["logs"] ~= nil then
		term.setTextColor(colors.black)
		term.clearLine(20)
		term.write(getTime() .. " ")
		term.setTextColor(colors.lime)
		term.write(msg)
		term.setTextColor(colors.green)
		print("")
	else
		term.setTextColor(colors.white)
		term.write(getTime() .. " ")
		term.setTextColor(colors.lime)
		term.write(msg)
		term.setTextColor(colors.green)
		print("")
	end
end

function display_clear(screen, label)
	print ("Clearing screen on computer: " .. label)
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

	print (tostring(screen) .. " " .. tostring(screen.getSize()) .. " cleared.")
end

function recalibrate(mon)
		mon.setTextScale(0.5)
		mon.clear()
		mon.setCursorPos(1,1)
end

function write_center(text)
  local x, y = term.getCursorPos()
  local width, height = term.getSize()
  term.setCursorPos(math.floor((width - #text) / 2) + 1, y)
  term.write(text)
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


return { reset = reset, write_center = write_center, print_center = print_center, display_clear = display_clear, writeTime = writeTime, recalibrate = recalibrate }