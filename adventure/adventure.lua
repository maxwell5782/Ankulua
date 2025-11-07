-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.8)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
AutoWaitTimeout = 1
regionFoot = Region(1615, 631, 87, 80)

-- 主要路線
routes = {}
routes[0] = "標誌物.png"
routes[1] = "採集.png"

-- 找圖
function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
    result = region:exists(image, AutoWaitTimeout)
    while result == nil do
        wait(findImageInterval)
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image, AutoWaitTimeout)
    end
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 設定
dialogInit()
addTextView("目標路線")
addRadioGroup("routeIdx", 0)
for i, name in pairs(routes) do
    addRadioButton(name, i)
end
newRow()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
dialogShow("")

while true do
    -- 往下移動直到出現腳腳
    repeat
        manualTouch({
            { action = "touchDown", target = Location(273, 1050) },
            { action = "wait",      target = 1 },
            { action = "touchUp",   target = Location(273, 1050) },
            { action = "wait",      target = interval }
        })
        result = regionFoot:exists("foot.png", AutoWaitTimeout)
    until result ~= nil

    -- 進入副本
    click(regionFoot:getLastMatch())
    click(findImage("enter.png", Region(2024, 965, 83, 46)))
    Region(1203, 637, 308, 111):existsClick("confirm.png", AutoWaitTimeout)
    click(findImage("auto.png", Region(2209, 742, 48, 46)))
    click(findImage("start_auto.png", Region(1569, 841, 141, 35)))
    wait(2)
    while true do
        -- 找不到自動中，可能是在選路線
        if Region(1173, 1002, 101, 32):exists("自動中.png", AutoWaitTimeout) == nil then 
            if Region(1083, 110, 182, 43):exists("選擇路線.png", AutoWaitTimeout) == nil then
                -- 也可能是選完路線的過場
                result = Region(49, 257, 95, 26):exists("目的地.png", AutoWaitTimeout)
                if result == nil then
                    -- 真的是結束自動冒險了
                    break
                end
            end
        end
        -- 這邊自動冒險中，換層如果有目標路線就點
        Region(560, 274, 1209, 290):existsClick(routes[routeIdx], AutoWaitTimeout)
        wait(findImageInterval)
    end
    -- 離開副本
    wait(2)
    click(Location(2000, 115))
    click(findImage("exit_adv.png", Region(804, 828, 132, 37)))
    click(findImage("confirm.png", Region(1310, 670, 94, 51)))

    -- 確認已經離開
    --findImage("land.png", Region(2223, 967, 55, 53))
    findImage("小地球.png", Region(1973, 979, 43, 41))
end
