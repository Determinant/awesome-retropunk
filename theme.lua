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

theme = {}
theme.wallpaper = "~/Pictures/bg/paprika.jpg"
theme.orange1 = orange1
theme.yellow1 = yellow1

theme.font = "pixel 10"
theme.notification_font = theme.font
theme.notification_icon_size = 32
theme.notification_border_width = 2

theme.fg_normal = foreground1
theme.fg_focus  = foreground2
theme.fg_urgent = red1
theme.bg_normal = background1 .. "ea"
theme.bg_focus  = background1 .. "ea"
theme.bg_urgent = background1 .. "ea"
theme.bg_systray = background1 .. "ea"

theme.tasklist_bg_focus  = "#00000020"
theme.tasklist_bg_normal = "#ffffff0a"

theme.notification_bg = background2 .. "df"
theme.notification_fg = theme.fg_tooltip
theme.notification_border_color = background3
theme.notification_critical_bg = orange2 .. "df"
theme.notification_critical_border_color = orange1

theme.cputide_bg_color = background4
theme.cputide_low_color = yellow1
theme.cputide_high_color = "#ff0000"

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
theme.memwatermark_height = 28
theme.mpdbox_width = 100
theme.main_height = 26
theme.menu_height = 20
theme.menu_width = 250

return theme