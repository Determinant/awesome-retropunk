local gears = require("gears")
local awful = require("awful")
local arules = require("awful.rules")
local naughty = require("naughty")
local menubar = require("menubar")
local wibox = require("wibox")
local vicious = require("vicious")
local lfs = require("lfs")
local cairo = require("lgi").cairo
local cairohack = require("myawesomewidgets.cairohack")
local mpdbox = require("myawesomewidgets.mpdbox")
local smartnetbox = require("myawesomewidgets.smartnetbox")
local cputide = require("myawesomewidgets.cputide")
local gputide = require("myawesomewidgets.gputide")
local memwatermark = require("myawesomewidgets.memwatermark")
require("awful.autofocus")

local function shorten_str(s, len)
    if string.len(s) > len then
        s = string.sub(s, 0, len - 1) .. ".."
    end
    return s
end

local beautiful = require("beautiful")
beautiful.init(require("theme"))

local function actual_px(px) return (beautiful.scale_factor or 1) * px end

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

local terminal = "alacritty"
local modkey = "Mod4"

local layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

naughty.config.presets = {
    critical = {
        bg = beautiful.notification_critical_bg,
        border_color = beautiful.notification_critical_border_color,
        timeout = 0
    }
}

naughty.config.defaults = {
    timeout = 10,
    -- screen = 1,
    position = "top_right",
    margin = actual_px(8),
    gap = actual_px(1),
    ontop = true,
    icon = nil,
    hover_timeout = nil
}

naughty.config.notify_callback = function(args)
    lines = {}
    text = args.text
    if args.urgency == "critical" then
        args.bg = beautiful.notification_critical_bg
        args.border_color = beautiful.notification_critical_border_color
    end
    if text == nil then
        text = args.message
    end
    for s in text:gmatch("[^\r\n]+") do
        if #lines >= 10 then
            table.insert(lines, "...")
            break
        end
        table.insert(lines, shorten_str(s, 80))
    end
    args.text = table.concat(lines, "\n")
    return args
end

local mycputide = wibox.widget {
    layout = wibox.container.margin,
    left = 5,
    right = 5,
    {
        layout = wibox.layout.flex.vertical,
        cputide()
    }
}

local mygputide = wibox.widget {
    layout = wibox.container.margin,
    left = 0,
    right = 5,
    {
        layout = wibox.layout.flex.vertical,
        gputide()
    }
}

local mymemwatermark = memwatermark()
local mysmartnetbox = smartnetbox()

local mympdbox = wibox.widget {
    widget = wibox.container.background,
    opacity = 0.8,
    mpdbox()
}

local tray_widget = wibox.widget {
    {
        {
            {
                widget = wibox.widget.systray,
            },
            left = actual_px(6),
            top = actual_px(1),
            bottom = actual_px(1),
            right = actual_px(6),
            widget = wibox.container.margin
        },
        widget = wibox.container.background,
        shape = gears.shape.rounded_bar,
        bg = beautiful.bg_systray
    },
    top = actual_px(1),
    bottom = actual_px(1),
    widget = wibox.container.margin
}

local clock_widget = wibox.widget {
    left = actual_px(5),
    right = actual_px(5),
    wibox.widget.textclock(
        string.format("<span color='%s'>%%a</span> <span color='%s'>%%b %%d</span> %%H:%%M:%%S",
        beautiful.yellow1, beautiful.orange1), 1),
    layout = wibox.container.margin
}

--local chrome_icon = gears.surface.load("/home/ymf/Downloads/Pixel-Theme/apps/scalable/chrome.svg")

menubar.utils.terminal = terminal

local mywibox = {}
local mypromptbox = {}
local mylayoutbox = {}
local mytaglist = {}
local mytasklist = {}

