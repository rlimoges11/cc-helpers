windows = {}

function drawPalette(x,y)
	term.setCursorPos(x,y)
	term.blit("0123456789abcdef","0000000000000000","0123456789abcdef")
end

function openWindow(title, x, y, x2, y2, headerFG, headerBG, windowFG, windowBG, addBorders, addMargins)
	local ww = x2 - x + 1
	local wh = y2 - y + 1

	if windows["Background"] then
		par = windows["Background"] 
	else
		par = term.native()
	end

	local mainWindow = window.create(par, x, y, ww, wh)
	table.insert(windows, mainWindow)
	windows[title] = mainWindow
	mainWindow.name = title
	mainWindow.title = "Helnet - " .. title
	mainWindow.borders = addBorders
	mainWindow.magins = addMargins
	mainWindow.x = x
	mainWindow.y = y
	mainWindow.x2 = ww
	mainWindow.y2 = wh
	mainWindow.setBackgroundColor(windowBG)
	mainWindow.clear()
	mainWindow.setCursorPos(1,1)
	mainWindow.setTextColor(headerFG)


	if addBorders == true then
		if addMargins then 
			iwx = 3
			iww = ww - 3
		else
			iwx = 2
			iww = ww - 2
		end
		local innerWindow = window.create(mainWindow, iwx, 2, iww, wh - 2)
		windows[title .. "-inner"] = innerWindow
		innerWindow.x = 3
		innerWindow.y = 1
		innerWindow.x2 = ww -2
		innerWindow.y2 = wh -2
		innerWindow.setBackgroundColor(windowBG)
		innerWindow.clear()
		innerWindow.setCursorPos(1,1)
		innerWindow.setTextColor(windowFG)
	end

	mainWindow.innerWindow = innerWindow

	mainWindow.update = function()
		if mainWindow.innerWindow then
			if mainWindow.borders then 
				innerWindow.reposition(innerWindow.x,innerWindow.y,innerWindow.x2 ,innerWindow.y2)
				mainWindow.drawWindowFrame()
			end

			mainWindow.reposition(mainWindow.x,mainWindow.y,mainWindow.x2,mainWindow.y2)

		end
	end

	mainWindow.drawWindowFrame = function()
		if mainWindow.borders == true then
			term.redirect(mainWindow)
			paintutils.drawFilledBox(1, 1, ww, wh, headerBG)
			paintutils.drawFilledBox(2, 2, ww-1, wh-1, windowBG)
			term.setCursorPos(2, 1)
			term.setTextColor(headerFG)
			term.setBackgroundColor(headerBG)
			term.write(mainWindow.title)
			term.setCursorPos(ww - 2, 1)
			term.write("\31\30\42")
			term.redirect(term.native())
		else
			mainWindow.update()
		end
	end


	mainWindow.drawImg = function(img, ix, iy) 
		term.redirect(mainWindow)
		paintutils.drawImage(img, ix, iy)
		term.redirect(term.native())
	end

	mainWindow.randomBlit = function(characters, fgs, bgs)
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

	mainWindow.drawWindowFrame()

	table.insert(windows, mainWindow)
	table.insert(windows, innerWindow)
	return mainWindow
end

function notice(msg, subMsg)
	local oldTerm = term.current()
	local iw = windows["Logs-inner"]
	if logs ~= nil then
		term.redirect(iw)
		term.setBackgroundColor(colors.white)
		print(msg)
		term.setTextColor(colors.green)
		print(subMsg)
		term.redirect(oldTerm)
		logs.update()
	else
		term.setBackgroundColor(colors.black)
		logger(msg)
		term.setTextColor(colors.green)
		print_center(subMsg)
		print ""
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

function drawMenu()
	local timeString = getTime()
	local termWidth, termHeight = term.getSize()
	term.redirect(windows["Menu"])

	term.setBackgroundColor(colors.gray)
	paintutils.drawLine(1,1, termWidth, 1, colors.gray)
	term.setCursorPos(1,1)

	term.setTextColor(colors.red)
	term.write(" H")
	term.setTextColor(colors.orange)
	term.write("e")
	term.setTextColor(colors.yellow)
	term.write("l")
	term.setTextColor(colors.lime)
	term.write("N")
	term.setTextColor(colors.green)
	term.write("e")
	term.setTextColor(colors.cyan)
	term.write("t")

	term.setCursorPos(termWidth - 6, 1)
	term.write(timeString .. " ^")
	term.redirect(term.native())
end

function createMenu()
	local termWidth = term.getSize()
	local menuWindow = openWindow("Menu", 1, 1, termWidth, 1, colors.lightBlue, colors.blue, colors.blue, colors.lightBlue, false, false)	
	drawMenu()
	return menuWindow
end

function toggleMenu()
	--term.redirect(windows["Menu"])
	windows["Menu"].setVisible(false)
	windows["Menu"].redraw()
	--term.redirect(term.native())
end




return {openWindow = openWindow, notice = notice, printNative = printNative, printWindow = printWindow, windows = windows }