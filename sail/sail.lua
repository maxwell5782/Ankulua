-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

regionSail = Region(1300, 630, 300, 280)

while true do
    regionSail:existsClick("sail.png", 1)
    regionSail:existsClick("boating.png", 1)
    wait(4)
end
