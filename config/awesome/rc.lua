-- awesome 3 configuration file

-- Include awesome library, with lots of useful function!
require("awful")
require("tabulous")
require("beautiful")
require("wicked")

-- {{{ Variable definitions
-- This is a file path to a theme file which will defines colors.
theme_path = "/usr/local/share/awesome/themes/default"

-- This is used later as the default terminal to run.
terminal = "gnome-terminal --window"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    "tile",
    "tileleft",
    "tilebottom",
    "tiletop",
    "magnifier",
    "max",
    "spiral",
    "dwindle",
    "floating"
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and workspace indices.
apptags =
{
    -- ["Firefox"] = { screen = 1, tag = 2 },
    -- ["mocp"] = { screen = 2, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Initialization
-- Initialize theme (colors).
beautiful.init(theme_path)

-- Register theme in awful.
-- This allows to not pass plenty of arguments to each function
-- to inform it about colors we want it to draw.
awful.beautiful.register(beautiful)

-- Uncomment this to activate autotabbing
tabulous.autotab_start()
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = layouts[1] })
        -- Add tags to screen one by one
        tags[s][tagnumber].mwfact = 0.618033988769
        tags[s][tagnumber].screen = s
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}

-- {{{ Statusbar
-- Create a taglist widget
mytaglist = widget({ type = "taglist", name = "mytaglist" })
mytaglist:mouse_add(mouse({}, 1, function (object, tag) awful.tag.viewonly(tag) end))
mytaglist:mouse_add(mouse({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end))
mytaglist:mouse_add(mouse({}, 3, function (object, tag) tag.selected = not tag.selected end))
mytaglist:mouse_add(mouse({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end))
mytaglist:mouse_add(mouse({ }, 4, awful.tag.viewnext))
mytaglist:mouse_add(mouse({ }, 5, awful.tag.viewprev))
mytaglist.label = awful.widget.taglist.label.all

-- Create a tasklist widget
mytasklist = widget({ type = "tasklist", name = "mytasklist" })
mytasklist:mouse_add(mouse({ }, 1, function (object, c) c:focus_set(); c:raise() end))
mytasklist:mouse_add(mouse({ }, 4, function () awful.client.focusbyidx(1) end))
mytasklist:mouse_add(mouse({ }, 5, function () awful.client.focusbyidx(-1) end))
mytasklist.label = awful.widget.tasklist.label.currenttags

-- Create a textbox widget
mytextbox = widget({ type = "textbox", name = "mytextbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> awesome " .. AWESOME_VERSION .. " </small></b>"
mypromptbox = widget({ type = "textbox", name = "mypromptbox", align = "left" })

-- Create an iconbox widget
myiconbox = widget({ type = "textbox", name = "myiconbox", align = "left" })
myiconbox.text = "<bg image=\"/usr/local/share/awesome/icons/awesome16.png\" resize=\"true\"/>"

-- Create a systray
mysystray = widget({ type = "systray", name = "mysystray", align = "right" })
mysystray.bg = '#333333'

-- Mem Graph
memgraphwidget = widget({
    type = 'graph',
    name = 'memgraphwidget',
    align = 'right'
})

memgraphwidget.height = 0.95
memgraphwidget.width = 45
memgraphwidget.bg = '#333333'
memgraphwidget.border_color = '#0a0a0a'
memgraphwidget.grow = 'left'
memgraphwidget:plot_properties_set('mem', {
    fg = '#08AEC6',
    fg_center = '#772855',
    fg_end = '#772855',
    vertical_gradient = false
})

wicked.register(memgraphwidget, 'mem', '$1', 1, 'mem')

-- Date
datewidget = widget({
    type = 'textbox',
    name = 'datewidget',
    align = 'right'
})

wicked.register(datewidget, 'date', '%a %d/%m %R %Z');

-- Load AVG
loadavgwidget = widget({
    type = 'textbox',
    name = 'loadavgwidget',
    align = 'right'
})

wicked.register(loadavgwidget, 'function', function (widget, args)
   local f = io.popen('cat /proc/loadavg')
   local l = f:lines()
   local v = ''

   for line in l do
      p = line:match('(%S*%s%S*%s%S*)', 0)
   end

   f:close()

   return ' <span color=\'white\'>load</span>: ' .. p .. ' | '
end, 4)

-- Execute command and return its output. You probably wan't only execute commands with one
-- line of output
function execute_command(command)
   local fh = io.popen(command)
   local str = ""
   for i in fh:lines() do
      str = str .. i
   end
   io.close(fh)
   return str
end

cpuwidget = {}
cpugraphwidget = {}

function get_cpu_speed(n)
   local f = io.popen('cpufreq-info -f')
   local l = f:lines()
   local v = ''

   for line in l do
      p = line:match('(.*)000', 0)
   end

   f:close()

   return p
end

function get_cpu_gov_short(n)
   local s = execute_command('cat /sys/devices/system/cpu/cpu'..n..'/cpufreq/scaling_governor')

   if s == "powersave" then return 'PS' end
   if s == "ondemand" then return  'OD' end

   if s == "conservative" then return  'CO' end
   if s == "userspace"    then return  'US' end
   if s == "performance"  then return  'PE' end
   return s
end
      
function get_cpu_widgets (n)
   -- Cpu Graph
   cpugraphwidget[n] = widget({
				 type = 'graph',
				 name = 'cpugraphwidget',
				 align = 'right'
			      })
   
   cpugraphwidget[n].height = 0.95
   cpugraphwidget[n].width = 45
   cpugraphwidget[n].bg = '#333333'
   cpugraphwidget[n].border_color = '#0a0a0a'
   cpugraphwidget[n].grow = 'left'
   
   cpugraphwidget[n]:plot_properties_set('cpu', {
					    fg = '#AEC6D8',
					    fg_center = '#285577',
					    fg_end = '#285577',
					    vertical_gradient = false
					 })
   
   wicked.register(cpugraphwidget[n], 'cpu', '$1', 1, 'cpu')

   -- CPU 
   cpuwidget[n] = widget({
			    type = 'textbox',
			    name = 'cpuwidget',
			    align = 'right'
			 })

   wicked.register(cpuwidget[n], 'function', function (widget, args)
   n = 0
   gov = get_cpu_gov_short(n)
   speed = get_cpu_speed(n)
   
   r =      ' <span color=\'white\'>cpu[' .. n .. ']</span>:'
   r = r .. ' <span color=\'green\'>'.. speed..'</span>Mhz '
   r = r .. gov..' ' 
   return r
end, 5)
   
   return {cpuwidget[n]; cpugraphwidget[n]};
end

get_cpu_widgets(0);

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget({ type = "textbox", name = "mylayoutbox", align = "right" })
    mylayoutbox[s]:mouse_add(mouse({ }, 1, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 3, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 4, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 5, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s].text = "<bg image=\"/usr/local/share/awesome/icons/layouts/tilew.png\" resize=\"true\"/>"
end

-- Create a statusbar for each screen and add it
mystatusbar = {}
for s = 1, screen.count() do
    mystatusbar[s] = statusbar({ position = "top", name = "mystatusbar" .. s,
                                   fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the statusbar - order matters
    mystatusbar[s].widgets =
       {
       mytaglist,
       mytasklist,
       mypromptbox,
       loadavgwidget,
       cpuwidget[0],
       cpugraphwidget[0],
       memgraphwidget,
       datewidget,
       --        mytextbox,
       mylayoutbox[s],
       s == screen.count() and mysystray or nil
    }
    
    mystatusbar[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
awesome.mouse_add(mouse({ }, 3, function () awful.spawn(terminal) end))
awesome.mouse_add(mouse({ }, 4, awful.tag.viewnext))
awesome.mouse_add(mouse({ }, 5, awful.tag.viewprev))
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local sel = client.focus_get()
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.movetotag(tags[sel.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, "F" .. i,
                   function ()
                       local sel = client.focus_get()
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.toggletag(tags[sel.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey, "Shift" }, "Left", awful.tag.viewprev):add()
keybinding({ modkey, "Shift" }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "Return", function () awful.spawn(terminal) end):add()

keybinding({ modkey, "Control" }, "r", awesome.restart):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey, "Shift" }, "c", function () client.focus_get():kill() end):add()
keybinding({ modkey }, "j", function () awful.client.focusbyidx(1); client.focus_get():raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focusbyidx(-1);  client.focus_get():raise() end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () client.focus_get():swap(awful.client.master()) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "space", function ()
                                     awful.prompt({ prompt = "Run: " }, mypromptbox, awful.spawn, awful.completion.bash)
                                 end):add()
keybinding({ modkey, "Shift" }, "4", function ()
                                     awful.prompt({ prompt = "Run Lua code: " }, mypromptbox, awful.eval)
                                 end):add()

--- Tabulous, tab manipulation
keybinding({ modkey, "Control" }, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)

    if not tabbedview then
        tabbedview = tabulous.tabindex_get(nextclient)

        if not tabbedview then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus_get())
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end):add()

keybinding({ modkey, "Shift" }, "y", tabulous.untab):add()

keybinding({ modkey }, "y", function ()
   local tabbedview = tabulous.tabindex_get()

   if tabbedview then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()
keybinding({ modkey, 'Shift' }, "t", function ()
    local tabbedview = tabulous.tabindex_get()
    local clients = awful.client.getmarked()

    if not tabbedview then
        tabbedview = tabulous.tab_create(clients[1])
        table.remove(clients, 1)
    end

    for k,c in pairs(clients) do
        tabulous.tab(tabbedview, c)
    end

end):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
function hook_focus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end

-- Hook function to execute when unfocusing a client.
function hook_unfocus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end

-- Hook function to execute when marking a client
function hook_marked(c)
    c.border_color = beautiful.border_marked
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c.border_color = beautiful.border_focus
end

-- Hook function to execute when the mouse is over a client.
function hook_mouseover(c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier" then
        c:focus_set()
    end
end

-- Hook function to execute when a new client appears.
function hook_manage(c)
    -- Set floating placement to be smart!
    c.floating_placement = "smart"
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:mouse_add(mouse({ }, 1, function (c) c:focus_set(); c:raise() end))
    c:mouse_add(mouse({ modkey }, 1, function (c) c:mouse_move() end))
    c:mouse_add(mouse({ modkey }, 3, function (c) c:mouse_resize() end))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    c:focus_set()

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Honor size hints
    c.honorsizehints = true
end

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    mylayoutbox[screen].text =
        "<bg image=\"/usr/local/share/awesome/icons/layouts/" .. awful.layout.get(screen) .. "w.png\" resize=\"true\"/>"

    -- If no window has focus, give focus to the latest in history
    if not client.focus_get() then
        local c = awful.client.focus.history.get(screen, 0)
        if c then c:focus_set() end
    end

    -- Uncomment if you want mouse warping
    --[[
    local sel = client.focus_get()
    if sel then
        local c_c = sel.coords
        local m_c = mouse.coords

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords = { x = c_c.x + 5, y = c_c.y + 5}
            end
        end
    end
    ]]
end

--[[ Hook called every second
function hook_timer ()
    -- For unix time_t lovers
    mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    -- mytextbox.text = " " .. os.date() .. " "
end
--]]
-- Set up some hooks
awful.hooks.focus.register(hook_focus)
awful.hooks.unfocus.register(hook_unfocus)
awful.hooks.marked.register(hook_marked)
awful.hooks.unmarked.register(hook_unmarked)
awful.hooks.manage.register(hook_manage)
awful.hooks.mouseover.register(hook_mouseover)
awful.hooks.arrange.register(hook_arrange)
-- awful.hooks.timer.register(1, hook_timer)
-- }}}
