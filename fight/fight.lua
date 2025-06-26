-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

actionList = { {action = "touchDown", target = Location(800,350)},
    {action = "touchMove", target = Location(1000,350)},
    {action = "touchUp", target = Location(1000,350)} }

while true do 
 if exists("fight.png", 0.5) 
 then
    click(getLastMatch())
 else
  manualTouch(actionList)
 end
end