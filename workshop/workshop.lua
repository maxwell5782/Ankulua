-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 1
regionGoods = Region(174, 191, 229, 518)

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
addTextView("生產品")
addEditText("goods", "lace.png")
dialogShow("設定")

while true do
    -- 到工坊，可能有兩種圖示
    result = findInMap("workshop.png")
    if result == nil then
        result = findInMap("workshop2.png")
    end
    if result == nil then
        -- 還是找不到，停止腳本
        print("Can't find workshop")
        do return end
    end
    click(getLastMatch())

    -- 等到生產完
    while exists("work_done.png") == nil do
        toast("waiting for work done")
        wait(5)
    end

    -- 委託生產
    click(findImage("entrust.png", Region(1832, 970, 226, 48)))
    -- 一鍵領取
    click(findImage("takeAll.png", Region(249, 955, 152, 44)))
    -- 找要生產的東西
    result = regionGoods:exists(goods)
    if result == nil then
        -- 找不到的話，滑到下面找
        manualTouch({
            { action = "touchDown", target = Location(350, 700) },
            { action = "touchMove", target = Location(350, 200) },
            { action = "touchUp",   target = Location(350, 200) },
            { action = "wait",      target = interval }
        })
        result = regionGoods:exists(goods)
    end
    if result == nil then
        -- 還是找不到，停止腳本
        print(string.format("Can't find goods %s", goods))
        do return end
    end
    toast("found")
    click(regionGoods:getLastMatch())
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
    result = findInMap("market.png")
    if result == nil then
        -- 還是找不到，停止腳本
        print("Can't find market")
        do return end
    end
    click(getLastMatch())
    -- 賣出
    click(findImage("sell.png", Region(1834, 868, 63, 51)))
    -- 全賣
    click(findImage("sellAll.png", Region(503, 964, 68, 48)))
    makeDeal()
end
