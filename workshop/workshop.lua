-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

setManualTouchParameter(20, 1)

actionList = { {action = "touchDown", target = Location(856, 109)},
    {action = "touchUp", target = Location(856, 109)} }

-- 點小地圖
manualTouch(actionList)
wait(1)

-- 找工坊
if exists("workshop.png", 5) 
then 
 click(getLastMatch():offset(0, -20))
end

-- 等到生產完
existsClick("work_done.png", 600)
-- 委託生產
Region(710, 487, 30, 30):existsClick("entrust.png")
-- 一鍵領取
Region(137, 463, 60, 60):existsClick("take.png")
-- 點要生產的東西
Region(12, 87, 310, 290):existsClick("beer.png")
-- 批量
Region(865, 407, 30, 20):existsClick("batch.png")
-- 製作
Region(786, 474, 30, 20):existsClick("make.png")
-- 可能要確認大量用星書
Region(560, 339, 30, 20):existsClick("confirm.png")