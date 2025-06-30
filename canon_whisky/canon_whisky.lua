-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2

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
        regionSail:existsClick("sail.png")
        regionSail:existsClick("boating.png")
        result = region:exists(image)
    until result ~= nil
    toast(string.format("found %s", image))
    return region:getLastMatch()
end

function findInMap(place)
    toast(string.format("findInMap(%s)", place))
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
    -- 找目標圖示
    result = exists(place)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            { action = "touchDown", target = Location(1200, 900) },
            { action = "touchMove", target = Location(1200, 100) },
            { action = "touchUp",   target = Location(1200, 100) },
            { action = "wait",      target = interval }
        })
        result = exists(place)
    end
    return result
end

-- 找交易品
function findGoods(image)
    regionGoods = Region(45, 95, 580, 660)
    repeat
        toast(string.format("findGoods(%s)", image))
        -- 滑到上面
        manualTouch({
            { action = "touchDown", target = Location(340, 400) },
            { action = "touchMove", target = Location(340, 560) },
            { action = "touchUp",   target = Location(340, 560) },
            { action = "wait",      target = interval }
        })
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
    until result ~= nil
    toast(string.format("found %s", image))
    return regionGoods:getLastMatch()
end

-- 交易-喊價-成交
function makeDeal()
    toast("makeDeal")
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

-- 設定
dialogInit()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
newRow()
addCheckBox("drink", "喝酒", true)
addCheckBox("towage", "拖航到購買點", false)
dialogShow("設定")

while true do
    -- 等到生產完
    while exists("work_done.png") == nil do
        toast("waiting for work done")
        wait(findImageInterval)
    end

    -- 委託生產
    click(findImage("entrust.png", Region(1832, 970, 226, 48)))
    -- 一鍵領取
    click(findImage("takeAll.png", Region(249, 955, 152, 44)))
    -- 要生產的東西
    click(findGoods("canon.png"))
    -- 批量
    click(findImage("batch.png", Region(2149, 814, 70, 38)))
    -- 製作
    click(findImage("make.png", Region(1980, 942, 76, 49)))
    -- 大量星書確認
    Region(1326, 677, 66, 35):existsClick("confirm.png")
    -- 成交
    makeDeal()
    click(Location(1370, 190))

    -- 到交易所
    repeat
        toast('finding market')
        result = findInMap("market.png")
    until result ~= nil
    -- 點交易所圖示
    click(getLastMatch())
    -- 賣出
    click(findImage("sell.png", Region(1834, 868, 63, 51)))
    -- 全賣
    click(findImage("sellAll.png", Region(503, 964, 68, 48)))
    makeDeal()

    -- 買威士忌
    click(findImage("buy.png", Region(1832, 971, 63, 55)))
    click(findGoods("whisky.png"))
    makeDeal()

    -- 去西地中海賣
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
        -- 收藏品第2個
        { action = "touchDown", target = Location(400, 160) },
        { action = "touchUp",   target = Location(400, 160) },
        { action = "wait",      target = interval },
        -- 出售
        { action = "touchDown", target = Location(2170, 990) },
        { action = "touchUp",   target = Location(2170, 990) },
        { action = "wait",      target = interval },
        -- 海域
        { action = "touchDown", target = Location(2050, 900) },
        { action = "touchUp",   target = Location(2050, 900) },
        { action = "wait",      target = interval },
        -- 西地中海
        { action = "touchDown", target = Location(2050, 640) },
        { action = "touchUp",   target = Location(2050, 640) },
        { action = "wait",      target = interval },
        -- 最高價的出貨港
        { action = "touchDown", target = Location(1883, 380) },
        { action = "touchUp",   target = Location(1883, 380) },
        { action = "wait",      target = interval }
    })

    -- 前往
    click(findImage("go.png", Region(960, 240, 600, 600)))
    wait(5)
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
                { action = "wait",      target = interval }
            })
        end
    end

    -- 回到都柏林工坊
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
        -- 收藏品第1個
        { action = "touchDown", target = Location(240, 160) },
        { action = "touchUp",   target = Location(240, 160) },
        { action = "wait",      target = interval },
        -- 獲取
        { action = "touchDown", target = Location(1930, 990) },
        { action = "touchUp",   target = Location(1930, 990) },
        { action = "wait",      target = interval },
        -- 都柏林
        { action = "touchDown", target = Location(2050, 389) },
        { action = "touchUp",   target = Location(2050, 389) },
        { action = "wait",      target = interval }
    })
    -- 前往
    if towage then
        -- 拖航過去
        click(findImage("towage.png", Region(960, 240, 600, 600)))
        click(findImage("confirm.png", Region(960, 240, 600, 600)))
    else
        -- 開過去
        click(findImage("go.png", Region(960, 240, 600, 600)))
    end

    -- 航行到工坊
    sailTil("entrust.png", Region(1832, 970, 226, 48))
end
