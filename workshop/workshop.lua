-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.8)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
tmpFile = "tmp.png"

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
sellAreas = {}
sellAreas[0] = Location(2050, 450) -- 中南美
sellAreas[1] = Location(2050, 510) -- 北大西洋
sellAreas[2] = Location(2050, 570) -- 北海
sellAreas[3] = Location(2050, 630) -- 西地中海
sellAreas[4] = Location(2050, 690) -- 東地中海
sellAreas[5] = Location(2050, 750) -- 非洲西岸
sellAreas[6] = Location(2050, 810) -- 加勒比

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
function sellCollect()
    -- 打開收藏品介面
    openCollect()
    -- 指定收藏品
    click(collectTable[prodIndex])
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
end

-- 生產設定
dialogInit()
    addRadioGroup("prodIndex", 0)
    addRadioButton("1", 0)
    addRadioButton("2", 1)
    addRadioButton("3", 2)
    addRadioButton("4", 3)
    addRadioButton("5", 4)
    addRadioButton("6", 5)
dialogShow("生產第幾個收藏品")
dialogInit()
    addTextView("X")
    addEditNumber("prodX", 1880)
    addTextView("Y")
    addEditNumber("prodY", 400)
dialogShow("生產港位置")

-- 賣出設定
dialogInit()
addCheckBox("sellLocal", "原地賣出", true)
dialogShow("賣出設定")
if sellLocal == false then 
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
end

-- 設定
dialogInit()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
dialogShow("設定")

-- 先拍下生產品特徵
openCollect()
collectTextTable[prodIndex]:save(tmpFile)

while true do
    -- 等到生產完
    findImage("work_done.png", Region(900, 50, 600, 400))
    -- 委託生產
    click(findImage("entrust.png", Region(1832, 970, 226, 48)))
    -- 一鍵領取
    click(findImage("takeAll.png", Region(249, 955, 152, 44)))
    -- 要生產的東西
    click(findGoods(tmpFile))
    -- 批量
    click(findImage("batch.png", Region(2149, 814, 70, 38)))
    -- 製作
    click(findImage("make.png", Region(1980, 942, 76, 49)))
    -- 大量星書確認
    Region(1326, 677, 66, 35):existsClick("confirm.png")
    -- 成交
    makeDeal()
    click(Location(1370, 190))
    
    if sellLocal then 
        -- 到交易所
        repeat
            toast('finding market')
            result = findInMap("market.png")
        until result ~= nil
        click(getLastMatch())
        -- 賣出
        click(findImage("sell.png", Region(1834, 868, 63, 51)))
        -- 全賣
        click(findImage("sellAll.png", Region(503, 964, 68, 48)))
        makeDeal()
        -- 回到工坊
        repeat
            toast('finding workshop')
            result = findInMap("workshop.png")
        until result ~= nil
        click(getLastMatch())
    else
        -- 賣出
        sellCollect()
        -- 喝酒
        if (drink) then
            goDrink()
        end
        -- 回到工坊        
        openCollect()
        -- 指定收藏品
        click(collectTable[prodIndex])
        wait(interval)
        manualTouch({
            -- 獲取
            { action = "touchDown", target = Location(1930, 990) },
            { action = "touchUp",   target = Location(1930, 990) },
            { action = "wait",      target = interval }
        })
        -- 指定生產港
        click(Location(prodX, prodY))
        -- 前往
        click(findImage("go.png", Region(960, 240, 600, 600)))
        -- 航行到工坊
        sailTil("entrust.png", Region(1832, 970, 226, 48))
    end
end
