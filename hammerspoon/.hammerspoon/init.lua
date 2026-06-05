-- hs.hotkey.bind({"alt"}, "space", function()
--   local wezterm = hs.application.find("WezTerm")
--   if wezterm then
--     if wezterm:isFrontmost() then
--       wezterm:hide()
--     else
--       wezterm:activate()
--     end
--   else
--     hs.application.open("WezTerm")
--   end
-- end)

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
