-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.8)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
tmpFile = "tmp.png"
regionTarget = Region(174, 44, 134, 40)

-- 找圖
function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
    result = region:exists(image)
    while result == nil do
        wait(findImageInterval)
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image)
    end
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 航行到指定圖為止，過程中會一直找操帆點擊
function sailTil(image, region)
    regionSail = Region(1300, 630, 300, 280)
    repeat
        wait(findImageInterval)
        toast(string.format("sailTil(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        matches = regionFindAllNoFindException(regionSail, Pattern("sail.png"):similar(0.5))
        for i, m in ipairs(matches) do
            click(m)
        end
        result = region:exists(image)
    until result ~= nil
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 找交易品
function findGoods(image)
    regionGoods = Region(45, 95, 580, 660)
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
    result = exists("bar.png")
    if result == nil then
        result = exists("inn.png")
    end
    if result == nil then -- 兩個找不到的話，滑到下面找
        manualTouch({
            { action = "touchDown", target = Location(1200, 900) },
            { action = "touchMove", target = Location(1200, 200) },
            { action = "touchUp",   target = Location(1200, 200) },
            { action = "wait",      target = interval }
        })
        result = exists("bar.png")
        if result == nil then
            result = exists("inn.png")
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

-- 海域位置
sellAreas = {}
sellAreas[0] = Location(2050, 450) -- 中南美
sellAreas[1] = Location(2050, 510) -- 北大西洋
sellAreas[2] = Location(2050, 570) -- 北海
sellAreas[3] = Location(2050, 630) -- 西地中海
sellAreas[4] = Location(2050, 690) -- 東地中海
sellAreas[5] = Location(2050, 750) -- 非洲西岸
sellAreas[6] = Location(2050, 810) -- 加勒比

-- 設定
dialogInit()
addRadioGroup("offsetY", 1)
addRadioButton("1", 1)
addRadioButton("2", 2)
addRadioButton("3", 3)
addRadioButton("4", 4)
addRadioButton("5", 5)
addRadioButton("6", 6)
dialogShow("第幾個採購港")

dialogInit()
addRadioGroup("sellArea", 0)
addRadioButton("中南美", 0)
addRadioButton("北大西洋", 1)
addRadioButton("北海", 2)
addRadioButton("西地中海", 3)
addRadioButton("東地中海", 4)
addRadioButton("非洲西岸", 5)
addRadioButton("加勒比", 6)
dialogShow("在哪個海域賣出")

dialogInit()
addRadioGroup("sellIndex", 0)
addRadioButton("1", 0)
addRadioButton("2", 1)
addRadioButton("3", 2)
addRadioButton("4", 3)
addRadioButton("5", 4)
addRadioButton("6", 5)
dialogShow("第幾個出售港")

dialogInit()
addCheckBox("drink", "喝酒", true)
addCheckBox("towage", "拖航到購買點", false)
newRow()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
newRow()
addTextView("執行次數")
addEditNumber("executeTimes", 50)
dialogShow("執行設定")

round = 0
while round < executeTimes do
    round = round + 1
    toast(string.format("Round %s", round))

    -- 找收藏的第一個交易品
    manualTouch({
        -- 小地圖
        { action = "touchDown", target = Location(2130, 220) },
        { action = "touchUp",   target = Location(2130, 220) },
        { action = "wait",      target = interval },
        -- 行情
        { action = "touchDown", target = Location(2220, 860) },
        { action = "touchUp",   target = Location(2220, 860) },
        { action = "wait",      target = interval },
        -- 貨品分類
        { action = "touchDown", target = Location(526, 992) },
        { action = "touchUp",   target = Location(526, 992) },
        { action = "wait",      target = interval }
    })

    -- 拍下交易品特徵
    regionTarget:save(tmpFile)

    -- 點交易品
    manualTouch({
        { action = "touchDown", target = Location(240, 160) },
        { action = "touchUp",   target = Location(240, 160) },
        { action = "wait",      target = interval }
    })

    -- 找可採購港口
    match = findImage("port.png", Region(1793, 287, 520, 442))
    match:setTargetOffset(0, offsetY * 65)
    click(match)
    wait(interval)

    -- 前往
    if towage then
        -- 拖航過去
        click(findImage("towage.png", Region(960, 240, 600, 600)))
        click(findImage("confirm.png", Region(960, 240, 600, 600)))
    else
        -- 開過去
        click(findImage("go.png", Region(960, 240, 600, 600)))
    end
    -- 航行到交易所
    click(sailTil("buy.png", Region(1832, 971, 63, 55)))
    -- 找到目標交易品
    result = findGoods(tmpFile)
    if result == nil then
        print(string.format("Can't find goods %s", tmpFile))
        break
    end
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
        -- 貨品分類
        { action = "touchDown", target = Location(526, 992) },
        { action = "touchUp",   target = Location(526, 992) },
        { action = "wait",      target = interval },
        -- 收藏品第一個
        { action = "touchDown", target = Location(240, 160) },
        { action = "touchUp",   target = Location(240, 160) },
        { action = "wait",      target = interval },
        -- 出售
        { action = "touchDown", target = Location(2170, 990) },
        { action = "touchUp",   target = Location(2170, 990) },
        { action = "wait",      target = interval },
        -- 海域
        { action = "touchDown", target = Location(2050, 900) },
        { action = "touchUp",   target = Location(2050, 900) },
        { action = "wait",      target = interval }
    })
    -- 指定的海域
    click(sellAreas[sellArea])
    wait(interval)
    -- 指定的出售港
    click(Location(1883, 380 + (sellIndex * 75)))
    wait(interval)

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
