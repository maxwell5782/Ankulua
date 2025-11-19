-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

regionSail = Region(1300, 630, 300, 280)
regionSkill = Region(1842, 600, 441, 338)
regionSwitch = Region(2216, 967, 62, 46)

while true do
    regionSwitch:existsClick("開關.png", 0.5)
    regionSkill:existsClick("測量.png", 0.5)
    regionSail:existsClick("sail.png", 0.5)
    regionSail:existsClick("boating.png", 0.5)
    wait(4)
end
