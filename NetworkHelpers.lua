

local netModem = peripheral.find("modem", rednet.open)
rednet.broadcast("Hello, world!")

local id, message = rednet.receive()
print(("Computer %d sent message %s"):format(id, message))


return { }