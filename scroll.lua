---------------------------------------------------------------------------
-- @author Saleur Geoffrey
-- @copyright 2015 Saleur Geoffrey
-- @release @AWESOME_VERSION@
-- @classmod wibox.layout.autoscroll
---------------------------------------------------------------------------

local pairs = pairs
local type = type
local setmetatable = setmetatable
local base = require("wibox.layout.base")
local widget_base = require("wibox.widget.base")
local gears_timer = require("gears")
local math = math

local scroll = { mt = {} }

--- Draw a scroll layout
function scroll:draw(wibox, cr, width, height)
    local abs_x,width_busy
    if not self.widget then
        return
    end
    if self._wg > width then
        if self._scrolled and not self._scrolltimer.started then
            self._scrolltimer:start()
        end
    end
    abs_x = math.abs(self._x)
    if abs_x - self._space_width > self._wg then
        self._x = self._wg+self._x+self._space_width
        abs_x = math.abs(self._x)
    end
    -- Drawn end of widget => (width-self._x > self._wg and self._wg or width-self._x ) else we draw the widget in the entire width allocated width-self._x
    base.draw_widget(wibox, cr, self.widget, self._x, 0,(self._expanded and width-self._x or (width-self._x > self._wg and self._wg or width-self._x )), height)
    width_busy = self._wg - abs_x
    if self._wg > width and width_busy < width + self._space_width then
        base.draw_widget(wibox, cr, self.widget, width_busy+self._space_width, 0,width - self._space_width- width_busy, height)
    end
end

--- Set space width of widget
function scroll:spaceWidth(space)
    self._space_width = space
    self:emit_signal("widget::updated")
end

--- Set x move
function scroll:deltaX(x)
    self._deltax = x
end

--- Move a widget
function scroll:scroll()
    self._x = self._x - self._deltax
    self:emit_signal("widget::updated")
end

--- Reset move
function scroll:resetScroll()
    self._x = 0
    self:emit_signal("widget::updated")
end

--- Set auto scrolled
function scroll:auto(enable)
    if not enable then
      if self._scrolltimer.started then
        self._scrolltimer:stop()
      end
    end
    self._scrolled = enable
    self:emit_signal("widget::updated")
end

--- Set expanded
function scroll:expand(enable)
    self._expanded = enable
    self:emit_signal("widget::updated")
end

--- Fit a scroll layout into the given space
function scroll:fit(width, height)
    local w, h,wg,hg
    if self.widget then
        -- grab real size of widget
        wg,hg = base.fit_widget(self.widget, 2^1024, 2^1024)
        self._wg = wg
        self._hg = hg
        w = self._width and math.min(width,self._width) or width
        w = w and math.min(w,wg) or wg
        h = h and math.min(h,hg) or hg
    else
        w, h = 0, 0
    end

    return w, h
end

--- Set the widget that this layout adds a constraint on.
function scroll:set_widget(widget)
    if self.widget then
        self.widget:disconnect_signal("widget::updated", self._emit_updated)
    end
    if widget then
        widget_base.check_widget(widget)
        widget:connect_signal("widget::updated", self._emit_updated)
    end
    self.widget = widget
    self:emit_signal("widget::updated")
end

--- Set the maximum width to val.
function scroll:set_width(val)
    self._width = val
    self:emit_signal("widget::updated")
end

--- Set timeout to val.
function scroll:set_timeout(val)
    self._scrolltimer.timeout = val
    self:emit_signal("widget::updated")
end

--- Returns a new scroll layout. This layout will constraint the size of a
-- widget according according max width and auto-scroll a widget if necessary.
-- @param[opt] widget A widget to use.
-- @param[opt] deltax A deltax move to use.
-- @param[opt] space The space between the end and the beginning of the widget.
-- @param[opt] width The maximum width of the widget. nil for no limit.
-- @param[opt] autoscroll Set auto scrolled.
-- @param[opt] expanded Set expanded. If a widget has a backgroud-color, the background-color is expanded for between
-- @param[opt] time Set timeout.
-- the end and the beginning of the widget.
local function new(widget, deltax, space, width, autoscroll, expanded, time)
    local ret = widget_base.make_widget()

    for k, v in pairs(scroll) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret._x = 0
        if ret._scrolltimer.started then
            ret._scrolltimer:stop()
        end
        ret:emit_signal("widget::updated")
    end

    ret._x = 0
    ret:deltaX(deltax or 1)
    ret:spaceWidth(space or 0)
    ret._scrolltimer = timer({ timeout = time or 1 })
    ret._scrolltimer:connect_signal("timeout", function () ret:scroll()  end)
    ret:auto(autoscroll or false)
    ret:expand(expanded or false)
    ret:set_width(width)

    if widget then
        ret:set_widget(widget)
    end

    return ret
end

function scroll.mt:__call(...)
    return new(...)
end

return setmetatable(scroll, scroll.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
