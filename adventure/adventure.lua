-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.8)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
regionFoot = Region(1615, 631, 87, 80)

-- 找圖
function findImage(image, region)
    repeat
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image)
        wait(findImageInterval)
    until result ~= nil

    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 設定
dialogInit()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
dialogShow("設定")

while true do
    -- 往下移動直到出現腳腳
    repeat
        manualTouch({
            { action = "touchDown", target = Location(273, 980) },
            { action = "wait",      target = 2 },
            { action = "touchUp",   target = Location(273, 980) },
            { action = "wait",      target = interval }
        })
        result = regionFoot:exists("foot.png")
    until result ~= nil

    -- 進入副本
    click(regionFoot:getLastMatch())
    click(findImage("enter.png", Region(2024, 965, 83, 46)))
    Region(1203, 637, 308, 111):existsClick("confirm.png")
    click(findImage("auto.png", Region(2190, 685, 85, 85)))
    click(findImage("start_auto.png", Region(1569, 841, 141, 35)))

    repeat
        toast("auto adventure")
        result = Region(2190, 685, 85, 85):exists("auto.png")
        -- 這邊自動冒險中，換層如果有目標路線就點
        Region(560, 274, 1209, 290):existsClick("marker.png")
        wait(findImageInterval)
    until result ~= nil

    -- 離開副本
    click(findImage("exit.png", Region(1980, 93, 29, 35)))
    click(findImage("exit_adv.png", Region(804, 828, 132, 37)))
    click(findImage("confirm.png", Region(1310, 670, 94, 51)))

    -- 確認已經離開
    findImage("land.png", Region(2203, 921, 85, 81))
end
