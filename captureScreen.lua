-- ========== 設定 ================
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 960)

-- 截圖範圍
--dialogInit()
--addTextView("Capture size:")
--addEditNumber("w", 30)
--addEditNumber("h", 30)
--dialogShow("Set Capture size")

w = 30
h = 30

-- 等待使用者點擊截圖位置，計算範圍
action, locTable, touchTable = getTouchEvent()
if (action == "click" or action == "longClick") then
 x = locTable:getX() - w / 2
 y = locTable:getY() - h / 2
else
 x = locTable[1].x
 y = locTable[1].y
 w = locTable[2].x - locTable[1].x
 h = locTable[2].y - locTable[1].y
end
reg = Region(x, y, w, h)

-- 詢問存檔檔名
--dialogInit()
--addTextView("File Name:")
--addEditText("txtFileName", nil)
--dialogShow("Save Image")

-- 存檔
fileName = string.format("%s.png","1")
reg:save(fileName)
-- 產生腳本語法
setClipboard(string.format("Region(%s, %s, %s, %s):existsClick(\"%s\")", x, y, w, h, fileName))

print(locTable[1])
print(locTable[2])
print(string.format("%s, %s, %s, %s", x, y, w, h))
print("script copied to clipboard")