--this is a lua script for conky
require 'cairo'

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



    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
