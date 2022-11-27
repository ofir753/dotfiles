local M = {}

local naughty = require("naughty")
local gears = require("gears")
local awful = require("awful")
local function p(text, obj)
    naughty.notify({
        preset = naughty.config.presets.critical,
        text = gears.debug.dump_return(obj, text),
        title = "debug",
    })
end

local TMUX_PREFIX = 'T:'

local function rename_tag_across_screens(tag_index, name)
    local title = tostring(tag_index)
    if name ~= '' then
        title = title .. ' ' .. name
    end

    for s in screen do
        for _, t in ipairs(s.tags) do
            if t.index == tag_index then
                t.name = title
            end
        end
    end
end

local function tag_has_tmux_name(tag_index)
    for s in screen do
        if string.find(s.tags[tag_index].name, TMUX_PREFIX) then
            return true
        end
    end

    return false
end

local function rename_tag_by_tmux(tag)
    -- Don't override custom names
    if tag.name ~= tostring(tag.index) then
        if not string.find(tag.name or '', TMUX_PREFIX) then
            return
        end
    end

    local found = false
    for s in screen do
        for _, t in ipairs(s.tags) do
            if t.index == tag.index then
                for _, c in ipairs(t:clients()) do
                    local client_name = c and c.name or ''
                    if string.find(client_name, " %- TMUX$") then
                        session_name = string.gsub(client_name, " %- TMUX$", "")
                        session_name = string.gsub(session_name, "%-viewer$", "") -- Remove `-viewer` suffix
                        rename_tag_across_screens(tag.index, TMUX_PREFIX .. session_name)
                        found = true
                        break
                    end
                end
                if found then
                    break
                end
            end
        end
        if found then
            break
        end
    end

    -- Reset tag name if not tmux session not found
    if not found then
        rename_tag_across_screens(tag.index, '')
    end
end

local function switch_to_tag(screen, tag)
    if tag then
        local current_tag = screen.selected_tag
        tag:view_only()
        if current_tag then
            rename_tag_by_tmux(current_tag)
        end
        rename_tag_by_tmux(tag)
    end
end

