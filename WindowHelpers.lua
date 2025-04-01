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

function openWindow(title, x, y, w, h, headerFG, headerBG, windowFG, windowBG, addBorders, addMargins)
	local x2 = x + w
	local y2 = y + h
	local wx = x
	local wy = y
	local ww = w 
	local wh = h 

	-- frame box
	if addBorders == true then
		x2 =  x2 + 1
		y2 =  y2 + 1
		paintutils.drawBox(x-1, y-1, x2, y2, headerBG)

		-- Title Bar
		if addMargins == true then
			paintutils.drawBox(x, y, x2-1, y2-1, windowBG)

			term.setCursorPos(x+1, y-1)
		else
			term.setCursorPos(x, y-1)
		end
		term.setTextColor(headerFG)
		term.setBackgroundColor(headerBG)
		print(title)
		term.setCursorPos(x + w -2, y - 1)
		print("\31\30 \120")
	end

	if addBorders then
		ww = ww + 1
		wh = wh + 1
	end

	if addMargins then
		wx = wx + 1
		ww = ww - 2
		wy = wy + 1
		wh = wh - 2
	end

	local myWindow = window.create(screen, wx, wy, ww, wh)
	table.insert(windows, myWindow)
	windows[title] = myWindow
	myWindow.name = title
	myWindow.title = "Helnet - " .. title
	myWindow.x = wx
	myWindow.y = wy
	myWindow.w = ww
	myWindow.h = wh
	myWindow.x2 = x2
	myWindow.y2 = y2
	myWindow.setBackgroundColor(windowBG)
	myWindow.clear()
	myWindow.setCursorPos(1,1)
	myWindow.setTextColor(windowFG)

	myWindow.update = function()
		myWindow.reposition(myWindow.x,myWindow.y,myWindow.ww,myWindow.wh)
	end


	myWindow.randomBlit = function(characters, fgs, bgs)
	    print("")
		local chStr = ""
		local fgStr = ""
		local bgStr = ""

        for i = 1, w + 1, 1 do
			rc = math.random(string.len(characters))
			c = string.sub(characters, rc, rc)
			chStr = chStr .. c

			rf = math.random(string.len(fgs))
			fg = string.sub(fgs, rf, rf)
			fgStr = fgStr .. fg

			rb = math.random(string.len(bgs))
			bg = string.sub(bgs, rb, rb)
			bgStr = bgStr .. bg
        end

		term.blit(chStr, fgStr, bgStr)
	end


	return myWindow
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

return {openWindow = openWindow, notice = notice, printNative = printNative, printWindow = printWindow, windows = windows }