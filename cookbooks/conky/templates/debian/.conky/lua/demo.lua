--this is a lua script for conky
require 'cairo'

function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)
    
    cairo_select_font_face(cr,"mono",CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr,14)
    cairo_set_source_rgba(cr,1,1,1,1)
    cairo_move_to(cr,13,13)
    cairo_show_text(cr,conky_parse("${fs_used /}"))
    cairo_stroke(cr)
    
    cairo_set_line_width(cr,1)
    cairo_set_line_cap(cr,CAIRO_LINE_CAP_BUTT)
    cairo_set_source_rgba(cr,1,1,1,1)
    cairo_move_to(cr,13,16.5)
    --cairo_line_to(cr,19,130)
    cairo_rel_line_to(cr,1440,0)
    cairo_stroke(cr)

    cairo_move_to(cr,75.5,14)
    cairo_rel_line_to(cr,0,-1*tonumber(conky_parse("${cpu cpu0}")))
    cairo_stroke(cr)

    cairo_set_line_join(cr,CAIRO_LINE_JOIN_MITER)
    cairo_move_to(cr,80,14)
    cairo_rel_line_to(cr,10,0)
    cairo_rel_line_to(cr,0,-10)
    cairo_close_path(cr)
    --cairo_stroke(cr)
    cairo_fill(cr)

    cairo_rectangle(cr,120.5,4.5,40,10)
    cairo_stroke(cr)


    cairo_move_to(cr,200.5,9.5)
    cairo_arc(cr,200.5,9.5,4.5,3/2*math.pi,2*math.pi)
    cairo_close_path(cr)
    cairo_fill(cr)

    cairo_arc(cr,200.5,9.5,4.5,0,2*math.pi)
    cairo_stroke(cr)



    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
