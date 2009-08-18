-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("revelation")

require("wicked")

require("calendar")
-- require("wireless")
-- require("battery")
require("geo")
require("media")
--require("irc")
require("completion")
require("org-awesome")

-- {{{ Variable definitions
tags = {}
taglist = {}
tasklist = {}
statusbar = {}
layouts = {}
promptbox = {}
globalkeys = {}
clientkeys = {}

layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}


-- theme_path = os.getenv("HOME").."/.config/awesome/zenburn.lua"
theme_path = "/usr/share/awesome/themes/default/theme.lua"
beautiful.fg_end_widget = "#00ff00"
beautiful.fg_widget = "#0000ff"
beautiful.init(theme_path)
calendar.settings = {}
calendar.settings.diary = os.getenv("HOME").."/.diary"
calendar.settings.alarm = os.getenv("HOME").."/.alarm"
org.files = { os.getenv("HOME").."/.org/gtd.org", os.getenv("HOME").."/.org/journal.org", os.getenv("HOME").."/.org/someday.org" }

--irc.settings = {}
--irc.settings.host = "irc.oftc.net"
--irc.settings.port = 6667
--irc.settings.nickname = "kooky_"
--irc.settings.channel = "#testtest"

settings = {}

terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "emacsclient"
editor_cmd = terminal .. " -e " .. editor
browser = "iceweasel"
lock = "sleep 1; xtrlock"

location = {}
location.latitude = 53.146485
location.longitude = 8.181891

settings.tags = {
   { name = "☠", layout = layouts[1] },
   { name = "⌥", layout = layouts[1] },
   { name = "✇", layout = layouts[1] },
   { name = "⌤", layout = layouts[1] },
   { name = "⍜", layout = layouts[1] },
   { name = "✣", layout = layouts[1] },
   { name = "⌨", layout = layouts[1] },
   { name = "⌘", layout = layouts[1], mwfact = 0.2 },
   { name = "☕", layout = layouts[1] }
}

settings.apps = {
   { match = { "gimp", "xdialog", "xmessage", "Open File" }, float = true },
   { match = { "firefox", "iceweasel", "opera" }, tag = 4 },
   { match = { "pidgin", "empathy" }, tag = 8},
   { match = { "mplayer" }, tag = 9},
   { match = { "urxvt" }, opacity_f = 0.85 },
   { match = { "urxvt.irssi" }, tag = 9 }
}

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags

mainmenu = awful.menu.new({
							 items = {
								{ "Terminal", terminal },
								{ "Restart", awesome.restart },
								{ "Quit", awesome.quit }
							 }
						  })

naughty.config.bg = beautiful.bg_normal
naughty.config.fg = beautiful.fg_normal
naughty.config.screen = screen.count() == 2 and 2 or 1
naughty.config.border_width = 2
naughty.config.presets.normal.border_color = beautiful.fg_normal
naughty.config.presets.normal.hover_timeout = 0.3

netwidget = widget({
		      type = 'textbox',
		      name = 'netwidget',
		      align = "right",
		      padding = "3"
})

wicked.register(netwidget, wicked.widgets.net,
		'↑${ra0 up_kb} ↓${ra0 down_kb} ',
nil, nil, 3)

org.widget = widget({
                type = "textbox",
                align = "right"
             })
org.widget:buttons({
                      button({ }, 1, function () awful.util.spawn(editor.." "..org.files[1].." "..org.files[2]) end),
                         button({ }, 3, function () org.update() end)
                  })
org.widget.mouse_enter = function () org.naughty_open() end
org.widget.mouse_leave = function () org.naughty_close() end
org.register(org.widget, org.files, {})

calendar.widget = widget({
							type = "textbox",
							align = "right"
						 })
calendar.menu = awful.menu.new({
								  id = "clock",
								  items = {
									 { "edit diary", editor.." "..calendar.settings.diary },
									 { "edit alarms", editor.." "..calendar.settings.alarm }
								  }
							   })
calendar.widget:buttons({
						   button({ }, 3, function () calendar.menu:toggle() end )
						})
calendar.popup = nil
calendar.widget.mouse_enter = function()
								 if calendar.popup ~= nil then
									naughty.destroy(calendar.popup)
									calendar.popup = nil
								 end
								 calendar.popup = naughty.notify({
																	title = "Calendar",
																	text = string.format('<span font_desc="%s">%s</span>', "monospace 6",
																						 calendar.to_string().."\n\n"..
																						 calendar.diary()),
																	hover_timeout = 5,
																	timeout = 0,
																	ontop = false,

																	--icon = xkcd.settings.filename,
																	--icon_size = 128
																 })
								 calendar.fulldate = true
								 calendar.update()
							  end
calendar.widget.mouse_leave = function()
								 calendar.fulldate = false
								 calendar.update()
							  end
calendar.update = function()
					 if calendar.fulldate then
						calendar.widget.text = calendar.date().." "..calendar.time()
					 else
						calendar.widget.text = calendar.time()
					 end
				  end

media.widget = widget({
						 type = "textbox",
						 name = "mediaWidget",
						 align = "right"
					  })
media.widget.text = ""

media.control = widget({
						   type = "textbox",
						   name = "mediaControl",
						   align = "right"
						})

media.control.text = "‣"
media.widget:buttons({
                        button({ }, 1, function()
                                          if media.is_playing() then
                                             media.pause()
                                          else
                                             media.play()
                                          end
                                       end),
                        button({ modkey }, 1, function()
                                                 if media.is_playing() then
                                                    media.next()
                                                 else
                                                    media.play()
                                                 end
                                              end),
                        button({ }, 3, function()
                                          if media.is_playing() then
                                             media.toggle_random()
                                          else
                                             media.play()
                                          end
                                       end),
                        button({ modkey }, 3, function()
                                                 if media.is_playing() then
                                                    media.previous()
                                                 else
                                                    media.play()
                                                 end
                                              end),
                        button({ }, 4, function()
                                          if media.is_playing() then
                                             media.next()
                                          else
                                             media.play()
                                          end
                                       end),
                        button({ }, 5, function()
                                          if media.is_playing() then
                                             media.previous()
                                          else
                                             media.play()
                                          end
                                       end)
                     })

media.popup = nil
media.widget.mouse_enter = function()
							  if media.popup ~= nil then
								 naughty.destroy(media.popup)
								 media.popup = nil
							  end
							  media.popup = naughty.notify({
																title = "Playing:",
																text = string.format('<span font_desc="%s">%s</span>', "monospace 6",
                                                                                     media.track()..". "..media.title().."\n"..
                                                                                  media.artist().." / ".. media.album().."\n"..
                                                                            media.elapsed_time().min..":"..media.elapsed_time().sec.."|"..media.total_time().min..":"..media.total_time().sec
                                                                         ),
																hover_timeout = 3,
																timeout = 10,
																-- icon = "", icon_size = 24,
															 })
						   end

media.menu_items = {}
media.menu_genres = media.list("genre")
for i = 1,#media.menu_genres do
   table.insert(media.menu_items, { media.menu_genres[i], function()
                                                              media.play_by_genre(media.menu_genres[i])
                                                           end})
end
media.menu_playlists = media.playlists()
for i = 1,#media.menu_playlists do
   table.insert(media.menu_items, { media.menu_playlists[i], function()
                                                                media.play_playlist(media.menu_playlists[i])
                                                             end})
end
media.menu = awful.menu.new({
                               id = "media",
                               items = media.menu_items
                            })

media.control:buttons({
                         button({ }, 1, function()
                                           if media.is_playing() then
                                              media.pause()
                                           else
                                              media.play()
                                              if not media.is_repeat() then
                                                 media.toggle_repeat()
                                              end
                                           end
                                        end),
                         button({ }, 3, function () media.menu:toggle() end)
                      })

media.vol = widget({
						   type = "progressbar",
						   name = "mediaVolume",
						   align = "right"
						})
media.vol.width = 5
media.vol.height = 0.9
media.vol.gap = 0
media.vol.border_padding = 1
media.vol.border_width = 0
media.vol.ticks_count = 4
media.vol.ticks_gap = 1
media.vol.vertical = true
media.vol:bar_properties_set('volume', {
									 bg = beautiful.bg_widget,
									 fg = beautiful.fg_widget,
									 fg_center = beautiful.fg_center_widget,
									 fg_end = beautiful.fg_end_widget,
									 fg_off = beautiful.fg_off_widget,
									 min_value = 0,
									 max_value = 100
								  })

systrayWidget = widget({
						  type = "systray",
						  align = "right"
					   })

taglist.buttons = {
   button({ }, 1, awful.tag.viewonly),
   button({ modkey }, 1, awful.client.movetotag),
   button({ }, 3, function (tag) tag.selected = not tag.selected end),
   button({ modkey }, 3, awful.client.toggletag),
   button({ }, 4, awful.tag.viewnext),
   button({ }, 5, awful.tag.viewprev)
}

tasklist.buttons = {
   button({ }, 1, function (c) client.focus = c; c:raise() end),
   button({ }, 3, function () awful.menu.clients({ width=250 }) end),
   button({ }, 4, function () awful.client.focus.byidx(1) end),
   button({ }, 5, function () awful.client.focus.byidx(-1) end)
}

for s = 1, screen.count() do
   tags[s] = {}

   for i, property in ipairs(settings.tags) do
	  tags[s][i] = tag(property.name)
	  tags[s][i].screen = s
	  awful.tag.setproperty(tags[s][i], "layout", property.layout)
	  awful.tag.setproperty(tags[s][i], "mwfact", property.mwfact)
	  awful.tag.setproperty(tags[s][i], "nmaster", property.nmaster)
	  awful.tag.setproperty(tags[s][i], "ncols", property.ncols)
   end

   tags[s][5].selected = true

   promptbox[s] = widget({
							type = "textbox",
							align = "left"
						 })

   taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)

   tasklist[s] = awful.widget.tasklist.new(
	  function(c)
		 return awful.widget.tasklist.label.currenttags(c, s)
	  end,
	  tasklist.buttons
   )

   statusbar[s] = wibox({
						   position = "top",
						   height = "12",
						   fg = beautiful.fg_normal,
						   bg = beautiful.bg_normal
						})

   statusbar[s].widgets = {
	  taglist[s],
	  tasklist[s],
	  promptbox[s],
	  netwidget,
      org.widget,
      media.widget,
      media.control,
      media.vol,
--	  wireless.icon,
--	  wireless.widget,
--	  battery.icon,
--	  battery.widget,
	  calendar.widget,
	  s == 1 and systrayWidget or nil
   }

   statusbar[s].screen = s
end

root.buttons({
				button({ }, 3, function () mainmenu:toggle() end),
				button({ }, 4, awful.tag.viewnext),
				button({ }, 5, awful.tag.viewprev)
			 })

keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
   table.insert(globalkeys,
				key({ modkey }, i,
					function ()
					   local screen = mouse.screen
					   if tags[screen][i] then
						  awful.tag.viewonly(tags[screen][i])
					   end
					end))
   table.insert(globalkeys,
				key({ modkey, "Control" }, i,
					function ()
					   local screen = mouse.screen
					   if tags[screen][i] then
						  tags[screen][i].selected = not tags[screen][i].selected
					   end
					end))
   table.insert(globalkeys,
				key({ modkey, "Shift" }, i,
					function ()
					   if client.focus and tags[client.focus.screen][i] then
						  awful.client.movetotag(tags[client.focus.screen][i])
					   end
					end))
   table.insert(globalkeys,
				key({ modkey, "Control", "Shift" }, i,
					function ()
					   if client.focus and tags[client.focus.screen][i] then
						  awful.client.toggletag(tags[client.focus.screen][i])
					   end
					end))
end

table.insert(globalkeys, key({ modkey }, "Left", awful.tag.viewprev))
table.insert(globalkeys, key({ modkey }, "Right", awful.tag.viewnext))

table.insert(globalkeys, key({ modkey }, "Escape", awful.tag.history.restore))

table.insert(globalkeys, key({ modkey }, "f", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({ modkey }, "b", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({}, "#233", function() awful.client.swap.byidx(1) end))
table.insert(globalkeys, key({ modkey }, "n", function () awful.client.swap.byidx(1) end))
table.insert(globalkeys, key({}, "#234", function() awful.client.swap.byidx(-1) end))
table.insert(globalkeys, key({ modkey }, "p", function () awful.client.swap.byidx(-1) end))

table.insert(globalkeys, key({ modkey, "Control" }, "f", function () awful.screen.focus(1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "b", function () awful.screen.focus(-1) end))

table.insert(globalkeys, key({ modkey }, "Tab", function () awful.client.focus.history.previous(); if client.focus then client.focus:raise() end end))

table.insert(globalkeys, key({ modkey }, "u", awful.client.urgent.jumpto))

-- Standard program
table.insert(globalkeys, key({ modkey }, "Return", function () awful.util.spawn(terminal) end))

table.insert(globalkeys, key({ modkey, "Control" }, "r", function ()
															promptbox[mouse.screen].text =
															   awful.util.escape(awful.util.restart())
														 end))
table.insert(globalkeys, key({ modkey, "Shift" }, "q", awesome.quit))
-- table.insert(globalkeys, key({}, "#111", function() awful.util.spawn("import -window root -depth 8 -quality 80 $HOME/`date \"+%Y-%m-%d_%H:%M:%S\"`.png") end))
table.insert(globalkeys, key({ modkey }, "x", function() awful.util.spawn(lock) end))

-- Client manipulation
table.insert(clientkeys, key({ modkey }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal
												 c.maximized_vertical = not c.maximized_vertical end))
table.insert(clientkeys, key({ modkey, "Shift" }, "f", function (c) c.fullscreen = not c.fullscreen end))
table.insert(clientkeys, key({ modkey, "Shift" }, "c", function (c) c:kill() end))
table.insert(clientkeys, key({ modkey, "Control" }, "space", awful.client.floating.toggle))
table.insert(clientkeys, key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end))
table.insert(clientkeys, key({ modkey }, "o", awful.client.movetoscreen))
table.insert(clientkeys, key({ modkey, "Shift" }, "r", function (c) c:redraw() end))

-- Layout manipulation
table.insert(globalkeys, key({ modkey }, "l", function () awful.tag.incmwfact(0.05) end))
table.insert(globalkeys, key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end))
table.insert(globalkeys, key({ modkey }, "space", function () awful.layout.inc(layouts, 1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end))

-- Prompt
table.insert(globalkeys, key({ modkey }, "F1", function ()
												  awful.prompt.run({ prompt = "Run: " },
																   promptbox[mouse.screen],
																   awful.util.spawn, awful.completion.bash,
																   awful.util.getdir("cache") .. "/history")
                                               end))
table.insert(globalkeys, key({ modkey }, "F2", function ()
												  awful.prompt.run({ prompt = "SSH: " },
																   promptbox[mouse.screen],
																   function(h)
																	  awful.util.spawn(terminal .. " -e \"ssh -v " .. h .. "\"")
																   end , completion.ssh,
																   awful.util.getdir("cache") .. "/history_ssh")
                                               end))
table.insert(globalkeys, key({ modkey }, "F4", function ()
												  awful.prompt.run({ prompt = "Run Lua code: " },
																   promptbox[mouse.screen],
																   awful.util.eval, awful.prompt.bash,
																   awful.util.getdir("cache") .. "/history_eval")
                                               end))
table.insert(globalkeys, key({ modkey }, "F6", function ()
												  awful.prompt.run({ prompt = "Address: " },
																   promptbox[mouse.screen],
																   function(h)
																	  local point = geo.point(h)
																	  naughty.notify({
																						title = h,
																						text = string.format('<span font_desc="%s">%s</span>', "monospace 6",
																											 "Latitude: "..point.latitude.."\n"..
																												"Longitude: "..point.longitude.."\n"..
																												"Accuracy: "..point.accuracy.."\n"..
																												"Distance: "..geo.distance(location, point).."m"),
																						hover_timeout = 3,
																						timeout = 10,
																					 })
																   end)
											   end))
table.insert(globalkeys, key({modkey }, "F9", revelation.revelation))

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
table.insert(clientkeys, key({ modkey }, "t", awful.client.togglemarked))

for i = 1, keynumber do
   table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
								function ()
								   local screen = mouse.screen
								   if tags[screen][i] then
									  for k, c in pairs(awful.client.getmarked()) do
										 awful.client.movetotag(tags[screen][i], c)
									  end
								   end
								end))
end

-- Set keys
root.keys(globalkeys)

calendar.initialize(calendar.settings)
calendar.update()
-- battery.initialize()
-- wireless.initialize("ra0")

--irc.initialize(irc.settings)
--irc.connect()

-- }}}

