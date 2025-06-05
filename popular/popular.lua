-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 1

regionSail = Region(1300, 630, 300, 280)
regionGoods = Region(45, 95, 580, 660)

-- 找圖
function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))

    repeat
        result = region:exists(image)
        wait(findImageInterval)
    until result ~= nil

    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 找交易品
function findGoods(image)
    toast(string.format("findGoods(%s)", image))
    result = regionGoods:exists(image)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            { action = "touchDown", target = Location(340, 560) },
            { action = "touchMove", target = Location(340, 400) },
            { action = "touchUp",   target = Location(340, 400) },
            { action = "wait",      target = interval }
        })
        result = regionGoods:exists(image)
    end
    if result ~= nil then
        toast(string.format("found %s", image))
        return regionGoods:getLastMatch()
    else
        return nil
    end
end

-- 航行到指定圖為止，過程中會一直找操帆點擊
function sailTil(image, region)
    toast(string.format("sailTil(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
    repeat
        regionSail:existsClick("sail.png")
        result = region:exists(image)
        wait(findImageInterval)
    until result ~= nil
    toast(string.format("found %s", image))
    return region:getLastMatch()
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

buyTable = {}
buyTable[0] = Location(110, 160)
buyTable[1] = Location(110, 300)
buyTable[2] = Location(110, 430)

sellTable = {}
sellTable[0] = Location(210, 190)
sellTable[1] = Location(210, 320)
sellTable[2] = Location(210, 450)

-- 設定
dialogInit()
addTextView("跑哪個流行")
addRadioGroup("targetPop", 0)
addRadioButton("流行1", 0)
addRadioButton("流行2", 1)
addRadioButton("流行3", 2)
newRow()
addTextView("買的地點位移")
addEditNumber("offsetX", 0)
addEditNumber("offsetY", 70)
newRow()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
newRow()
addCheckBox("drink", "喝酒", true)
newRow()
addTextView("執行幾次")
addEditNumber("executeTimes", 50)
dialogShow("設定")

pop = buyTable[targetPop]
sell = sellTable[targetPop]

round = 0
while round < executeTimes do
    executeTimes = executeTimes + 1
    toast(string.format("Round %s", round))

    -- 點要買的東西
    manualTouch({
        -- 小地圖
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = interval },
        -- 行情
        { action = "touchDown", target = Location(2220, 860) },
        { action = "touchUp",   target = Location(2220, 860) },
        { action = "wait",      target = interval },
        -- 要買的東西
        { action = "touchDown", target = pop },
        { action = "touchUp",   target = pop },
        { action = "wait",      target = interval }
    })

    -- 找可採購港口
    match = findImage("2.png", Region(1793, 287, 520, 442))
    match:setTargetOffset(offsetX, offsetY)
    click(match)
    wait(interval)

    -- 前往
    click(findImage("3.png", Region(960, 240, 600, 600)))
    wait(10)
    -- 航行到交易所
    click(sailTil("4.png", Region(1832, 971, 63, 55)))
    -- 點流行品
    click(findImage("5.png", Region(46, 190, 579, 537)))
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
        -- 要買的東西
        { action = "touchDown", target = sell },
        { action = "touchUp",   target = sell },
        { action = "wait",      target = interval }
    })

    -- 前往
    click(findImage("3.png", Region(960, 240, 600, 600)))
    wait(10)
    -- 航行到交易所
    click(sailTil("6.png", Region(1834, 868, 63, 51)))
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
        manualTouch({
            -- 點小地圖
            { action = "touchDown", target = Location(2130, 220) },
            { action = "touchUp",   target = Location(2130, 220) },
            { action = "wait",      target = interval },
            -- 先滑到上面
            { action = "touchDown", target = Location(1200, 100) },
            { action = "touchMove", target = Location(1200, 600) },
            { action = "touchUp",   target = Location(1200, 600) },
            { action = "wait",      target = interval }
        })
        -- 找酒館或休息站
        result = exists("bar.png")
        if result == nil then
            result = exists("inn.png")
        end
        if result == nil then -- 兩個找不到的話，滑到下面找
            manualTouch({
                { action = "touchDown", target = Location(1200, 900) },
                { action = "touchMove", target = Location(1200, 100) },
                { action = "touchUp",   target = Location(1200, 100) },
                { action = "wait",      target = interval }
            })
            result = exists("bar.png")
            if result == nil then
                result = exists("inn.png")
            end
        end
        -- 完全找不到就不喝酒了
        if result == nil then
            toast("not found, quit drink step")
            break
        end
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
            { action = "wait",      target = interval }
        })
    end
end

print(string.format("Total rounds %s", round))
