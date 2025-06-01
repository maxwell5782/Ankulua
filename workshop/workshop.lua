-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

setManualTouchParameter(20, 1)

function goTo(place)
    manualTouch({
        { action = "touchDown", target = Location(856, 109) },
        { action = "wait",      target = 0.2 },
        { action = "touchUp",   target = Location(856, 109) }
    })
    while exists(place) == nil do
        toast(string.format("finding %s", place))
        wait(3)
    end
    toast("found")
    click(getLastMatch():offset(0, -20))
end

function makeDeal()
    manualTouch({
        { action = "touchDown", target = Location(740, 480) },
        { action = "touchUp",   target = Location(740, 480) },
        { action = "wait",      target = 0.2 },
        { action = "touchDown", target = Location(860, 480) },
        { action = "touchUp",   target = Location(860, 480) }
    })
    wait(1)
end

while true do
    -- 到工坊
    goTo("workshop.png")
    -- 等到生產完
    while exists("work_done.png") == nil do
        toast("waiting for work done")
        wait(5)
    end
    -- 委託生產
    Region(710, 487, 30, 30):existsClick("entrust.png")
    -- 一鍵領取
    Region(137, 463, 60, 60):existsClick("take.png")
    -- 點要生產的東西
    reg = Region(12, 87, 310, 290)
    while reg:exists("canon.png") == nil do
        toast("finding product")
        manualTouch({
            { action = "touchDown", target = Location(160, 280) },
            { action = "touchMove", target = Location(160, 130) },
            { action = "touchUp",   target = Location(160, 130) }
        })
        wait(3)
    end
    toast("found")
    click(reg:getLastMatch())
    -- 批量
    click(Location(882, 417))
    --click(Location(801, 417))
    -- 製作
    Region(786, 474, 30, 20):existsClick("make.png")
    -- 可能要確認大量用星書
    Region(560, 339, 30, 20):existsClick("confirm.png")
    -- 成交
    makeDeal()

    -- 到交易所
    goTo("market.png")
    wait(8)
    -- 賣出
    click(Location(765, 448))
    click(Location(269, 494))
    click(Location(800, 482))
    makeDeal()
end