-- {{{ Hooks
-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
									-- Sloppy focus, but disabled for magnifier layout
									if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
									and awful.client.focus.filter(c) then
									client.focus = c
								 end
							  end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
							   -- If we are not managing this application at startup,
							   -- move it to the screen where the mouse is.
							   -- We only do it for filtered windows (i.e. no dock, etc).
							   if not startup and awful.client.focus.filter(c) then
								  c.screen = mouse.screen
							   end

							   if use_titlebar then
								  -- Add a titlebar
								  awful.titlebar.add(c, { modkey = modkey })
							   end
							   -- Add mouse bindings
							   c:buttons({
											button({ }, 1, function (c) client.focus = c; c:raise() end),
											button({ modkey }, 1, awful.mouse.client.move),
											button({ modkey }, 3, awful.mouse.client.resize)
										 })
							   -- New client may not receive focus
							   -- if they're not focusable, so set border anyway.
							   c.border_width = beautiful.border_width
							   c.border_color = beautiful.border_normal

							   -- Check if the application should be floating.
							   local class = c.class:lower()
							   local instance = c.instance:lower()
							   local name = c.name:lower()

							   for k, v in pairs(settings.apps) do
								  for j, m in pairs(v.match) do
									 if name:match(m) or instance:match(m) or class:match(m) then
										if v.float ~= nil then
										   awful.client.floating.set(c, v.float)
										end
										if v.tag then
										   awful.client.movetotag(tags[c.screen][v.tag], c)
										end
									 end
								  end
							   end

							   -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
							   client.focus = c

							   -- Set key bindings
							   c:keys(clientkeys)

							   -- Set the windows at the slave,
							   -- i.e. put it at the end of others instead of setting it master.
							   awful.client.setslave(c)

							   -- Honor size hints: if you want to drop the gaps between windows, set this to false.
							   c.size_hints_honor = false
							end)

-- Hook called every second
awful.hooks.timer.register(60, function()
								  calendar.update()
							   end)

awful.hooks.timer.register(1, function ()
                                 media.status()
                                 media.currentsong()
                                 if media.is_playing() then
                                    media.control.text = "‣"
                                    media.widget.text = awful.util.escape(media.artist() or "-").." - "..awful.util.escape(media.title() or "-")
                                 else
                                    media.control.text = "⌑"
                                    media.widget.text = ""
                                 end
								 --    irc.read()
							  end)
-- }}}
