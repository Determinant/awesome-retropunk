-------------------------------
--  RetroPunk awesome theme  --
--  By Ted Yin (Determinant) --
-------------------------------

local orange1 = "#fe8019"
local orange2 = "#d65d0e"
local yellow1 = "#fabd2f"
local red1 = "#fb4934"
local foreground1 = "#ebdbb2"
local foreground2 = "#fbf1c7"
local background1 = "#282828"
local background2 = "#32302f"
local background3 = "#3c3836"
local background4 = "#504945"

local max_screen_width = 0
for s in screen do
    if s.geometry.width > max_screen_width then
        max_screen_width = s.geometry.width
    end
end

local dpi = 96
local scale_factor = 1
local env_mydpi = os.getenv("MYDPI")
if env_mydpi ~= nil then
    dpi = env_mydpi
end

theme = {}
theme.scale_factor = dpi / 96
theme.wallpaper = "~/Pictures/bg/paprika.jpg"
theme.orange1 = orange1
theme.yellow1 = yellow1

theme.font = (hidpi and "pixel 10") or "pixel 10"
theme.minor_font = (hidpi and "pixel 10") or "pixel 9"
theme.notification_font = theme.font
theme.notification_icon_size = 32
theme.notification_border_width = 2

theme.fg_normal = foreground1
theme.fg_focus  = background1
theme.fg_urgent = red1
theme.bg_normal = background1 .. "ea"
theme.bg_focus  = background1 .. "ea"
theme.bg_urgent = background1 .. "ea"
theme.bg_systray = background1 .. "ea"

theme.tasklist_bg_focus  = foreground1
theme.tasklist_bg_normal = background2
theme.taglist_bg_focus = foreground1

theme.notification_bg = background2 .. "df"
theme.notification_fg = theme.fg_tooltip
theme.notification_border_color = background3
theme.notification_critical_bg = orange2 .. "df"
theme.notification_critical_border_color = orange1

theme.cputide_bg_color = background4
theme.cputide_low_color = yellow1
theme.cputide_high_color = "#ff0000"

theme.gputide_bg_color = background4
theme.gputide_low_color = yellow1
theme.gputide_high_color = "#ff0000"

theme.memwatermark_bg_color = theme.cputide_bg_color
theme.memwatermark_graph_color = {
    type = "linear",
    from = {0, 0},
    to = {50, 0},
    stops = {{0, yellow1},
    {0.3, red1},
    {1, red1}}
}

theme.smartnetbox_color1 = yellow1
theme.smartnetbox_color2 = orange1

theme.mpdbox_color1 = theme.smartnetbox_color1
theme.mpdbox_color2 = theme.smartnetbox_color2
theme.mpdbox_bg_progress = {
    type = "linear",
    from = {0, 0},
    to = {100, 0},
    stops = {{0, yellow1 .. "88"},
            {1, red1 .. "44" }}
}

theme.border_width  = 0
theme.border_normal = background1
theme.border_focus  = background1
theme.border_marked = background1

theme.taglist_squares_sel   = "/usr/share/awesome/themes/zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/zenburn/taglist/squarez.png"
theme.awesome_icon = "/usr/share/awesome/themes/zenburn/awesome-icon.png"

theme.layout_tile       = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/zenburn/layouts/tileleft.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/zenburn/layouts/tiletop.png"
theme.layout_fairv      = "/usr/share/awesome/themes/zenburn/layouts/fairv.png"
theme.layout_fairh      = "/usr/share/awesome/themes/zenburn/layouts/fairh.png"
theme.layout_spiral     = "/usr/share/awesome/themes/zenburn/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/zenburn/layouts/dwindle.png"
theme.layout_max        = "/usr/share/awesome/themes/zenburn/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/zenburn/layouts/magnifier.png"
theme.layout_floating   = "/usr/share/awesome/themes/zenburn/layouts/floating.png"

theme.systray_icon_spacing = 2
theme.cputide_height = 28
theme.cputide_width = 56
theme.memwatermark_height = 28
theme.memwatermark_width = (hidpi and 45) or 40
theme.mpdbox_width = 100
theme.main_height = 26
theme.menu_height = 20
theme.menu_width = 250
theme.siji_icon_padding = (hidpi and 0) or 2

return theme
