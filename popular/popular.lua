-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(15, 1)

interval = 1

function findInMap(image)
    toast(string.format("findInMap(%s)", image))

    -- 小地圖
    manualTouch({
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = interval }
    })

    repeat
        -- 先滑到上面
        manualTouch({
            { action = "touchDown", target = Location(1200, 100) },
            { action = "touchMove", target = Location(1200, 600) },
            { action = "touchUp",   target = Location(1200, 600) },
            { action = "wait",      target = interval }
        })
        result = exists(image)
        if result == nil then -- 找不到的話，滑到下面找
            manualTouch({
                { action = "touchDown", target = Location(1200, 900) },
                { action = "touchMove", target = Location(1200, 100) },
                { action = "touchUp",   target = Location(1200, 100) },
                { action = "wait",      target = interval }
            })
            result = exists(image)
        end
        wait(findImageWait)
    until result ~= nil

    toast(string.format("found %s", image))
    return getLastMatch()
end

function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))

    repeat
        result = region:exists(image)
        wait(findImageWait)
    until result ~= nil

    toast(string.format("found %s", image))
    return region:getLastMatch()
end

function sailTil(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))

    repeat
        manualTouch({
            { action = "touchDown", target = Location(1370, 700) },
            { action = "touchUp",   target = Location(1370, 700) },
            { action = "wait",      target = interval }
        })
        result = region:exists(image, findImageWait)
        wait(5)
    until result ~= nil

    toast(string.format("found %s", image))
    return region:getLastMatch()
end

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
addEditNumber("findImageWait", 10)
dialogShow("設定")

pop = buyTable[targetPop]
sell = sellTable[targetPop]

while true do
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
    wait(25)

    -- 到交易所買
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
    wait(25)

    -- 到交易所賣
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
    click(findInMap("bar.png"))
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
