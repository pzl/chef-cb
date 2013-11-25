--this is a lua script for conky
require 'cairo'

start=1

function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)
    
    cairo_select_font_face(cr,"mono",CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr,14)
    cairo_set_source_rgba(cr,1,1,1,1)
    cairo_set_line_width(cr,1)
    cairo_set_line_cap(cr,CAIRO_LINE_CAP_BUTT)
    cairo_set_line_join(cr,CAIRO_LINE_JOIN_MITER)
    
    if start==1 then
        os.execute('xdotool search --name clicky behave %@ mouse-click getmouselocation > ~/.config/conky/output/clicker &')
        print('click handler registered')
        start=0
    end

    f = io.popen("head -1 ~/.config/conky/output/clicker","r")
    pos = f:read("*a")
    f:close()
    io.flush()
    x = tonumber(string.match(pos,"x:(%d*)"))

    if x ~= nil then
        cairo_move_to(cr,x,2)
        cairo_rectangle(cr,x,2,4,7)
        cairo_stroke(cr)
        print(x)
    end


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


