-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

regionSail = Region(1300, 630, 300, 280)

while true do
    regionSail:existsClick("sail.png")
    regionSail:existsClick("boating.png")
    wait(4)
end
