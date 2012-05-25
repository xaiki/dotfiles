-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("vicious")
require("blingbling")

function run_once(prg, args)
  if not prg then
    do return nil end
  end
  if not args then
    args=""
  end
  awful.util.spawn_with_shell('pgrep -f -u $USER -x ' .. prg .. ' || (' .. prg .. ' ' .. args ..')')
end

-- {{{ Variable definitions
--get $HOME from the environement system
home   = os.getenv("HOME")
--get XDG_CONFIG
config_dir = awful.util.getdir("config")
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser="luakit"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

--Lancement d'applications
run_once("nm-applet")
run_once("xcompmgr",'xcompmgr -ncfF -I "20" -O "10" -D "1" -t "-5" -l "-5" -r "4.2" -o ".82" &')
run_once("syndaemon", 'syndaemon -i 0.5 -k -d')
run_once("udisks-glue")
---- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ naughty theme
naughty.config.default_preset.font             = beautiful.notify_font
naughty.config.default_preset.fg               = beautiful.notify_fg
naughty.config.default_preset.bg               = beautiful.notify_bg
naughty.config.presets.normal.border_color     = beautiful.notify_border
-- }}}

-- {{{ Menu
--Menu for choose between all your theme
mythememenu = {}
function theme_load(theme)
  local cfg_path = awful.util.getdir("config")
  -- Create a symlink from the given theme to /home/user/.config/awesome/current_theme
  awful.util.spawn("ln -sfn " .. cfg_path .. "/themes/" .. theme .. " " .. cfg_path .. "/current_theme")
  awesome.restart()
end
function theme_menu()
-- List your theme files and feed the menu table
  local cmd = "ls -1 " .. awful.util.getdir("config") .. "/themes/"
  local f = io.popen(cmd)
  for l in f:lines() do
    local item = { l, function () theme_load(l) end }
    table.insert(mythememenu, item)
  end
  f:close()
end
-- Generate your table at startup or restart
theme_menu()
-- }}}
-- {{{ Wibox
--widget separator
separator = widget({ type = "textbox", name = "separator"})
separator.text = " "

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
my_top_wibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

--- {{ Section des Widgets
--pango
    pango_small="size=\"small\""
    pango_x_small="size=\"x-small\""
    pango_xx_small="size=\"xx-small\""
    pango_bold="weight=\"bold\""
--test oocairo
require("blingbling")

 --Cpu widget
 cpuwidget=blingbling.classical_graph.new()
 cpuwidget:set_height(18)
 cpuwidget:set_width(100)
-- cpuwidget:set_text_color(beautiful.fg_urgent)
 cpuwidget:set_background_text_color("#00000000")
 cpuwidget:set_tiles_color("#00000022")
 cpuwidget:set_show_text(true)
 cpuwidget:set_label("CPU: $percent %")
 vicious.register(cpuwidget, vicious.widgets.cpu, '$1', 2)

--Cores Widgets
  corelabel=widget({ type = "textbox" })
  corelabel.text="<span color=\""..beautiful.fg_urgent.."\" "..pango_small..">Cores:</span>"

 mycore1=blingbling.progress_graph.new()
 mycore1:set_height(18)
 mycore1:set_width(6)
 mycore1:set_filled(true)
 mycore1:set_h_margin(1)
 mycore1:set_filled_color("#00000033")
 vicious.register(mycore1, vicious.widgets.cpu, "$2")

 mycore2=blingbling.progress_graph.new()
 mycore2:set_height(18)
 mycore2:set_width(6)
 mycore2:set_filled(true)
 mycore2:set_h_margin(1)
 mycore2:set_filled_color("#00000033")
 vicious.register(mycore2, vicious.widgets.cpu, "$3")

 mycore3=blingbling.progress_graph.new()
 mycore3:set_height(18)
 mycore3:set_width(6)
 mycore3:set_filled(true)
 mycore3:set_h_margin(1)
 mycore3:set_filled_color("#00000033")
 vicious.register(mycore3, vicious.widgets.cpu, "$4")

 mycore4=blingbling.progress_graph.new()
 mycore4:set_height(18)
 mycore4:set_width(6)
 mycore4:set_filled(true)
 mycore4:set_h_margin(1)
 mycore4:set_filled_color("#00000033")
 vicious.register(mycore4, vicious.widgets.cpu, "$5")

 memwidget=blingbling.classical_graph.new()
 memwidget:set_height(18)
 memwidget:set_width(100)
 memwidget:set_tiles_color("#00000022")
-- memwidget:set_text_color(beautiful.fg_urgent)
 memwidget:set_background_text_color("#00000000")
 memwidget:set_show_text(true)
 memwidget:set_label("MEM: $percent %")
 vicious.register(memwidget, vicious.widgets.mem, '$1', 5)

--task_warrior menu
 task_warrior=blingbling.task_warrior.new(beautiful.tasks)
 task_warrior:set_task_done_icon(beautiful.task_done)
 task_warrior:set_task_icon(beautiful.task)
 task_warrior:set_project_icon(beautiful.project)

--udisks-glue menu
  udisks_glue=blingbling.udisks_glue.new(beautiful.udisks_glue)
  udisks_glue:set_mount_icon(beautiful.accept)
  udisks_glue:set_umount_icon(beautiful.cancel)
  udisks_glue:set_detach_icon(beautiful.cancel)
  udisks_glue:set_Usb_icon(beautiful.usb)
  udisks_glue:set_Cdrom_icon(beautiful.cdrom)
  awful.widget.layout.margins[udisks_glue.widget]= { top = 4}
  udisks_glue.widget.resize= false

--Calendar widget
  my_cal=blingbling.calendar.new({type = "textbox", text = "calendar"})
  my_cal:set_cell_padding(2)
  my_cal:set_title_font_size(12)
  my_cal:set_font_size(10)
  my_cal:set_inter_margin(1)
  my_cal:set_columns_lines_titles_font_size(8)
  my_cal:set_columns_lines_titles_text_color("#d4aa00ff")
  my_cal:set_label("$date")

  vicious.register(my_cal.widget, vicious.widgets.date, "<span color=\""..beautiful.fg_normal.."\" "..pango_small..">%b %d, %R</span>", 60)

-- Net Widget
  my_net=blingbling.net.new()
  my_net:set_height(18)
  --activate popup with ip informations on the net widget

--  my_net:set_ippopup()
  my_net:set_show_text(true)
  my_net:set_v_margin(3)
  my_net:set_background_text_color("#00000000")

--Volume
  my_volume=blingbling.volume.new()
  my_volume:set_height(16)
  my_volume:set_width(20)
  my_volume:update_master()
  my_volume:set_master_control()
  my_volume:set_bar(true)
  my_volume:set_background_graph_color("#00000099")
  my_volume:set_graph_color("#00ccffaa")
-- wiboxs

    my_top_wibox[s] = awful.wibox({ position = "top", screen = s, height=16 })

    -- Add widgets to the wibox - order matters
    my_top_wibox[s].widgets = {
       {
	  mylayoutbox[s],
	  separator,
	  mytaglist[s],
	  separator,
	  mypromptbox[s],
	  separator,
	  layout = awful.widget.layout.horizontal.leftright
       },
       {
	  separator,
--	  datewidget,
	  my_cal.widget,
	  separator,
	  task_warrior.widget,
	  separator,
	  s == 1 and mysystray or nil,
	  separator,
	  my_volume.widget,
	  separator,
	  my_net.widget,
	  separator,
	  mycore1.widget, mycore2.widget, mycore3.widget, mycore4.widget,
	  separator,
	  cpuwidget.widget,
	  separator,
	  memwidget.widget,
	  separator,
	  udisks_glue.widget,


	  layout = awful.widget.layout.horizontal.rightleft
       },
       {
	  separator,
	  mytasklist[s],
	  separator,
	  layout = awful.widget.layout.horizontal.rightleft
       },
       	  layout = awful.widget.layout.horizontal.leftright
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    awful.key({ modkey, "a"       }, "c",     function () awful.util.spawn(browser)     end),
    awful.key({ modkey, "a"       }, "t",     function () awful.util.spawn("thunderbird") end),
    awful.key({ modkey, "a"       }, "i",     function () awful.util.spawn("inkscape")  end),
    awful.key({ modkey, "a"       }, "g",     function () awful.util.spawn("gimp")      end),
    awful.key({ modkey, "a"       }, "v",     function () awful.util.spawn("VirtualBox") end),
    awful.key({ modkey, "a"       }, "u",     function () awful.util.spawn("/home/silkmoth/bin/UrbanTerror/ioq3-urt") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}
-- Compute the maximum number of digit we need, limited to 9
keynumber = 9
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
