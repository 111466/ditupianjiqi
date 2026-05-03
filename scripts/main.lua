-- ============================================================================
-- main.lua — 宿主项目：集成等距场景编辑器 (Map Editor Master)
-- ============================================================================

local UI = require("urhox-libs/UI")
local IsoMapEditor = require("IsoMapEditor")

function Start()
    -- 初始化 UI 系统
    UI.Init({
        fonts = {
            { family = "sans", weights = {
                normal = "Fonts/MiSans-Regular.ttf",
            } }
        },
        scale = UI.Scale.DEFAULT,
    })

    -- 初始化地图编辑器
    IsoMapEditor.Init({
        tileFolder = "Tiles",       -- 瓦片图片文件夹（assets/Tiles/）
        buttonSize = 56,            -- 浮窗按钮尺寸
        buttonLabel = "Map",        -- 按钮文本
        autoSave = true,            -- 退出时自动保存
    })

    -- 构建宿主界面
    local root = UI.Panel {
        width = "100%",
        height = "100%",
        backgroundColor = { 30, 30, 30, 255 },
        justifyContent = "center",
        alignItems = "center",
        children = {
            UI.Label {
                text = "等距场景编辑器 Demo",
                fontSize = 28,
                color = { 255, 255, 255, 255 },
            },
            UI.Label {
                text = "点击右侧浮窗按钮进入编辑器",
                fontSize = 16,
                color = { 180, 180, 180, 255 },
                marginTop = 12,
            },
            -- 浮窗入口按钮
            IsoMapEditor.CreateFloatingButton(),
        },
    }
    UI.SetRoot(root)

    -- 订阅事件
    SubscribeToEvent("Update", "HandleUpdate")
    SubscribeToEvent("KeyDown", "HandleKeyDown")
end

---@param eventType string
---@param eventData UpdateEventData
function HandleUpdate(eventType, eventData)
    local dt = eventData["TimeStep"]:GetFloat()

    -- 编辑器每帧更新（非激活时内部自动跳过）
    IsoMapEditor.Update(dt)

    -- 编辑器激活时跳过宿主逻辑
    if IsoMapEditor.IsActive() then return end

    -- ... 宿主项目的 Update 逻辑 ...
end

---@param eventType string
---@param eventData KeyDownEventData
function HandleKeyDown(eventType, eventData)
    local key = eventData["Key"]:GetInt()

    -- 编辑器优先消费键盘事件
    if IsoMapEditor.HandleKeyDown(key) then return end

    -- ... 宿主项目的 KeyDown 逻辑 ...
end

function Stop()
    UI.Shutdown()
end
