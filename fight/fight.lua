-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

setManualTouchParameter(30, 1)

actionList = { {action = "touchDown", target = Location(310,250)},
    {action = "touchMove", target = Location(600,250)},
    {action = "touchUp", target = Location(600,250)} }

while true do 
 if exists("fight.png", 0.5) 
 then
  existsClick("fight.png")
 else
  manualTouch(actionList)
 end
end