mytaglist.buttons = awful.util.table.join(
    awful.button({}, 1, awful.tag.viewonly),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({}, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients()
        end
    end),
    awful.button({}, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({}, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))

beautiful.tasklist_plain_task_name = true

local function bkdr_hash(s, n)
    local seed = 13
    local hash = 0
    for c in s:gmatch"." do
        hash = ((hash * seed) + string.byte(c)) % n
    end
    return hash
end

awful.screen.connect_for_each_screen(function(s)
    if beautiful.wallpaper then
        if type(beautiful.wallpaper) == "table" then
            gears.wallpaper.centered(beautiful.wallpaper[s.index], s, beautiful.bg_normal, 1)
        else
            gears.wallpaper.centered(beautiful.wallpaper, s, beautiful.bg_normal, 1)
        end
    end
    local tag_cfg = beautiful.tags[s.index]
    local cfg = beautiful.tags[1]
    if tag_cfg then
        cfg = tag_cfg
    end
    awful.tag(cfg.names, s, cfg.layout)
    if beautiful.screen_callback then
        beautiful.screen_callback(s)
    end
    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
        awful.util.table.join(
        awful.button({}, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({}, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({}, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({}, 5, function () awful.layout.inc(layouts, -1) end)))

    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = mytaglist.buttons
    })
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        style = {
            shape = gears.shape.rounded_bar
        },
        layout = {
            spacing = actual_px(3),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = 'background_role',
                            widget = wibox.widget.imagebox,
                        },
                        top = actual_px(4),
                        bottom = actual_px(4),
                        left = actual_px(4),
                        right = actual_px(3),
                        widget  = wibox.container.margin,
                    },
                    {
                        {
                            widget = wibox.widget.textbox,
                            font = beautiful.minor_font or "pixel 8"
                        },
                        top = actual_px(2),
                        right = actual_px(2),
                        layout = wibox.container.margin
                    },
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = actual_px(1),
                right = actual_px(2),
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function (self, c, index, clients)
                local iconbox = self.children[1].children[1].children[1].children[1]
                local col
                if c.icon == nil then
                    local palette = {
                        {0.98, 0.74, 0.18, 1},
                        {1, 0.5, 0.1, 1},
                        {0.800, 0.141, 0.114, 1},
                        {0.596, 0.592, 0.102, 1},
                        {0.843, 0.600, 0.129, 1},
                        {0.271, 0.522, 0.533, 1},
                        {0.694, 0.384, 0.525, 1},
                        {0.408, 0.616, 0.416, 1}
                    }

                    col = {palette[bkdr_hash(c.class, #palette) + 1]}
                else
                    local s = gears.surface(c.icon)
                    local t = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
                    local cr = cairo.Context(t)
                    cr:set_source_surface(s, 0, 0)
                    cr:paint()

                    col = cairohack.downsample(t:get_data(), t:get_width(), t:get_height());
                end
                local l = math.ceil(actual_px(beautiful.main_height * 0.6))
                local icon = cairo.ImageSurface.create(cairo.Format.ARGB32, 16, 16)
                local cr = cairo.Context(icon)
                local pos = {
                    {0, 0, 4, l},
                    {4, 0, 8, l},
                    {8, 0, 12, l},
                    {12, 0, 16, l},
                    --{0, 0, l - 1, l - 1},
                    --{0, l, l - 1, 2 * l - 1},
                    --{l, 0, 2 * l - 1, l - 1},
                    --{l, l, 2 * l - 1,  2 * l - 1}
                }
                cr:set_line_width(1)
                cr:set_antialias(cairo.Antialias.NONE)
                for i, p in ipairs(pos) do
                    if col[i] == nil or col[i][4] < 0.05 then
                        break
                    end
                    cr:set_source_rgb(col[i][1], col[i][2], col[i][3])
                    cr:rectangle(p[1], p[2], p[3], p[4])
                    --cr:stroke_preserve()
                    cr:fill()
                end
                iconbox:set_image(icon)
                c.update_status_icon = function(name)
                    if name ~= nil then
                        c.__status_icon = name
                    end
                    local mk = c.__status_icon
                    if c.isfocused then
                        mk = string.format("<span color='%s'>%s</span>", beautiful.fg_focus, mk)
                    end
                    self.children[1].children[1].children[2].children[1]:set_markup(mk)
                end
            end,
            update_callback = function (self, c, index, clients)
                local name = ""
                if c.maximized_horizontal then
                    name = name .. "&#xe10a;"
                end
                if c.maximized_vertical then
                    name = name .. "&#xe108;"
                end
                if c.maximized then
                    name = name .. "&#xe105;"
                end
                if c.minimized then
                    name = name .. "&#xe079;"
                end
                if c.floating then
                    name = name .. "&#xe1b4;"
                end
                c.update_status_icon(name)
            end
        },
        buttons = mytasklist.buttons,
    })
    s.mywibox = awful.wibar({ position = "top", screen = s, height = actual_px(beautiful.main_height) })

    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(s.mytaglist)
    left_layout:add(mycputide)
    left_layout:add(mygputide)
    left_layout:add(mymemwatermark)
    left_layout:add(mysmartnetbox)
    left_layout:add(mympdbox)
    left_layout:add(wibox.widget {
        s.mypromptbox,
        awful.widget.prompt(),
        layout = wibox.container.margin,
        left = actual_px(3)
    })

    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(tray_widget)
    right_layout:add(clock_widget)
    right_layout:add(s.mylayoutbox)

    local layout = wibox.layout.align.horizontal()
    local tasklist = wibox.widget {
        s.mytasklist,
        layout = wibox.container.margin,
        margins = actual_px(3)
    }
    layout:set_left(left_layout)
    layout:set_middle(tasklist)
    layout:set_right(right_layout)
    s.mywibox:set_widget(layout)
end)

