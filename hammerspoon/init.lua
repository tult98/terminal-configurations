mouse_follows_focus = hs.loadSpoon("MouseFollowsFocus")
mouse_follows_focus:configure({})
mouse_follows_focus:start()

hs.hotkey.bind({"alt"}, "space", function()
  local wezterm = hs.application.find("WezTerm")
  if wezterm then
    if wezterm:isFrontmost() then
      wezterm:hide()
    else
      wezterm:activate()
    end
  else
    hs.application.open("WezTerm")
  end
end)

hs.hotkey.bind({"cmd", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen()
    local frame = screen:frame()
    frame.w = frame.w / 2
    win:setFrame(frame)
  end
end)

hs.hotkey.bind({"cmd", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen()
    local frame = screen:frame()
    frame.x = frame.x + frame.w / 2
    frame.w = frame.w / 2
    win:setFrame(frame)
  end
end)

hs.hotkey.bind({"cmd", "alt"}, "Up", function()
  local win = hs.window.focusedWindow()
  if win then
    win:maximize()
  end
end)

hs.hotkey.bind({"cmd", "alt"}, "Down", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen()
    local frame = screen:frame()
    frame.x = frame.x + frame.w * 0.1
    frame.y = frame.y + frame.h * 0.1
    frame.w = frame.w * 0.8
    frame.h = frame.h * 0.8
    win:setFrame(frame)
  end
end)

hs.alert.show("Hammerspoon config loaded")
