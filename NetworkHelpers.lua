local netModem = peripheral.find("modem", rednet.open)


function connect()
	logger("Connecting")
	os.sleep(1)
	rednet.broadcast("Hello, world!")
	os.sleep(1)
end

return { connect = connect}