mouse.screen = screen.primary
mouse.coords({ x = screen.primary.geometry.width / 2, y = screen.primary.geometry.height / 2 })

root.buttons(awful.util.table.join(
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

function focus_switch(dir, fallback)
    return function ()
        awful.client.focus.byidx(fallback)
        if client.focus then client.focus:raise() end
    end
end

function focus_switch_by_idx(idx)
    return function ()
        local c = awful.screen.focused():get_clients(false)[idx]
        if c == nil then return end
        client.focus = c
        c:raise()
    end
end

local global_keys = awful.util.table.join(
    awful.key({modkey}, "Left",   awful.tag.viewprev),
    awful.key({modkey}, "Right",  awful.tag.viewnext),
    awful.key({modkey}, "Escape", awful.tag.history.restore),

    awful.key({modkey}, "j", focus_switch("down", 1)),
    awful.key({modkey}, "k", focus_switch("up", -1)),
    awful.key({modkey}, "q", focus_switch_by_idx(1)),
    awful.key({modkey}, "w", focus_switch_by_idx(2)),
    awful.key({modkey}, "e", focus_switch_by_idx(3)),
    awful.key({modkey}, "r", focus_switch_by_idx(4)),
    awful.key({modkey}, "t", focus_switch_by_idx(5)),

    awful.key({modkey, "Shift"  }, "p", function () mympdbox.children[1].mpc_conn:toggle_play() end),
    awful.key({modkey, "Shift"  }, ".", function () mympdbox.children[1].mpc_conn:send("next") end),
    awful.key({modkey, "Shift"  }, ",", function () mympdbox.children[1].mpc_conn:send("previous") end),
    awful.key({modkey, "Shift"  }, "f", function () mympdbox.children[1].mpc_conn:send("seekcur +1") end),
    awful.key({modkey, "Shift"  }, "b", function () mympdbox.children[1].mpc_conn:send("seekcur -1") end),

    awful.key({modkey, "Shift"  }, "j", function () awful.client.swap.byidx(1)    end),
    awful.key({modkey, "Shift"  }, "k", function () awful.client.swap.byidx(-1)    end),
    awful.key({modkey, "Control"}, "j", function () awful.screen.focus_relative(1) end),
    awful.key({modkey, "Control"}, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({modkey, "Control"}, "m", function (c)
        local c = awful.client.getmaster()
        client.focus = c
        c:raise()
    end),
    awful.key({modkey}, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    awful.key({modkey}, "Return", function () awful.spawn(terminal) end),
    awful.key({modkey, "Control"}, "r", awesome.restart),
    awful.key({modkey, "Shift"  }, "q", awesome.quit),

    awful.key({modkey}, "l", function () awful.tag.incmwfact(0.05)    end),
    awful.key({modkey}, "h", function () awful.tag.incmwfact(-0.05)    end),
    awful.key({modkey, "Shift"}, "h", function () awful.tag.incnmaster(-1) end),
    awful.key({modkey, "Shift"}, "l", function () awful.tag.incnmaster(1) end),
    awful.key({modkey, "Control"}, "h", function () awful.tag.incncol(-1) end),
    awful.key({modkey, "Control"}, "l", function () awful.tag.incncol(1) end),
    awful.key({modkey}, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({modkey, "Shift"}, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({modkey, "Control"}, "n", awful.client.restore),

    awful.key({modkey, "Shift"}, "r", function () awful.screen.focused().mypromptbox:run() end),

    awful.key({modkey}, "x", function ()
        awful.prompt.run({ prompt = "Run Lua code: " },
        awful.screen.focused().mypromptbox.widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),
    awful.key({modkey}, "p", function () menubar.show() end))

local client_keys = awful.util.table.join(
    awful.key({modkey}, "f", function (c) c.fullscreen = not c.fullscreen end),
    awful.key({modkey, "Shift"}, "c", function (c) c:kill() end),
    awful.key({modkey, "Control"}, "space",  awful.client.floating.toggle),
    awful.key({modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({modkey}, "o",      function(c) c:move_to_screen() end),
    awful.key({modkey}, "n", function (c)
        c.minimized = true
    end),
    awful.key({modkey}, "m", function (c)
        c.maximized_horizontal = false
        c.maximized_vertical = false
        local max = c.maximized
        if max then
            c.maximized = false
        else
            c.maximized = true
        end
    end),
    awful.key({modkey}, "Up", function (c)
        if c.maximized then
            c.maximized = false
        end
        c.maximized_horizontal = not c.maximized_horizontal
    end),
    awful.key({modkey}, "Down", function (c)
        if c.maximized then
            c.maximized = false
        end
        c.maximized_vertical = not c.maximized_vertical
    end))

for i = 1, 9 do
    global_keys = awful.util.table.join(global_keys,
        awful.key({modkey}, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            if screen.tags[i] then
                screen.tags[i]:view_only()
            end
        end),
        awful.key({modkey, "Control"}, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            if screen.tags[i] then
                awful.tag.viewtoggle(screen.tags[i])
            end
        end),
        awful.key({modkey, "Shift"}, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            if screen and screen.tags[i] then
                client.focus:move_to_tag(screen.tags[i])
            end
        end),
        awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            if screen and screen.tags[i] then
                client.focus:toggle_tag(screen.tags[i])
            end
        end))
end

local client_buttons = awful.util.table.join(
    awful.button({}, 1, function (c) client.focus = c; c:raise() end),
    awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize))

root.keys(global_keys)
arules.rules = {
    {
        rule = {},
        properties = {border_width = actual_px(beautiful.border_width),
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    keys = client_keys,
                    buttons = client_buttons,
                    screen = awful.screen.focused,
                    maximized_horizontal = false,
                    maximized_vertical = false,
                    maximized = false}
    },
    table.unpack(beautiful.rules)
}

client.connect_signal("manage", function (c, startup)
    if not startup then
        if not c.size_hints.user_position and
            not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c)
    c.isfocused = true
    if c.update_status_icon ~= nil then
        c.update_status_icon(nil)
    end
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.isfocused = false
    if c.update_status_icon ~= nil then
        c.update_status_icon(nil)
    end
    c.border_color = beautiful.border_normal
end)

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                        title = "Oops, an error happened!",
                        text = err })
        in_error = false
    end)
end

local function processwalker()
    local function yieldprocess()
        for dir in lfs.dir("/proc") do
            -- All directories in /proc containing a number, represent a process
            if tonumber(dir) ~= nil then
                local f, err = io.open("/proc/"..dir.."/cmdline")
                if f then
                    local cmdline = f:read("*all")
                    f:close()
                    if cmdline ~= "" then
                        coroutine.yield(cmdline)
                    end
                end
            end
        end
    end
    return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
    assert(type(process) == "string")
    local regex_killer = {
        ["+"]  = "%+", ["-"] = "%-",
        ["*"]  = "%*", ["?"]  = "%?" }

        for p in processwalker() do
            if p:find(process:gsub("[-+?*]", regex_killer)) then
                return
            end
        end
        return awful.spawn(cmd or process)
end

--run_once("picom")
