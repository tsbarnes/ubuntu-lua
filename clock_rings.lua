--[[
Clock Rings

This script draws percentage meters as rings, and also draws clock hands if you want! It is fully customisable; all options are described in the script. This script is based off a combination of my clock.lua script and my rings.lua script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
lua_load ~/scripts/clock_rings.lua
lua_draw_hook_pre clock_rings

Changelog:
+ v1.0 -- Original release (30.09.2009)
v1.1p -- Jpope edit londonali1010 (05.10.2009)
v2011mint -- reEdit despot77 (18.02.2011)
* v2015ubuntu -- Edit by T. Scott Barnes (17.03.2015)
]]

settings = {
  rings = {
    {
      -- Edit this table to customise your rings.
      -- You can create more rings simply by adding more elements to settings.
      -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
      name = 'time',
      -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
      arg = '%I.%M',
      -- "max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
      max = 12,
      -- "bg_color" is the color of the base ring.
      bg_color = 0xffffff,
      -- "bg_alpha" is the alpha value of the base ring.
      bg_alpha = 0.1,
      -- "fg_color" is the color of the indicator part of the ring.
      fg_color = 0xFF6600,
      -- "fg_alpha" is the alpha value of the indicator part of the ring.
      fg_alpha = 0.2,
      -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
      x = 100, y = 150,
      -- "radius" is the radius of the ring.
      radius = 50,
      -- "thickness" is the thickness of the ring, centred around the radius.
      thickness = 5,
      -- "start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
      start_angle = 0,
      -- "end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger than start_angle.
      end_angle = 360
    },
    {
      name = 'time',
      arg = '%M.%S',
      max = 60,
      bg_color = 0xffffff,
      bg_alpha = 0.1,
      fg_color = 0xff6600,
      fg_alpha = 0.4,
      x = 100, y = 150,
      radius = 56,
      thickness = 5,
      start_angle = 0,
      end_angle = 360
    },
    {
      name = 'time',
      arg = '%S',
      max = 60,
      bg_color = 0xffffff,
      bg_alpha = 0.1,
      fg_color = 0xff6600,
      fg_alpha = 0.6,
      x = 100, y = 150,
      radius = 62,
      thickness = 5,
      start_angle = 0,
      end_angle = 360
    },
    {
      name = 'time',
      arg = '%d',
      max = 31,
      bg_color = 0xffffff,
      bg_alpha = 0.1,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 100, y = 150,
      radius = 70,
      thickness = 5,
      start_angle = -90,
      end_angle = 90
    },
    {
      name = 'time',
      arg = '%m',
      max = 12,
      bg_color = 0xffffff,
      bg_alpha = 0.1,
      fg_color = 0xff6600,
      fg_alpha = 1,
      x = 100, y = 150,
      radius = 76,
      thickness = 5,
      start_angle = -90,
      end_angle = 90
    },
    {
      name = 'cpu',
      arg = 'cpu0',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 50, y = 300,
      radius = 25,
      thickness = 5,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'memperc',
      arg = '',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 75, y = 350,
      radius = 25,
      thickness = 5,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'swapperc',
      arg = '',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 100, y = 400,
      radius = 25,
      thickness = 5,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'fs_used_perc',
      arg = '/',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 125, y = 450,
      radius = 25,
      thickness = 5,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'downspeedf',
      arg = 'eth0',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0x339900,
      fg_alpha = 0.8,
      x = 150, y = 500,
      radius = 25,
      thickness = 4,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'upspeedf',
      arg = 'eth0',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 150, y = 500,
      radius = 20,
      thickness = 4,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'downspeedf',
      arg = 'wlan0',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0x339900,
      fg_alpha = 0.8,
      x = 175, y = 550,
      radius = 25,
      thickness = 4,
      start_angle = -90,
      end_angle = 180
    },
    {
      name = 'upspeedf',
      arg = 'wlan0',
      max = 100,
      bg_color = 0xffffff,
      bg_alpha = 0.2,
      fg_color = 0xff6600,
      fg_alpha = 0.8,
      x = 175, y = 550,
      radius = 20,
      thickness = 4,
      start_angle = -90,
      end_angle = 180
    },
  },
  -- Use these settings to define the origin and extent of your clock.
  -- "clock_x" and "clock_y" are the coordinates of the center of the clock, in pixels, from the top left of the Conky window.

  clock_radius = 65,
  clock_x = 100,
  clock_y = 150,
  show_seconds = true,

  logo_filename = os.getenv("HOME") .. "/.config/conky/ubuntu-lua/new-ubuntu-logo.png",
  logo_x = 65,
  logo_y = 140,
}

