-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
AutoWaitTimeout = 1
tmpFile = "tmp.png"
charWidth = 28
charHeight = 26

-- 流行品文字的範圍
popTable = {}
popTable[0] = Location(172, 121)
popTable[1] = Location(172, 252)
popTable[2] = Location(172, 384)
buyTable = {}
buyTable[0] = Location(110, 160)
buyTable[1] = Location(110, 300)
buyTable[2] = Location(110, 430)
sellTable = {}
sellTable[0] = Location(210, 190)
sellTable[1] = Location(210, 320)
sellTable[2] = Location(210, 450)

-- 找圖
function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
    result = region:exists(image, AutoWaitTimeout)
    while result == nil do
        wait(findImageInterval)
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image, AutoWaitTimeout)
    end
    return region:getLastMatch()
end

-- 航行到指定圖為止，過程中會一直找操帆點擊
function sailTil(image, region)
    regionSail = Region(1300, 630, 300, 280)
    repeat
        wait(findImageInterval)
        toast(string.format("sailTil(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        regionSail:existsClick("sail.png", AutoWaitTimeout)
        regionSail:existsClick("boating.png", AutoWaitTimeout)
        result = region:exists(image, AutoWaitTimeout)
    until result ~= nil
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 找交易品
function findGoods(image)
    regionGoods = Region(45, 95, 580, 660)
    toast(string.format("findGoods(%s)", image))
    imagePattern = Pattern(image):similar(0.8)
    result = regionGoods:exists(imagePattern, AutoWaitTimeout)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            { action = "touchDown", target = Location(340, 560) },
            { action = "touchMove", target = Location(340, 400) },
            { action = "touchUp",   target = Location(340, 400) },
            { action = "wait",      target = interval }
        })
        result = regionGoods:exists(imagePattern, AutoWaitTimeout)
    end
    if result ~= nil then
        return regionGoods:getLastMatch()
    else
        return nil
    end
end

-- 在小地圖中找圖
function findInMap(place)
    toast(string.format("findInMap(%s)", place))
    manualTouch({
        -- 點小地圖
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = interval },
        -- 先滑到上面
        { action = "touchDown", target = Location(1200, 100) },
        { action = "touchMove", target = Location(1200, 500) },
        { action = "touchUp",   target = Location(1200, 500) },
        { action = "wait",      target = interval }
    })
    -- 找目標圖示
    result = exists(place)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            { action = "touchDown", target = Location(1200, 900) },
            { action = "touchMove", target = Location(1200, 200) },
            { action = "touchUp",   target = Location(1200, 200) },
            { action = "wait",      target = interval }
        })
        result = exists(place)
    end
    return result
end

-- 前往選中的港口
function goToPort()
    region = Region(960, 240, 600, 600)
    if region:exists("here.png", AutoWaitTimeout) then
        click(Location(2271, 47))
    else
        if towage then
            -- 拖航過去
            click(findImage("towage.png", region))
            click(findImage("confirm.png", region))
        else
            -- 開過去
            click(findImage("go.png", region))
        end
    end
end

-- 交易-喊價-成交
function makeDeal()
    manualTouch({
        { action = "touchDown", target = Location(2020, 960) },
        { action = "touchUp",   target = Location(2020, 960) },
        { action = "wait",      target = interval },
        { action = "touchDown", target = Location(1900, 960) },
        { action = "touchUp",   target = Location(1900, 960) },
        { action = "wait",      target = interval },
        { action = "touchDown", target = Location(1900, 960) },
        { action = "touchUp",   target = Location(1900, 960) },
        { action = "wait",      target = interval },
        { action = "touchDown", target = Location(2140, 960) },
        { action = "touchUp",   target = Location(2140, 960) },
        { action = "wait",      target = interval }
    })
end

