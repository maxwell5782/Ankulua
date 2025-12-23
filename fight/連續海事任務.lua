-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 1
findImageInterval = 5

-- 任務欄範圍
regionMission = Region(38, 93, 595, 737)
regTalk = Region(1819, 591, 101, 353)

-- 可用任務0=團隊任務,1=一般任務,2=14任務
missions = {}
missions[0] = {}
missions[0][0] = "韋拉二連.png"
missions[0][1] = 0
missions[1] = {}
missions[1][0] = "韋拉地靈.png"
missions[1][1] = 1
missions[2] = {}
missions[2][0] = "韋拉水妖.png"
missions[2][1] = 1
missions[3] = {}
missions[3][0] = "韋拉尾帆.png"
missions[3][1] = 1
missions[4] = {}
missions[4][0] = "韋拉接板.png"
missions[4][1] = 1
missions[5] = {}
missions[5][0] = "開普研究室.png"
missions[5][1] = 1
missions[6] = {}
missions[6][0] = "聖多會議室.png"
missions[6][1] = 1
missions[7] = {}
missions[7][0] = "聖多地靈.png"
missions[7][1] = 1

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

-- 喝酒
function goDrink()
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
    -- 找酒館或休息站
    result = exists("bar.png", AutoWaitTimeout)
    if result == nil then result = exists("inn.png", AutoWaitTimeout) end
    if result == nil then -- 兩個找不到的話，滑到下面找
        manualTouch({
            {action = "touchDown", target = Location(1200, 900)},
            {action = "touchMove", target = Location(1200, 200)},
            {action = "touchUp", target = Location(1200, 200)},
            {action = "wait", target = interval}
        })
        result = exists("bar.png", AutoWaitTimeout)
        if result == nil then result = exists("inn.png", AutoWaitTimeout) end
    end
    -- 完全找不到就不喝酒了
    if result ~= nil then
        toast("found")
        -- 有找到，去酒館喝酒
        click(getLastMatch())
        manualTouch({
            {action = "wait", target = 15},
            {action = "touchDown", target = Location(265, 720)},
            {action = "wait", target = 2.5},
            {action = "touchUp", target = Location(265, 720)},
            {action = "wait", target = interval},
            {action = "touchDown", target = Location(1940, 900)},
            {action = "touchUp", target = Location(1940, 900)},
            {action = "wait", target = interval},
            {action = "touchDown", target = Location(1940, 700)},
            {action = "touchUp", target = Location(1940, 700)},
            {action = "wait", target = interval},
            {action = "touchDown", target = Location(1940, 700)},
            {action = "touchUp", target = Location(1940, 700)},
            {action = "wait", target = interval},
            {action = "touchDown", target = Location(1940, 700)},
            {action = "touchUp", target = Location(1940, 700)},
            {action = "wait", target = interval}
        })
    end
end

dialogInit()
addTextView("任務")
addRadioGroup("missionIndex", 0)
for i, mission in pairs(missions) do addRadioButton(mission[0], i) end
newRow()
addTextView("相似度")
addEditNumber("MinSimilarity", 0.9)
dialogShow("")

Settings:set("MinSimilarity", MinSimilarity)

while true do
    -- 點委託任務
    click(findImage("委託任務.png", regTalk))
    wait(interval)

    -- 找指定任務
    result = regionMission:exists(missions[missionIndex][0])
    wait(interval)
    -- 找不到的話，點更新任務
    while result == nil do
        click(findImage("更新任務.png", Region(257, 957, 146, 43)))
        wait(interval)
        result = regionMission:exists(missions[missionIndex][0])
    end

    -- 接任務
    click(result)
    wait(interval)
    -- 接受
    click(findImage("接受.png", Region(1979, 944, 79, 40)))
    wait(interval)
    -- 關閉委託介面
    manualTouch({
        {action = "touchDown", target = Location(1360, 300)},
        {action = "touchUp", target = Location(1360, 300)},
        {action = "wait", target = interval},
        {action = "touchDown", target = Location(2100, 650)}, -- 追蹤任務
        {action = "touchUp", target = Location(2100, 650)},
        {action = "wait", target = interval}
    })

    goDrink()

    -- 移到任務地點
    manualTouch({
        {action = "touchDown", target = Location(2100, 490)},
        {action = "touchUp", target = Location(2100, 490)},
        {action = "wait", target = interval}
    })
    click(findImage("前往.png", Region(0, 0, 2340, 1080)))
    wait(interval)

    -- 等到打完
    sailTil("回報.png", regTalk)

    -- 如果接的任務要回報
    if missions[missionIndex][1] >= 1 then
        click(findImage("回報.png", regTalk))
        manualTouch({
            {action = "touchDown", target = Location(1360, 700)},
            {action = "touchUp", target = Location(1360, 700)},
            {action = "wait", target = interval},
            {action = "touchDown", target = Location(1360, 700)},
            {action = "touchUp", target = Location(1360, 700)},
            {action = "wait", target = interval}
        })
    end

    if missions[missionIndex][1] == 2 then
        -- 14特別流程
        -- 點公會
        click(findInMap("公會.png"))
        wait(6)
        manualTouch({
            {action = "touchDown", target = Location(1200, 200)},
            {action = "touchMove", target = Location(1450, 200)},
            {action = "touchUp", target = Location(1450, 200)},
            {action = "wait", target = interval}
        })
        -- 點委託介紹人
        match = findImage("委託介紹人.png", Region(1232, 188, 740, 250))
        match:setTargetOffset(0, 100)
        click(match)
    else
        -- 找委託介紹人
        click(findInMap("航海委託.png"))
        wait(interval)
    end

end
