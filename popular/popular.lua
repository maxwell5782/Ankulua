-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

pop1 = Location(170, 70)
sell1 = Location(120, 90)

function makeDeal()
    manualTouch({
        { action = "touchDown", target = Location(800, 480) },
        { action = "touchUp",   target = Location(800, 480) },
        { action = "wait",      target = 1 },
        { action = "touchDown", target = Location(740, 480) },
        { action = "touchUp",   target = Location(740, 480) },
        { action = "wait",      target = 1 },
        { action = "touchDown", target = Location(860, 480) },
        { action = "touchUp",   target = Location(860, 480) },
        { action = "wait",      target = 2 }
    })
end

-- 移動到買的地方
manualTouch({
    { action = "touchDown", target = Location(856, 109) },
    { action = "touchUp",   target = Location(856, 109) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(908, 430) },
    { action = "touchUp",   target = Location(908, 430) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = pop1 },
    { action = "touchUp",   target = pop1 }
})
reg = Region(684, 140, 259, 258)
if reg:exists("location2buy.png", 5) then
    x = reg:getLastMatch().x + 40
    y = reg:getLastMatch().y + 40
    manualTouch({
        { action = "touchDown", target = Location(x, y) },
        { action = "touchUp",   target = Location(x, y) },
        { action = "wait",      target = 3 }
    })
    Region(351, 203, 316, 112):existsClick(Pattern("go.png"):similar(0.95))
end
while Region(697, 421, 99, 98):exists("market.png") == nil do
    toast("waiting to go to market")
    wait(3)
end
wait(3)
toast("arrive")

-- 買
click(Location(770, 500))
wait(1)
Region(20, 45, 290, 360):existsClick("good2buy.png", 3)
makeDeal()

-- 移動到賣的地方
manualTouch({
    { action = "touchDown", target = Location(856, 109) },
    { action = "touchUp",   target = Location(856, 109) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(908, 430) },
    { action = "touchUp",   target = Location(908, 430) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = sell1 },
    { action = "touchUp",   target = sell1 },
    { action = "wait",      target = 3 },
    { action = "touchDown", target = sell1 },
    { action = "touchUp",   target = sell1 },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(590, 280) },
    { action = "touchUp",   target = Location(590, 280) },
    { action = "wait",      target = 10 }
})
while Region(697, 421, 99, 98):exists("market.png") == nil do
    toast("waiting to go to market")
    wait(3)
end
toast("arrive")

manualTouch({
    { action = "touchDown", target = Location(765, 450) },
    { action = "touchUp",   target = Location(765, 450) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(270, 490) },
    { action = "touchUp",   target = Location(270, 490) }
})
makeDeal()
