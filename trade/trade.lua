-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
tmpFile = "tmp.png"
backFile = "tmp2.png"
regionTarget = Region(174, 44, 134, 40)

-- 收藏品定位
collectTable = {}
collectTable[0] = Location(240, 160)
collectTable[1] = Location(400, 160)
collectTable[2] = Location(560, 160)
collectTable[3] = Location(240, 360)
collectTable[4] = Location(400, 360)
collectTable[5] = Location(560, 360)
collectTextTable = {}
collectTextTable[0] = Region(200, 55, 80, 20)
collectTextTable[1] = Region(350, 55, 80, 20)
collectTextTable[2] = Region(505, 55, 80, 20)
collectTextTable[3] = Region(200, 260, 80, 20)
collectTextTable[4] = Region(350, 260, 80, 20)
collectTextTable[5] = Region(505, 260, 80, 20)

-- 海域位置
areas = {}
areas[0] = "北海"
areas[1] = "北大西洋" 
areas[2] = "西地中海" 
areas[3] = "東地中海" 
areas[4] = "非洲西岸" 
areas[5] = "加勒比" 
areas[6] = "中南美" 

cities = {}
cities[1] = {}
cities[1][0] = "bordeaux.png"
cities[2] = {}
cities[2][0] = "seville.png"
cities[3] = {}
cities[3][0] = "alexander.png"
cities[3][1] = "benghazi.png"
cities[3][2] = "cairo.png"
cities[3][3] = "famagusta.png"

-- 找圖
function findImage(image, region)
    toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
    result = region:exists(image)
    while result == nil do
        wait(findImageInterval)
        toast(string.format("findImage(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        result = region:exists(image)
    end
    return region:getLastMatch()
end

-- 航行到指定圖為止，過程中會一直找操帆點擊
function sailTil(image, region)
    regionSail = Region(1300, 630, 300, 280)
    repeat
        wait(findImageInterval)
        toast(string.format("sailTil(%s, [%s,%s,%s,%s])", image, region.x, region.y, region.w, region.h))
        regionSail:existsClick("sail.png")
        regionSail:existsClick("boating.png")
        result = region:exists(image)
    until result ~= nil
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

-- 找交易品
function findGoods(image)
    regionGoods = Region(45, 95, 580, 660)
    toast(string.format("findGoods(%s)", image))
    imagePattern = Pattern(image):similar(0.8)
    result = regionGoods:exists(imagePattern)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            { action = "touchDown", target = Location(340, 560) },
            { action = "touchMove", target = Location(340, 400) },
            { action = "touchUp",   target = Location(340, 400) },
            { action = "wait",      target = interval }
        })
        result = regionGoods:exists(imagePattern)
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

-- 找指定港口
function findPort(place)
    regionPort = Region(1827, 345, 195, 515)
    result = regionPort:exists(place)
    while result == nil do
        toast(string.format("findPort(%s)", place))
        manualTouch({
            { action = "touchDown", target = Location(2033, 400) },
            { action = "touchMove", target = Location(2033, 800) },
            { action = "touchUp",   target = Location(2033, 800) },
            { action = "wait",      target = interval },
            { action = "touchDown", target = Location(2033, 400) },
            { action = "touchMove", target = Location(2033, 800) },
            { action = "touchUp",   target = Location(2033, 800) },
            { action = "wait",      target = interval }
        })
        result = regionPort:exists(place)
        if result == nil then
            manualTouch({
                { action = "touchDown", target = Location(2033, 800) },
                { action = "touchMove", target = Location(2033, 400) },
                { action = "touchUp",   target = Location(2033, 400) },
                { action = "wait",      target = interval }
            })
            result = regionPort:exists(place)
            if result == nil then
                manualTouch({
                    { action = "touchDown", target = Location(2033, 800) },
                    { action = "touchMove", target = Location(2033, 400) },
                    { action = "touchUp",   target = Location(2033, 400) },
                    { action = "wait",      target = interval }
                })
                result = regionPort:exists(place)
            end
        end
        wait(findImageInterval)
    end
    return result
end

-- 前往選中的港口
function goToPort()
    region = Region(960, 240, 600, 600)
    if region:exists("here.png") then
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
    if drink then
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
end

-- 打開收藏品介面
function openCollect()
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
end