function M.setup(kbdcfg, volume_widget, retain)
    local menubar = require("menubar")
    local hotkeys_popup = require("awful.hotkeys_popup")

    ALT_TAB_SWITCH = function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end

    globalkeys = gears.table.join(
        awful.key({ modkey, }, "s", hotkeys_popup.show_help,
            { description = "show help", group = "awesome" }),
        awful.key({ modkey, }, "Left", awful.tag.viewprev,
            { description = "view previous", group = "tag" }),
        awful.key({ modkey, }, "Right", awful.tag.viewnext,
            { description = "view next", group = "tag" }),
        awful.key({ modkey, }, "Escape", awful.tag.history.restore,
            { description = "go back", group = "tag" }),

        -- Change focus with modkey+hjkl
        awful.key({ modkey, }, "j",
            function()
                awful.client.focus.global_bydirection('down')
            end,
            { description = "focus down", group = "client" }
        ),
        awful.key({ modkey, }, "k",
            function()
                awful.client.focus.global_bydirection('up')
            end,
            { description = "focus up", group = "client" }
        ),
        awful.key({ modkey, }, "l",
            function()
                awful.client.focus.global_bydirection('right')
            end,
            { description = "focus right", group = "client" }
        ),
        awful.key({ modkey, }, "h",
            function()
                awful.client.focus.global_bydirection('left')
            end,
            { description = "focus left", group = "client" }
        ),

        -- Save env with retain
        awful.key({ modkey, "Control" }, "s",
            function()
                retain.tags.save_all()
            end,
            { description = "Save env with retain", group = "client" }
        ),

        -- Fix retain (delete tags after 9)
        awful.key({ modkey, "Control", "Shift" }, "s",
            function()
                for s in screen do
                    for _, t in ipairs(s.tags) do
                        if t.index > 9 then
                            t:delete()
                        end
                    end
                end
                retain.tags.save_all()
            end,
            { description = "Fix retain (delete tags after 9)", group = "client" }
        ),

        awful.key({ modkey, }, "w", function() mymainmenu:show() end,
            { description = "show main menu", group = "awesome" }),

        -- Layout manipulation
        awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
            { description = "swap with next client by index", group = "client" }),
        awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
            { description = "swap with previous client by index", group = "client" }),
        awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
            { description = "focus the next screen", group = "screen" }),
        awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
            { description = "focus the previous screen", group = "screen" }),
        awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
            { description = "jump to urgent client", group = "client" }),
        awful.key({ ALT, }, "Tab", ALT_TAB_SWITCH,
            { description = "go back", group = "client" }),
        awful.key({ modkey, }, "Tab", ALT_TAB_SWITCH,
            { description = "go back", group = "client" }),

        -- Change Language
        awful.key({ modkey, }, "space", kbdcfg.switch_next,
            { description = "Change Language", group = "awesome" }),

        -- Standard program
        awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
            { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, }, "b", function() awful.spawn('firefox') end,
            { description = "open firefox", group = "launcher" }),
        awful.key({ modkey, "Control" }, "r", awesome.restart,
            { description = "reload awesome", group = "awesome" }),
        awful.key({ modkey, "Shift" }, "q", awesome.quit,
            { description = "quit awesome", group = "awesome" }),

        awful.key({ modkey, "Control", }, "l", function() awful.tag.incmwfact(0.05) end,
            { description = "increase master width factor", group = "layout" }),
        awful.key({ modkey, "Control", }, "h", function() awful.tag.incmwfact(-0.05) end,
            { description = "decrease master width factor", group = "layout" }),
        awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
            { description = "increase the number of master clients", group = "layout" }),
        awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
            { description = "decrease the number of master clients", group = "layout" }),
        awful.key({ modkey, ALT }, "h", function() awful.tag.incncol(1, nil, true) end,
            { description = "increase the number of columns", group = "layout" }),
        awful.key({ modkey, ALT }, "l", function() awful.tag.incncol(-1, nil, true) end,
            { description = "decrease the number of columns", group = "layout" }),
        awful.key({ modkey, "Control", }, "space", function() awful.layout.inc(1) end,
            { description = "select next", group = "layout" }),
        awful.key({ modkey, "Control", "Shift" }, "space", function() awful.layout.inc(-1) end,
            { description = "select previous", group = "layout" }),

        awful.key({ modkey, "Control" }, "n",
            function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", { raise = true }
                    )
                end
            end,
            { description = "restore minimized", group = "client" }),

        -- Prompt
        awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
            { description = "run prompt", group = "launcher" }),

        awful.key({ modkey }, "x",
            function()
                awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            { description = "lua execute prompt", group = "awesome" }),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end,
            { description = "show the menubar", group = "launcher" })
    )

    clientkeys = gears.table.join(
        awful.key({ modkey, }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
            { description = "close", group = "client" }),
        awful.key({ modkey, }, "q", function(c) c:kill() end,
            { description = "close", group = "client" }),
        awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }),
        awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
            { description = "move to master", group = "client" }),
        awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
            { description = "move to screen", group = "client" }),
        awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
            { description = "toggle keep on top", group = "client" }),
        awful.key({ modkey, }, "n",
            function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end,
            { description = "minimize", group = "client" }),
        awful.key({ modkey, }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }),
        awful.key({ modkey, "Control" }, "m",
            function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }),
        awful.key({ modkey, "Shift" }, "m",
            function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            { description = "(un)maximize horizontally", group = "client" }),
        awful.key({ modkey, }, "z",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }),

        awful.key({ modkey, }, "F2",
            function()
                awful.prompt.run {
                    prompt       = "rename current tag: ",
                    text         = '',
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = function(name)
                        local selected = awful.tag.selected()
                        if name == nil then
                            rename_tag_by_tmux(selected)
                        else
                            rename_tag_across_screens(selected.index, name)
                        end
                    end,
                }
            end,
            { description = "rename tag", group = "awesome" }),

        -- Media Keys
        awful.key({ }, 'XF86AudioPlay', function () awful.util.spawn('playerctl play-pause') end, {description = "Play/Pause", group = "media"}),
        awful.key({ }, 'XF86AudioNext', function () awful.util.spawn('playerctl next') end, {description = "Next", group = "media"}),
        awful.key({ }, 'XF86AudioPrev', function () awful.util.spawn('playerctl previous') end, {description = "Prev", group = "media"}),
        awful.key({ }, 'XF86AudioRaiseVolume', function () volume_widget:inc(5) end, {description = "Raise Vol", group = "media"}),
        awful.key({ }, 'XF86AudioLowerVolume', function () volume_widget:dec(5) end, {description = "Lower Vol", group = "media"}),
        awful.key({ }, 'XF86AudioMute', function () volume_widget:toggle() end, {description = "Set Vol 0", group = "media"})
    )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it work on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            -- View tag on all screens
            awful.key({ modkey }, "#" .. i + 9,
                function()
                    local focused_screen = awful.screen.focused()
                    for s in screen do
                        -- First switch all other screens later the focused screen
                        if s ~= focused_screen then
                            switch_to_tag(s, s.tags[i])
                        end
                    end
                    switch_to_tag(focused_screen, focused_screen.tags[i])
                end,
                { description = "view tag #" .. i, group = "tag" }),
            -- View tag in current screen.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    switch_to_tag(screen, tag)
                end,
                { description = "view tag in current screen #" .. i, group = "tag" }),
            -- Toggle tag display.
            awful.key({ modkey, ALT }, "#" .. i + 9,
                function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        awful.tag.viewtoggle(tag)
                    end
                end,
                { description = "toggle tag #" .. i, group = "tag" }),
            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                    end
                end,
                { description = "move focused client to tag #" .. i, group = "tag" }),
            -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end,
                { description = "toggle focused client on tag #" .. i, group = "tag" })
        )
    end

    clientbuttons = gears.table.join(
        awful.button({}, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
        awful.button({ modkey }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({}, 3, function() mymainmenu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    ))
    -- }}}

    -- Set keys
    root.keys(globalkeys)
end

return M
