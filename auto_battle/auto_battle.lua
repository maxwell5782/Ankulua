-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

setManualTouchParameter(30, 1)

actionList = { { action = "touchDown", target = Location(400, 100) },
  { action = "touchMove", target = Location(700, 100) },
  { action = "touchUp",   target = Location(700, 100) } }

questToRun = 3
reg1 = Region(21, 218, 290, 61)
reg2 = Region(22, 281, 290, 61)
reg3 = Region(21, 346, 290, 61)

function acceptQuest(region)
  if region:exists(Pattern("team.png"):similar(0.9), 1) == nil
      and region:exists(Pattern("accepted.png"):similar(0.9), 1) == nil
  then
    click(Location(region.x + 10, region.y + 20))
    Region(771, 469, 55, 27):existsClick("accept.png")
    return true
  end
  return false
end

while true do
  -- 點小地圖公會
  click(Location(850, 105))
  if exists("guild.png", 5) then
    click(getLastMatch():offset(0, -20))
  end

  if Region(448, 132, 67, 21):exists("master.png", 10) then
    wait(0.5)
    -- 已走到公會，點委託介紹人
    manualTouch(actionList)
    if exists("client.png", 10) then
      wait(0.5)
      click(getLastMatch():offset(0, 50))
    end
  end

  -- 點委託任務
  Region(708, 487, 113, 22):existsClick("offer.png", 10)
  -- 接任務
  cnt = 0
  while cnt < questToRun do
    Region(127, 476, 76, 26):existsClick("refresh.png")
    -- 區塊1
    if acceptQuest(reg1) then
      cnt = cnt + 1
    end
    -- 區塊2
    if acceptQuest(reg2) then
      cnt = cnt + 1
    end
    -- 區塊3
    if acceptQuest(reg3) then
      cnt = cnt + 1
    end
  end

  -- 出發
  click(Location(464, 325))
  wait(1)
  click(Location(828, 300))
  wait(0.5)
  click(Location(865, 235))
  existsClick("go.png")

  -- 打完回報
  while cnt > 0 do
    if Region(395, 65, 185, 120):exists(Pattern("dock.png"):similar(0.9)) then
      Region(704, 379, 38, 31):existsClick("done.png")
      wait(3)
      click(Location(665, 307))
      wait(1)
      cnt = cnt - 1
    end
    wait(5)
  end
end