require 'cairo'

function rgb_to_r_g_b(color, alpha)
  return ((color / 0x10000) % 0x100) / 255., ((color / 0x100) % 0x100) / 255., (color % 0x100) / 255., alpha
end

function draw_ring(cairo, value, ring)
  local x = ring['x']
  local y = ring['y']
  local radius = ring['radius']
  local thickness = ring['thickness']
  local start_angle = ring['start_angle']
  local end_angle = ring['end_angle']
  local bg_color = ring['bg_color']
  local bg_alpha = ring['bg_alpha']
  local fg_color = ring['fg_color']
  local fg_alpha = ring['fg_alpha']

  local angle_0 = start_angle * (2 * math.pi / 360) - math.pi / 2
  local angle_f = end_angle * (2 * math.pi / 360) - math.pi / 2
  local value_arc = value * (angle_f - angle_0)

  -- Draw background ring

  cairo_arc(cairo, x, y, radius, angle_0, angle_f)
  cairo_set_source_rgba(cairo, rgb_to_r_g_b(bg_color, bg_alpha))
  cairo_set_line_width(cairo, thickness)
  cairo_stroke(cairo)

  -- Draw indicator ring

  cairo_arc(cairo, x, y, radius, angle_0, angle_0 + value_arc)
  cairo_set_source_rgba(cairo, rgb_to_r_g_b(fg_color, fg_alpha))
  cairo_stroke(cairo)
end

function draw_logo(cairo, filename, x, y)
  local image = cairo_image_surface_create_from_png(filename)
  if image == nil then return end

  cairo_set_source_surface(cairo, image, x, y)
  cairo_paint(cairo)
  cairo_surface_destroy(image)
end

function draw_clock_hands(cairo, x, y, show_seconds)
  local seconds = os.date("%S")
  local minutes = os.date("%M")
  local hours = os.date("%I")

  local seconds_arc = (2 * math.pi / 60) * seconds
  local minutes_arc = (2 * math.pi / 60) * minutes + seconds_arc / 60
  local hours_arc = (2 * math.pi / 12) * hours + minutes_arc / 12

  -- Draw hour hand

  local hours_x = x + 0.7 * clock_radius * math.sin(hours_arc)
  local hours_y = y - 0.7 * clock_radius * math.cos(hours_arc)
  cairo_move_to(cairo, x, y)
  cairo_line_to(cairo, hours_x, hours_y)

  cairo_set_line_cap(cairo, CAIRO_LINE_CAP_ROUND)
  cairo_set_line_width(cairo, 5)
  cairo_set_source_rgba(cairo, 1.0, 1.0, 1.0, 1.0)
  cairo_stroke(cairo)

  -- Draw minute hand

  local minutes_x = x + clock_radius * math.sin(minutes_arc)
  local minutes_y = y - clock_radius * math.cos(minutes_arc)
  cairo_move_to(cairo, x, y)
  cairo_line_to(cairo, minutes_x, minutes_y)

  cairo_set_line_width(cairo, 3)
  cairo_stroke(cairo)

  -- Draw seconds hand

  if show_seconds then
    local seconds_x = x + clock_radius * math.sin(seconds_arc)
    local seconds_y = y - clock_radius * math.cos(seconds_arc)
    cairo_move_to(cairo, x, y)
    cairo_line_to(cairo, seconds_x, seconds_y)

    cairo_set_line_width(cairo, 1)
    cairo_stroke(cairo)
  end
end

function conky_clock_rings()
  local function setup_rings(cairo, ring)
    local value = tonumber(conky_parse(string.format('${%s %s}', ring['name'], ring['arg'])))
    local percent = value / ring['max']

    draw_ring(cairo, percent, ring)
  end

  -- Check that Conky has been running for at least 5s

  if conky_window == nil then
    return
  end
  local surface = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
  local cairo = cairo_create(surface)

  draw_logo(cairo, settings.logo_filename, settings.logo_x, settings.logo_y)

  local updates = tonumber(conky_parse('${updates}'))
  if updates > 5 then
    for i in pairs(settings.rings) do
      setup_rings(cairo, settings.rings[i])
    end
  end

  draw_clock_hands(cairo, settings.clock_x, settings.clock_y, settings.show_seconds)
end
