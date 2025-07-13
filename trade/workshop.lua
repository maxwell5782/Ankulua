-- ========== 設定 ================
Settings:setCompareDimension(true, 2340)
Settings:setScriptDimension(true, 2340)
Settings:set("MinSimilarity", 0.9)
setImmersiveMode(true)
autoGameArea(true)
setManualTouchParameter(20, 1)

interval = 2
tmpFile = "workshop_tmp.png"

-- 生產品表
products = {}
products[0] = {}
products[0][0] = "大炮.png"
products[0][1] = Location(2063, 386)
products[1] = {}
products[1][0] = "羽毛.png"
products[1][1] = Location(1873, 566)
products[2] = {}
products[2][0] = "火腿.png"
products[2][1] = Location(1986, 386)
products[3] = {}
products[3][0] = "法蘭絨.png"
products[3][1] = Location(1887, 453)
products[4] = {}
products[4][0] = "蕾絲花邊.png"
products[4][1] = Location(1886, 388)

-- 收藏品定位
collectTable = {}
collectTable[0] = Location(240, 160)
collectTable[1] = Location(400, 160)
collectTable[2] = Location(560, 160)
collectTable[3] = Location(240, 360)
collectTable[4] = Location(400, 360)
collectTable[5] = Location(560, 360)

-- 海域
areas = {}
areas[0] = "北海"
areas[1] = "北大西洋"
areas[2] = "西地中海"
areas[3] = "東地中海"
areas[4] = "非洲西岸"
areas[5] = "加勒比"
areas[6] = "中南美"
-- 港口
cities = {}
cities[0] = {}
cities[0][0] = "倫敦.png"
cities[0][1] = "多佛.png"
cities[0][2] = "阿姆斯特丹.png"
cities[0][3] = "海爾德.png"
cities[0][4] = "奧斯陸.png"
cities[1] = {}
cities[1][0] = "波爾多.png"
cities[1][1] = "里斯本.png"
cities[2] = {}
cities[2][0] = "塞維利亞.png"
cities[2][1] = "休達.png"
cities[2][2] = "阿爾及爾.png"
cities[3] = {}
cities[3][0] = "亞歷山大.png"
cities[3][1] = "班加西.png"
cities[3][2] = "開羅.png"
cities[3][3] = "法馬古斯塔.png"
cities[3][4] = "貝魯特.png"

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
    imagePattern = Pattern(image):similar(0.9)
    result = regionGoods:exists(imagePattern)
    -- 找不到的話，滑到下面找
    if result == nil then
        manualTouch({
            { action = "touchDown", target = Location(340, 650) },
            { action = "touchMove", target = Location(340, 250) },
            { action = "touchUp",   target = Location(340, 250) },
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
    click(findImage(areas[area] .. ".png", Region(1940, 426, 212, 439)))
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

    regionHere = Region(960, 240, 600, 600)
    if regionHere:exists("here.png") then
        click(Location(2271, 47))
        -- 到交易所
        repeat
            toast('finding market')
            result = findInMap("market.png")
        until result ~= nil
        -- 點交易所圖示
        click(getLastMatch())
    else
        -- 前往
        click(findImage("go.png", Region(960, 240, 600, 600)))
    end
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
addRadioGroup("productIndex", 0)
for i, product in pairs(products) do
    addRadioButton(product[0], i)
end
dialogShow("生產什麼")

dialogInit()
addRadioGroup("collectIndex", 0)
for i = 1, 6 do
    addRadioButton(tostring(i), i - 1)
end
dialogShow("生產品是第幾個收藏品")

-- 賣出設定
dialogInit()
addCheckBox("sellLocal", "原地賣出", true)
dialogShow("賣出設定")

if sellLocal == false then
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

    dialogInit()
    addRadioGroup("sellPort", 0)
    if sellType == 0 then
        for i = 1, 6 do
            addRadioButton(tostring(i), i - 1)
        end
    else
        for i, name in pairs(cities[sellArea]) do
            addRadioButton(name, i)
        end
    end
    dialogShow("哪個出售港")
end

-- 時間設定
dialogInit()
addCheckBox("drink", "喝酒", true)
addCheckBox("towage", "拖航到購買點", false)
newRow()
addTextView("找圖間隔(秒)")
addEditNumber("findImageInterval", 5)
dialogShow("設定")

while true do
    -- 等到生產完
    findImage("work_done.png", Region(750, 50, 700, 300))
    -- 委託生產
    click(findImage("entrust.png", Region(1832, 970, 226, 48)))
    -- 一鍵領取
    click(findImage("takeAll.png", Region(249, 955, 152, 44)))
    -- 要生產的東西
    click(findGoods(products[productIndex][0]))
    -- 批量
    click(findImage("batch.png", Region(2149, 814, 70, 38)))
    --click(Location(1857,843))--+3個
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
        wait(interval)
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
        wait(interval)
    else
        -- 賣出
        sellCollect(collectIndex, sellArea, sellType, sellPort)
        -- 喝酒
        if (drink) then
            goDrink()
        end
        -- 回到工坊
        openCollect()
        -- 指定收藏品
        click(collectTable[collectIndex])
        wait(interval)
        manualTouch({
            -- 獲取
            { action = "touchDown", target = Location(1930, 990) },
            { action = "touchUp",   target = Location(1930, 990) },
            { action = "wait",      target = interval }
        })
        -- 指定生產港
        click(products[productIndex][1])
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
end
