-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

enterReg = Region(591, 306, 60, 60)

while true do 

-- 下移直到出現圖示
while true do
 if enterReg:exists("enter.png", 0.5) 
 then 
  enterReg:existsClick("enter.png", 0.5) 
  break
 else
  longClick(Location(141, 492), 1)
 end
end

-- 點擊進入副本
Region(793, 463, 60, 60):existsClick("go.png")
--可能有水糧不足的提示，按確定
Region(545, 320, 60, 60):existsClick("confirm.png", 3)

-- 自動冒險
Region(888, 346, 40, 40):existsClick("auto.png", 20)
Region(686, 397, 60, 60):existsClick("auto2.png")
--wait(advTime)
--Region(889, 347, 40, 40):waitVanish(Pattern("auto3.png"):similar(0.2), advTime)

while true do 
 if Region(889, 347, 40, 40):exists(Pattern("auto3.png"):similar(0.9)) == nil then 
  -- 過圖
  if Region(430, 53, 101, 29):exists("route.png") then 
   -- 嘗試點擊目標路線
   Region(167, 117, 623, 170):existsClick("subject.png", 0.5) 
   Region(167, 117, 623, 170):existsClick("gather.png", 0.5) 
  else 
   -- 過場
   if Region(20, 121, 53, 21):exists("cutscene.png", 2) == nil then 
    break
   end 
  end
 else 
  wait(1)
 end
end

-- 離開副本
Region(769, 40, 40, 40):existsClick("exit.png")
Region(301, 395, 60, 60):existsClick("exit2.png")
Region(539, 318, 60, 60):existsClick("exit3.png")

end