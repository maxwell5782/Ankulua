-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)

function findImage(image, region)
    result = nil
    while result == nil do
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image)
        wait(findImageWait)
    end
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

function makeDeal()
    manualTouch({
        { action = "touchDown", target = Location(2020, 960) },
        { action = "touchUp",   target = Location(2020, 960) },
        { action = "wait",      target = 1 },
        { action = "touchDown", target = Location(1900, 960) },
        { action = "touchUp",   target = Location(1900, 960) },
        { action = "wait",      target = 1 },
        { action = "touchDown", target = Location(1900, 960) },
        { action = "touchUp",   target = Location(1900, 960) },
        { action = "wait",      target = 1 },
        { action = "touchDown", target = Location(2140, 960) },
        { action = "touchUp",   target = Location(2140, 960) },
        { action = "wait",      target = 1 }
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
        { action = "wait",      target = 1 },
            -- 行情
        { action = "touchDown", target = Location(2220, 860) },
        { action = "touchUp",   target = Location(2220, 860) },
        { action = "wait",      target = 1 },
            -- 要買的東西
        { action = "touchDown", target = pop },
        { action = "touchUp",   target = pop },
        { action = "wait",      target = 1 }
    })

    -- 找可採購港口
    match = findImage("2.png", Region(1793, 287, 520, 442))
    match:setTargetOffset(offsetX, offsetY)
    click(match)
    wait(1)

    -- 前往
    manualTouch({
        { action = "touchDown", target = Location(1390, 520) },
        { action = "touchUp",   target = Location(1390, 520) },
        { action = "wait",      target = 10 }
    })

    -- 到交易所買
    click(findImage("4.png", Region(1832, 971, 63, 55)))
    -- 點流行品
    click(findImage("5.png", Region(46, 190, 579, 537)))
    -- 買入
    makeDeal()

    -- 移動到賣的地方
    manualTouch({
            -- 小地圖
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = 1 },
            -- 行情
        { action = "touchDown", target = Location(2220, 860) },
        { action = "touchUp",   target = Location(2220, 860) },
        { action = "wait",      target = 1 },
            -- 要買的東西
        { action = "touchDown", target = sell },
        { action = "touchUp",   target = sell },
        { action = "wait",      target = 1 }
    })
    -- 前往
    manualTouch({
        { action = "touchDown", target = Location(1390, 520) },
        { action = "touchUp",   target = Location(1390, 520) },
        { action = "wait",      target = 10 }
    })

    -- 到交易所賣
    click(findImage("6.png", Region(1834, 868, 63, 51)))
    manualTouch({
        { action = "wait",      target = 1 },
            -- 全賣
        { action = "touchDown", target = Location(535, 990) },
        { action = "touchUp",   target = Location(535, 990) },
        { action = "wait",      target = 1 }
    })
    makeDeal()
    wait(1)
end
