-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)

function openMap()
    toast("openMap")
    manualTouch({
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = 1 }
    })
end

function findImage(image, region)
    result = nil
    while result == nil do
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image)
        wait(1)
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

pop1 = Location(110, 160)
sell1 = Location(210, 190)
pop2 = Location(110, 300)
sell2 = Location(210, 320)
pop3 = Location(110, 430)
sell3 = Location(210, 450)

-- 設定
dialogInit()
addTextView("跑哪個流行")
addRadioGroup("targetPop", 1)
addRadioButton("流行1", 1)
addRadioButton("流行2", 2)
addRadioButton("流行3", 3)
newRow()
addTextView("買的地點位移")
addEditNumber("offsetX", 0)
addEditNumber("offsetY", 70)
dialogShow("設定")

if targetPop == 1 then
    pop = pop1
    sell = sell1
elseif targetPop == 2 then
    pop = pop2
    sell = sell2
else
    pop = pop3
    sell = sell3
end

while true do
    -- 小地圖
    openMap()

    -- 點行情
    click(findImage("1.png", Region(2187, 814, 93, 80)))
    wait(1)

    click(pop)
    wait(1)

    -- 找可採購港口
    match = findImage("2.png", Region(1793, 287, 520, 442))
    match:setTargetOffset(offsetX, offsetY)
    click(match)
    wait(1)
    click(match)
    wait(1)

    -- 找前往
    click(findImage("3.png", Region(809, 288, 930, 464)))
    wait(10)

    -- 到交易所買
    click(findImage("4.png", Region(1832, 971, 63, 55)))
    -- 點流行品
    click(findImage("5.png", Region(46, 190, 579, 537)))
    -- 買入
    makeDeal()

    -- 移動到賣的地方
    openMap()
    -- 點行情
    click(findImage("1.png", Region(2187, 814, 93, 80)))
    wait(1)
    click(sell)
    wait(1)
    -- 找前往
    click(findImage("3.png", Region(809, 288, 930, 464)))
    wait(10)

    click(findImage("6.png", Region(1834, 868, 63, 51)))
    wait(1)
    click(Location(535, 990))
    wait(1)
    makeDeal()
    wait(1)
end
