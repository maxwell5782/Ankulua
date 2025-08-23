-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.95)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 1
findImageInterval = 5

-- 任務欄範圍
regionMission = Region(38, 93, 595, 737)

-- 可用任務
missions = {}
missions[0] = "海岸的封鎖.png"
missions[1] = "大海盜再臨.png"

-- 找圖
function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x,
                        region.y, region.w, region.h))
    result = region:exists(image)
    while result == nil do
        wait(findImageInterval)
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x,
                            region.y, region.w, region.h))
        result = region:exists(image)
    end
    return region:getLastMatch()
end

-- 航行到指定圖為止，過程中會一直找操帆點擊
function sailTil(image, region)
    regionSail = Region(1300, 630, 300, 280)
    repeat
        wait(findImageInterval)
        toast(string.format("sailTil(%s, [%s,%s,%s,%s])", image, region.x,
                            region.y, region.w, region.h))
        regionSail:existsClick("sail.png")
        regionSail:existsClick("boating.png")
        result = region:exists(image)
    until result ~= nil
    return region:getLastMatch()
end

-- 在小地圖中找圖
function findInMap(place)
    toast(string.format("findInMap(%s)", place))
    manualTouch({
        -- 點小地圖
        {action = "touchDown", target = Location(2130, 220)},
        {action = "touchUp", target = Location(2130, 220)},
        {action = "wait", target = interval}, -- 先滑到上面
        {action = "touchDown", target = Location(1200, 100)},
        {action = "touchMove", target = Location(1200, 500)},
        {action = "touchUp", target = Location(1200, 500)},
        {action = "wait", target = interval}
    })
    -- 找目標圖示
    result = exists(place)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            {action = "touchDown", target = Location(1200, 900)},
            {action = "touchMove", target = Location(1200, 200)},
            {action = "touchUp", target = Location(1200, 200)},
            {action = "wait", target = interval}
        })
        result = exists(place)
    end
    return result
end

dialogInit()
addRadioGroup("missionIndex", 0)
for i, name in pairs(missions) do addRadioButton(name, i) end
dialogShow("哪個任務")

while true do
    -- 點委託任務
    click(findImage("委託任務.png", Region(1829, 973, 232, 51)))
    wait(interval)
    -- 找指定任務
    result = regionMission:exists(missions[missionIndex])
    wait(interval)
    -- 找不到的話，往下滑找
    if result == nil then
        manualTouch({
            {action = "touchDown", target = Location(350, 660)},
            {action = "touchMove", target = Location(350, 300)},
            {action = "touchUp", target = Location(350, 300)},
            {action = "wait", target = interval}
        })
        result = regionMission:exists(missions[missionIndex])
        -- 還找不到的話，點更新任務
        while result == nil do
            click(findImage("更新任務.png", Region(257, 957, 146, 43)))
            result = regionMission:exists(missions[missionIndex])
            wait(interval)
        end
    end

    -- 接任務
    click(result)
    wait(interval)
    -- 接受
    click(findImage("接受.png", Region(1979, 944, 79, 40)))
    wait(interval)
    -- 關閉委託介面
    manualTouch({
        {action = "touchDown", target = Location(1360, 700)},
        {action = "touchUp", target = Location(1360, 700)},
        {action = "wait", target = interval},
        {action = "touchDown", target = Location(1360, 700)},
        {action = "touchUp", target = Location(1360, 700)},
        {action = "wait", target = interval}
    })
    -- 小地圖
    manualTouch({
        {action = "touchDown", target = Location(2130, 220)},
        {action = "touchUp", target = Location(2130, 220)},
        {action = "wait", target = interval}
    })
    -- 地球
    click(findImage("地球.png", Region(2178, 548, 106, 93)))
    wait(interval)
    -- 往下滑一點
    manualTouch({
        {action = "touchDown", target = Location(1300, 800)},
        {action = "touchMove", target = Location(1300, 400)},
        {action = "touchUp", target = Location(1300, 400)},
        {action = "wait", target = interval}
    })

    -- 找戰鬥圖示
    result = exists("戰鬥.png")
    if result == nil then
        -- 關閉行情介面    
        click(findImage("行情.png", Region(2189, 814, 89, 87)))
        wait(interval)
        result = exists("戰鬥.png")
    end
    -- 戰鬥
    click(result)
    wait(interval)
    -- 前往  
    result = exists("前往.png")
    click(result)
    wait(interval)

    -- 等到打完
    click(sailTil("回報.png", Region(1819, 749, 101, 189)))
    manualTouch({
        {action = "touchDown", target = Location(1360, 700)},
        {action = "touchUp", target = Location(1360, 700)},
        {action = "wait", target = interval},
        {action = "touchDown", target = Location(1360, 700)},
        {action = "touchUp", target = Location(1360, 700)},
        {action = "wait", target = interval}
    })

    -- 找委託介紹人
    click(findInMap("航海委託.png"))
    wait(interval)

end