-- 喝酒
function goDrink()
    manualTouch({
        -- 點小地圖
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = interval },
        -- 先滑到上面
        { action = "touchDown", target = Location(1200, 100) },
        { action = "touchMove", target = Location(1200, 500) },
        { action = "touchUp",   target = Location(1200, 500) },
        { action = "wait",      target = interval }
    })
    -- 找酒館或休息站
    result = exists("bar.png", AutoWaitTimeout)
    if result == nil then
        result = exists("inn.png", AutoWaitTimeout)
    end
    if result == nil then -- 兩個找不到的話，滑到下面找
        manualTouch({
            { action = "touchDown", target = Location(1200, 900) },
            { action = "touchMove", target = Location(1200, 200) },
            { action = "touchUp",   target = Location(1200, 200) },
            { action = "wait",      target = interval }
        })
        result = exists("bar.png", AutoWaitTimeout)
        if result == nil then
            result = exists("inn.png", AutoWaitTimeout)
        end
    end
    -- 完全找不到就不喝酒了
    if result ~= nil then
        toast("found")
        -- 有找到，去酒館喝酒
        click(getLastMatch())
        manualTouch({
            -- 等待走到酒館
            { action = "wait",      target = 15 },
            -- 走到酒保位
            { action = "touchDown", target = Location(265, 720) },
            { action = "wait",      target = 2.5 },
            { action = "touchUp",   target = Location(265, 720) },
            { action = "wait",      target = interval },
            -- 請客
            { action = "touchDown", target = Location(1940, 1000) },
            { action = "touchUp",   target = Location(1940, 1000) },
            { action = "wait",      target = interval },
            -- 請客
            { action = "touchDown", target = Location(1940, 790) },
            { action = "touchUp",   target = Location(1940, 790) },
            { action = "wait",      target = interval },
            -- 請客
            { action = "touchDown", target = Location(1940, 790) },
            { action = "touchUp",   target = Location(1940, 790) },
            { action = "wait",      target = interval }
        })
    end
end

-- 設定
dialogInit()
addTextView("流行")
addRadioGroup("targetPop", 0)
addRadioButton("1", 0)
addRadioButton("2", 1)
addRadioButton("3", 2)

newRow()
addTextView("採購港")
addRadioGroup("offsetY", 1)
addRadioButton("1", 1)
addRadioButton("2", 2)
addRadioButton("3", 3)
addRadioButton("4", 4)
addRadioButton("5", 5)
addRadioButton("6", 6)

newRow()
addTextView("交易品字數")
addEditNumber("goodChars", 3)

newRow()
addCheckBox("drink", "喝酒", true)
addCheckBox("towage", "拖航到購買點", false)

newRow()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)

newRow()
addTextView("執行次數")
addEditNumber("executeTimes", 50)
dialogShow("")

pop = buyTable[targetPop]
sell = sellTable[targetPop]

round = 0
while round < executeTimes do
    repeat
        round = round + 1
        toast(string.format("Round %s", round))

        -- 點要買的東西
        manualTouch({
            -- 如果在交易所找不到目前的目標物，點這邊關掉交易介面重新找圖
            { action = "touchDown", target = Location(1450, 100) },
            { action = "touchUp",   target = Location(1450, 100) },
            { action = "wait",      target = interval },
            -- 小地圖
            { action = "touchDown", target = Location(2130, 220) },
            { action = "touchUp",   target = Location(2130, 220) },
            { action = "wait",      target = interval },
            -- 行情
            { action = "touchDown", target = Location(2220, 860) },
            { action = "touchUp",   target = Location(2220, 860) },
            { action = "wait",      target = interval }
        })

        -- 截取交易品特徵
        Region(popTable[targetPop].x, popTable[targetPop].y, charWidth * goodChars, charHeight):save(tmpFile)

        manualTouch({
            -- 要買的東西
            { action = "touchDown", target = pop },
            { action = "touchUp",   target = pop },
            { action = "wait",      target = interval }
        })

        -- 找可採購港口
        match = findImage("port.png", Region(1793, 287, 520, 442))
        match:setTargetOffset(0, offsetY * 65)
        click(match)
        wait(interval)
        click(match)
        wait(interval)

        -- 前往
        goToPort()
        -- 航行到交易所
        click(sailTil("buy.png", Region(1832, 971, 63, 55)))
        -- 點流行品
        result = findGoods(tmpFile)
    until result ~= nil
    click(result)
    -- 買入
    makeDeal()

    -- 移動到賣的地方
    manualTouch({
        -- 小地圖
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = interval },
        -- 行情
        { action = "touchDown", target = Location(2220, 860) },
        { action = "touchUp",   target = Location(2220, 860) },
        { action = "wait",      target = interval },
        -- 要賣的東西
        { action = "touchDown", target = sell },
        { action = "touchUp",   target = sell },
        { action = "wait",      target = interval },
        { action = "touchDown", target = sell },
        { action = "touchUp",   target = sell },
        { action = "wait",      target = interval }
    })

    -- 前往
    click(findImage("go.png", Region(960, 240, 600, 600)))
    -- 航行到交易所
    click(sailTil("sell.png", Region(1834, 868, 63, 51)))
    manualTouch({
        { action = "wait",      target = interval },
        -- 全賣
        { action = "touchDown", target = Location(535, 990) },
        { action = "touchUp",   target = Location(535, 990) },
        { action = "wait",      target = interval }
    })
    makeDeal()
    wait(interval)

    -- 喝酒
    if (drink) then
        goDrink()
    end
end

print(string.format("Total rounds %s", round))
