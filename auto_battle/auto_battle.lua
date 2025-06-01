-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

setManualTouchParameter(10, 1)

rounds = 0
questToRun = 3
reg1 = Region(21, 218, 290, 61)
reg2 = Region(22, 281, 290, 61)
reg3 = Region(21, 346, 290, 61)

function goTo(place)
  click(Location(856, 109))
  while exists(place) == nil do
    toast(string.format("finding %s", place))
    wait(3)
  end
  toast("found")
  click(getLastMatch():offset(0, -20))
end

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
  rounds = rounds + 1
  toast(string.format("round %s", rounds))

  -- 到公會
  goTo("guild.png")

  -- 已走到公會，點委託介紹人
  manualTouch({
    { action = "wait",      target = 6 },
    { action = "touchDown", target = Location(200, 450) },
    { action = "wait",      target = 5 },
    { action = "touchUp",   target = Location(200, 450) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(430, 190) },
    { action = "touchUp",   target = Location(430, 190) } })

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
    if cnt < questToRun and acceptQuest(reg2) then
      cnt = cnt + 1
    end
    -- 區塊3
    if cnt < questToRun and acceptQuest(reg3) then
      cnt = cnt + 1
    end
  end

  -- 出發
  manualTouch({
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(464, 40) },
    { action = "touchUp",   target = Location(464, 40) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(828, 300) },
    { action = "touchUp",   target = Location(828, 300) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(865, 235) },
    { action = "touchUp",   target = Location(865, 235) },
    { action = "wait",      target = 1 },
    { action = "touchDown", target = Location(580, 280) },
    { action = "touchUp",   target = Location(580, 280) },
    { action = "wait",      target = 10 }
  })

  -- 打完回報
  while Region(709, 480, 73, 36):exists(Pattern("leave.png"):similar(0.9)) == nil do
    toast(string.format("round %s wait til back to dock", rounds))
    wait(5)
  end
  toast("arrive")

  while cnt > 0 do
    Region(690, 300, 85, 180):existsClick("done.png")
    manualTouch({
      { action = "wait",      target = 3 },
      { action = "touchDown", target = Location(665, 307) },
      { action = "touchUp",   target = Location(665, 307) },
      { action = "wait",      target = 1 }
    })
    cnt = cnt - 1
  end
end