-- 移動到指定收藏品要出售的港
function sellCollect(collect, area, type, port)
    -- 打開收藏品介面
    openCollect()
    -- 指定收藏品
    click(collectTable[collect])
    wait(interval)
    manualTouch({
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
    click(findImage(areas[area], Region(1940, 426, 212, 439)))
    wait(interval)
        -- 指定的港口
    if type == 0 then
    -- 依價格
        click(Location(1883, 380 + (port * 75)))
        wait(interval)
        click(Location(1883, 380 + (port * 75)))
    else
    -- 指定港口名稱
        res = findPort(cities[area][port])
        click(res)
        wait(interval)
        click(res)
    end
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
end

-- 設定
dialogInit()
addRadioGroup("buyIndex", 0)
addRadioButton("1", 0)
addRadioButton("2", 1)
addRadioButton("3", 2)
addRadioButton("4", 3)
addRadioButton("5", 4)
addRadioButton("6", 5)
dialogShow("買第幾個收藏品")
dialogInit()
addRadioGroup("buyPort", 1)
addRadioButton("1", 1)
addRadioButton("2", 2)
addRadioButton("3", 3)
addRadioButton("4", 4)
addRadioButton("5", 5)
addRadioButton("6", 6)
dialogShow("第幾個採購港")

-- 出售設定
dialogInit()
addRadioGroup("sellArea", 0)
for i, name in pairs(areas) do
    addRadioButton(name, i)
end
dialogShow("在哪個海域賣出")
dialogInit()
addRadioGroup("sellType", 0)
addRadioButton("依價格", 0)
addRadioButton("指定港口", 1)
dialogShow("出售港依據")
if sellType == 0 then
    dialogInit()
    addRadioGroup("sellPort", 0)
    addRadioButton("1", 0)
    addRadioButton("2", 1)
    addRadioButton("3", 2)
    addRadioButton("4", 3)
    addRadioButton("5", 4)
    addRadioButton("6", 5)
    dialogShow("第幾個出售港")
else
    dialogInit()
    if areas[sellArea] == "北大西洋" then
        addRadioGroup("sellPort", 0)
        addRadioButton("波爾多", 0)
    elseif areas[sellArea] == "西地中海" then
        addRadioGroup("sellPort", 0)
        addRadioButton("塞維利亞", 0)
    elseif areas[sellArea] == "東地中海" then
        addRadioGroup("sellPort", 0)
        addRadioButton("亞歷山大", 0)
        addRadioButton("班加西", 1)
        addRadioButton("開羅", 2)
        addRadioButton("法馬古斯塔", 3)
    end
    dialogShow("哪個出售港")
end

dialogInit()
addCheckBox("backTrade", "回程買交易品", false)
dialogShow("回程設定")
if backTrade then
    dialogInit()
    addRadioGroup("buyIndex2", 0)
    addRadioButton("1", 0)
    addRadioButton("2", 1)
    addRadioButton("3", 2)
    addRadioButton("4", 3)
    addRadioButton("5", 4)
    addRadioButton("6", 5)
    dialogShow("回程買第幾個收藏品")
    dialogInit()
    addRadioGroup("buyPort2", 1)
    addRadioButton("1", 1)
    addRadioButton("2", 2)
    addRadioButton("3", 3)
    addRadioButton("4", 4)
    addRadioButton("5", 5)
    addRadioButton("6", 6)
    dialogShow("第幾個採購港")
    dialogInit()
    addRadioGroup("sellArea2", 0)
    addRadioButton("中南美", 0)
    addRadioButton("北大西洋", 1)
    addRadioButton("北海", 2)
    addRadioButton("西地中海", 3)
    addRadioButton("東地中海", 4)
    addRadioButton("非洲西岸", 5)
    addRadioButton("加勒比", 6)
    dialogShow("在哪個海域賣出")
    dialogInit()
    addRadioGroup("sellType2", 0)
    addRadioButton("依價格", 0)
    addRadioButton("指定港口", 1)
    dialogShow("出售港依據")
    if sellType2 == 0 then
        dialogInit()
        addRadioGroup("sellPort2", 0)
        addRadioButton("1", 0)
        addRadioButton("2", 1)
        addRadioButton("3", 2)
        addRadioButton("4", 3)
        addRadioButton("5", 4)
        addRadioButton("6", 5)
        dialogShow("第幾個出售港")
    else
        dialogInit()
        if sellArea == 1 then
            addRadioGroup("sellPort2", 0)
            addRadioButton("波爾多", 0)
        elseif sellArea == 3 then
            addRadioGroup("sellPort2", 0)
            addRadioButton("塞維利亞", 0)
        elseif sellArea == 4 then
            addRadioGroup("sellPort2", 0)
            addRadioButton("亞歷山大", 0)
            addRadioButton("班加西", 1)
            addRadioButton("開羅", 2)
            addRadioButton("法馬古斯塔", 3)
        end
        dialogShow("哪個港")
    end
end

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

    -- 找收藏品
    openCollect()
    -- 拍下交易品特徵
    collectTextTable[buyIndex]:save(tmpFile)
    -- 點交易品
    click(collectTable[buyIndex])
    wait(interval)
    -- 找可採購港口
    match = findImage("port.png", Region(1793, 287, 520, 442))
    match:setTargetOffset(0, buyPort * 65)
    click(match)
    wait(interval)
    -- 前往
    goToPort()
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
    -- 喝酒
    goDrink()
    -- 到指定港口賣出
    sellCollect(buyIndex, sellArea, sellType, sellPort)

    -- 回程
    if backTrade then
        -- 找收藏品
        openCollect()
        -- 拍下交易品特徵
        collectTextTable[buyIndex2]:save(backFile)
        -- 點交易品
        click(collectTable[buyIndex2])
        wait(interval)
        -- 找可採購港口
        match = findImage("port.png", Region(1793, 287, 520, 442))
        match:setTargetOffset(0, buyPort2 * 65)
        click(match)
        wait(interval)
        -- 前往
        goToPort()
        -- 航行到交易所
        click(sailTil("buy.png", Region(1832, 971, 63, 55)))
        -- 找到目標交易品
        result = findGoods(backFile)
        if result == nil then
            print(string.format("Can't find goods %s", backFile2))
            break
        end
        click(result)
        -- 買入
        makeDeal()
        -- 喝酒
        goDrink()
        -- 到指定港口賣出
        sellCollect(buyIndex2, sellArea2, sellType2, sellPort2)
    end
end

print(string.format("Total rounds %s", round))
