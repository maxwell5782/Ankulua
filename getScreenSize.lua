setImmersiveMode(true)
autoGameArea(true)

local screen = getAppUsableScreenSize()
print(string.format("Usable %s*%s", screen:getX(), screen:getY()))
screen = getRealScreenSize()
print(string.format("Screen %s*%s", screen:getX(), screen:getY()))
print(getGameArea())
