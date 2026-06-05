hs.hotkey.bind({"alt"}, "space", function()
  local ghostty = hs.application.find("Ghostty")
  if ghostty then
    if ghostty:isFrontmost() then
      ghostty:hide()
    else
      ghostty:activate()
    end
  else
    hs.application.open("Ghostty")
  end
end)

local pasteHotkey
pasteHotkey = hs.hotkey.bind({"cmd"}, "v", function()
  local app = hs.application.frontmostApplication()
  pasteHotkey:disable()
  if app:name() == "Ghostty" and hs.pasteboard.readImage() then
    hs.eventtap.keyStroke({"ctrl"}, "v")
  else
    hs.eventtap.keyStroke({"cmd"}, "v")
  end
  pasteHotkey:enable()
end)


hs.alert.show("Hammerspoon config loaded")
