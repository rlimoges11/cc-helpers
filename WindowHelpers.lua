local windows = {}
function drawMenu()
	term.setCursorPos(1,1)
	term.setBackgroundColor(colors.gray)

	term.setTextColor(colors.red)
	write(" H")
	term.setTextColor(colors.orange)
	write("e")
	term.setTextColor(colors.yellow)
	write("l")
	term.setTextColor(colors.lime)
	write("N")
	term.setTextColor(colors.green)
	write("e")
	term.setTextColor(colors.cyan)
	write("t")
	write ("            " .. tostring(textutils.formatTime(os.time("local"), true)) .. " ^")
end

function drawPalette(x,y)
	term.setCursorPos(x,y)
	term.blit("0123456789abcdef","0000000000000000","0123456789abcdef")
end

function openWindow(title, x, y, w, h, headerFG, headerBG, windowFG, windowBG, drawHeader)

	-- window box
	paintutils.drawFilledBox(x, y, x + w - 1 , y + h - 1, windowBG)

	-- Title Bar
	paintutils.drawLine(x, y - 1, x + w - 1, y-1, headerBG)
	term.setCursorPos(x, y-1)
	term.setTextColor(headerFG)
	print(" " .. title)

	term.setCursorPos(x + w - 1, y - 1)
	print("X")

	-- Footer BG
	paintutils.drawLine(x, y + h, x + w - 1, y + h , headerBG)

	-- window area
	local myWindow = window.create(term.current(),x + 1, y+1, w - 1, h -1)
	-- table.insert(windows, myWindow)
	windows[title] = myWindow
	myWindow.setBackgroundColor(windowBG)
	myWindow.clear()
	paintutils.drawFilledBox(x, y, x + w - 1 , y + h -1, windowBG)
	term.setCursorPos(1,1)
	term.setTextColor(windowFG)
end

function notice(msg, subMsg)
	local oldTerm = term.current()
	if windows["Logs"] then
		term.redirect(windows["Logs"])
		term.setBackgroundColor(colors.white)
		logger(msg)
		term.setTextColor(colors.green)
		print(subMsg)
	else
		term.setBackgroundColor(colors.black)
		logger(msg)
		term.setTextColor(colors.green)
		print_center(subMsg)
	end
	print("")

	if windows["Logs"]  then
		term.redirect(oldTerm)
	end
end

function printNative(msg, fg, bg)
	local oldTerm = term.current()
	term.redirect(term.native())
	term.setCursorPos(1,20)
	term.setTextColor(fg)
	term.setBackgroundColor(bg)
	term.clearLine(1)
	write_center(msg)
	term.redirect(oldTerm)
end

return {openWindow = openWindow, notice = notice, printNative = printNative, printWindow = printWindow }