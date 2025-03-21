function initGPS()
	local GPScoordinates = settings.get("GPScoordinates") or print "Missing GPS coordinates"
	
	if GPScoordinates ~= nil then
	
		GPSStr = tostring(GPScoordinates[1]) .. ", " .. tostring(GPScoordinates[2]) .. ", " .. tostring(GPScoordinates[3])
		
		tabGPS = shell.openTab("gps", "host", GPScoordinates[1], GPScoordinates[2], GPScoordinates[3])
		multishell.setTitle(tabGPS, "GPS")
		
		term.setTextColor(colors.lime)
		print("Hosting GPS in BG at " .. GPSStr)
	
		term.setTextColor(colors.green)
	end
end

return {
    initGPS = initGPS()
}