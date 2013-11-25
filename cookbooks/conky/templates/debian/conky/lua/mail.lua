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

    conky_mail({x=14,y=0})
    conky_mail({x=40,y=0,color={0.8,0.2,0.3,1},new=4})
    
    --[[GPU
    local fan = io.popen("aticonfig --pplib-cmd 'get fanspeed 0' | head -3 | tail -1")
    fan = fan:read("*a")
    fan=string.match(fan,"(%d*)%%")
    conky_fan({x=70,y=0,bar=true,val=tonumber(fan)})
    fan = io.popen("aticonfig --pplib-cmd 'get temperature 0'")
    fan = fan:read("*a")
    fan=string.match(fan,"(%d*)%.")
    conky_temp({x=93,y=0,high=80,low=50,warn=65,val=tonumber(fan)})
]]
    --CPU
    local sens = io.popen("sensors")
    sens = sens:read("*a")
    local x=108
    for i=0,3 do
        conky_bar({x=x,y=0,val=tonumber(conky_parse("${cpu cpu"..(i+1).."}"))})
        conky_temp({x=(x+12),y=0,high=50,low=20,warn=34,val=tonumber(string.match(sens,"Core "..i..":%s*%+(%d*)%.%d"))})
        x=x+22
    end




    --case fans
    --conky_fan({x=200,y=0,high=700,low=300,val=tonumber(string.match(sens,"fan1:%s*(%d*)%sRPM"))})
    --conky_fan({x=219,y=0,high=1000,low=600,val=tonumber(string.match(sens,"fan2:%s*(%d*)%sRPM"))})
    --conky_fan({x=238,y=0,high=700,low=300,val=tonumber(string.match(sens,"fan4:%s*(%d*)%sRPM"))})


    --TIME/DATE
    conky_tinyclock({x=200,y=3})
    conky_tinycal({x=220,y=1})

    --MUSIC
    --conky_mocp({x=247,y=3})

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

function color(opts)
    return opts[1],opts[2],opts[3],opts[4]
end


--YAY EMAIL
function conky_mail(opts)
    if opts.color==nil then opts.color={0,1,0,1} end
    if opts.new==nil then opts.new=0 end



    local mail_width=18
    local mail_height=11
    local mail_color={0.85,0.22,0.22,1}
    local mail_y_pad=4

    --envelope
    cairo_set_source_rgba(cr,1,1,1,1)
    cairo_set_line_width(cr,0.5)
    cairo_rectangle(cr,opts.x,opts.y+mail_y_pad,mail_width,mail_height)
    cairo_fill_preserve(cr)
    cairo_set_source_rgba(cr,color(mail_color))
    cairo_stroke(cr)

    --thick red lines
    cairo_set_line_width(cr,2)
    cairo_set_line_cap(cr,CAIRO_LINE_CAP_BUTT)
    cairo_move_to(cr,opts.x,opts.y+mail_y_pad)
    cairo_rel_line_to(cr,0,mail_height)
    cairo_move_to(cr,opts.x+mail_width,opts.y+mail_y_pad)
    cairo_rel_line_to(cr,0,mail_height)
    cairo_stroke(cr)
    --flap
    cairo_move_to(cr,opts.x,opts.y+mail_y_pad)
    cairo_rel_line_to(cr,mail_width/2,3*mail_height/5)
    cairo_line_to(cr,opts.x+mail_width,opts.y+mail_y_pad)
    cairo_stroke(cr)
    --flap thin lines
    cairo_set_line_width(cr,0.5)
    cairo_move_to(cr,opts.x+0.5,opts.y+mail_y_pad+4*mail_height/5)
    cairo_rel_line_to(cr,mail_width/3,-1*mail_height/3)
    cairo_move_to(cr,opts.x+mail_width-0.5,opts.y+mail_y_pad+4*mail_height/5)
    cairo_rel_line_to(cr,-mail_width/3,-1*mail_height/3)
    cairo_stroke(cr)


    --account color
    cairo_set_line_width(cr,1.5)
    cairo_set_source_rgba(cr,color(opts.color))
    cairo_move_to(cr,opts.x,opts.y)
    cairo_rel_line_to(cr,mail_width,0)
    cairo_stroke(cr)


    if opts.new<1 then
        cairo_set_source_rgba(cr,0,0,0,0.65)
        cairo_rectangle(cr,opts.x-1,opts.y+mail_y_pad-0.5,mail_width+2,mail_height+1)
        cairo_fill(cr)
    else
        cairo_select_font_face(cr,"terminus",CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
        cairo_set_font_size(cr,3)
        cairo_set_source_rgba(cr,0,0,0,1)
        cairo_move_to(cr,opts.x+mail_width-6,opts.y+mail_y_pad+mail_height)
        cairo_show_text(cr,opts.new)
    end

    cairo_close_path(cr)
    
end

--YAY FAN SPEED
function conky_fan(opts)
    if opts.color==nil then opts.color={1,1,1,1} end
    if opts.low==nil then opts.low=0 end
    if opts.high==nil then opts.high=100 end
    if opts.val==nil then opts.val=0 end
   
    local my_bg = {0.18,0.2,0.21,1}

    local fan_radius=8
    local fan_blades=3
    local fan_rotation_speed=(opts.val-opts.low)/(opts.high-opts.low)*50
    local fan_angle=360/fan_blades

    if fan_position==nil then
        fan_position=fan_rotation_speed
    else
        fan_position=fan_position+fan_rotation_speed
    end

    cairo_set_source_rgba(cr,color(opts.color))
    --blades
    for i=1,fan_blades do
        blade({x=opts.x+fan_radius,
               y=opts.y+fan_radius,
               r=fan_radius,a=i*fan_angle-fan_position,
               sweep=fan_angle})
    end

    --pin
    cairo_set_source_rgba(cr,color(my_bg)) 
    cairo_arc(cr,opts.x+fan_radius,opts.y+fan_radius,3.0,0,2*math.pi)
    cairo_fill(cr)
    cairo_set_source_rgba(cr,color(opts.color))
    cairo_arc(cr,opts.x+fan_radius,opts.y+fan_radius,2,0,2*math.pi)
    cairo_fill(cr)

    if opts.bar then
        local bar_height = (opts.val-opts.low)/(opts.high-opts.low)*fan_radius*2
        cairo_set_line_width(cr,1)
        cairo_set_line_cap(cr,CAIRO_LINE_CAP_BUTT)
        cairo_move_to(cr,opts.x+fan_radius*2+2.5,opts.y+fan_radius*2)
        cairo_rel_line_to(cr,0,-bar_height)
        cairo_stroke(cr)
    end


end
function blade(opts)
    local crv_s=27 --curvature strength

    local half_pt={x=opts.r*math.cos(math.rad(opts.sweep/2+opts.a)),
             y=opts.r*math.sin(math.rad(opts.sweep/2+opts.a))}
    local curve_pt={x=opts.r/2*math.cos(math.rad(opts.a+opts.sweep/2-crv_s)),
              y=opts.r/2*math.sin(math.rad(opts.a+opts.sweep/2-crv_s))}
    local curve_in={x=opts.r/2*math.cos(math.rad(opts.a+opts.sweep-crv_s)),
              y=opts.r/2*math.sin(math.rad(opts.a+opts.sweep-crv_s))}

    cairo_set_line_width(cr,0.5)
    cairo_move_to(cr,opts.x,opts.y)
    cairo_curve_to(cr,
        opts.x+curve_pt.x,opts.y+curve_pt.y,
        opts.x+curve_pt.x,opts.y+curve_pt.y,
        opts.x+half_pt.x,opts.y+half_pt.y)
    cairo_arc(cr,opts.x,opts.y,opts.r,math.rad(opts.a+opts.sweep/2),math.rad(opts.a+opts.sweep))
    cairo_curve_to(cr,
        opts.x+curve_in.x,opts.y+curve_in.y,
        opts.x+curve_in.x,opts.y+curve_in.y,
        opts.x,opts.y)
    cairo_fill(cr)
end


--YAY THERMOMETER
function conky_temp(opts)
    if opts.cold==nil then opts.cold={0,.5,1,1} end
    if opts.hot==nil then opts.hot={1,0,0,1} end
    if opts.burn==nil then opts.burn={1,0,0,1} end
    if opts.burn_border==nil then opts.burn_border={.4,0,0,1} end
    if opts.high==nil then opts.high=70 end
    if opts.low==nil then opts.low=22 end
    if opts.warn==nil then opts.warn=60 end
    if opts.border==nil then opts.border={1,1,1,.6} end
    if opts.val==nil then opts.val=20 end --honestly, whatever here


    local therm_h=17
    local therm_w=6.2

    local bulb={x=opts.x+therm_w/2+.5,y=opts.y+therm_h-therm_w/2+.5}
    local stalk={dx=therm_w/2*math.cos(math.rad(60)),
                dy=therm_w/2*math.sin(math.rad(60))}
    stalk.h=therm_h-therm_w/2-stalk.dx-4

    local grad = cairo_pattern_create_linear(0,0,0,therm_h)
    cairo_pattern_add_color_stop_rgba(grad,0,color(opts.hot))
    cairo_pattern_add_color_stop_rgba(grad,1,color(opts.cold))
    local value = (opts.val-opts.low)/(opts.high-opts.low)*(stalk.h+stalk.dx)

    --bulb fill
    if opts.val < opts.warn then
        cairo_set_source(cr,grad)
    else
        cairo_set_source_rgba(cr,color(opts.burn))
    end
    cairo_arc(cr,bulb.x,bulb.y,therm_w/2,0,2*math.pi)
    cairo_fill(cr)

    --stalk fill
    cairo_rectangle(cr,bulb.x-stalk.dx,bulb.y-therm_w/2,2*stalk.dx,-value)
    cairo_fill(cr)


    --outline
    --bulb
    if opts.val < opts.warn then
        cairo_set_source_rgba(cr,color(opts.border))
    else
        cairo_set_source_rgba(cr,color(opts.burn_border))
    end
    cairo_set_line_width(cr,1)
    cairo_arc(cr,bulb.x,bulb.y,therm_w/2,math.rad(30-90),math.rad(330-90))
    --stalk
    cairo_move_to(cr,bulb.x-stalk.dx,bulb.y-stalk.dy)
    cairo_rel_line_to(cr,0,-1*stalk.h)
    cairo_arc(cr,bulb.x,opts.y+stalk.dx+.5,stalk.dx,math.rad(270-90),0)
    cairo_line_to(cr,bulb.x+stalk.dx,bulb.y-stalk.dy)
    cairo_stroke(cr)

end

function conky_tinyclock(opts)
    if opts.color==nil then opts.color={1,1,1,1} end

    local r=6
    local d=os.date("*t")
    local s=tonumber(d.sec)
    local m=tonumber(d.min)*60+s
    local h=tonumber(d.hour)*60*60+m
    opts.x=opts.x+.5
    opts.y=opts.y+.5

    --border
    cairo_set_source_rgba(cr,color(opts.color))
    cairo_set_line_width(cr,1.2)
    cairo_move_to(cr,opts.x+2*r,opts.y+r)
    cairo_arc(cr,opts.x+r,opts.y+r,r,0,2*math.pi)
    cairo_stroke(cr)

    cairo_set_line_width(cr,1)
    --hours
    cairo_move_to(cr,opts.x+r,opts.y+r)
    cairo_rel_line_to(cr,3*math.cos(math.rad(h*(360/(60*60*12))-90)),3*math.sin(math.rad(h*(360/(60*60*12))-90)))
    cairo_stroke(cr)
    --minutes
    cairo_move_to(cr,opts.x+r,opts.y+r)
    cairo_rel_line_to(cr,4*math.cos(math.rad(m*(360/(60*60))-90)),4*math.sin(math.rad(m*(360/(60*60))-90)))
    cairo_stroke(cr)
    --seconds
    cairo_set_source_rgba(cr,1,0,0,1)
    cairo_move_to(cr,opts.x+r,opts.y+r)
    cairo_rel_line_to(cr,5*math.cos(math.rad(s*360/60-90)),5*math.sin(math.rad(s*360/60-90)))
    cairo_stroke(cr)
end


function conky_tinycal(opts)
    if opts.color==nil then opts.color={1,1,1,1} end
    if opts.today_color==nil then opts.today_color={1,0,0,1} end
    if opts.important_color==nil then opts.important_color={0,1,0,1} end
    if opts.wknd==nil then opts.wknd={0.5,0.7,1,0.8} end

    opts.y=opts.y+.5

    local day_w=1
    local day_h=0
    local pad_x=2
    local pad_y=3

    local d=os.date("*t")
    local dow=tonumber(os.date("%w",os.time({month=d.month,year=d.year,day=1})))
    local daysinmonth=tonumber(dim(d.month,d.year))

    cairo_set_line_width(cr,1)

    local n=1
    local function printdate(i,j)
        cairo_set_source_rgba(cr,color(opts.color))
        if j==0 or j==6 then
            cairo_set_source_rgba(cr,color(opts.wknd))
        end
        if n==d.day then
            cairo_set_source_rgba(cr,color(opts.today_color))
        end
        cairo_move_to(cr,opts.x+j*(pad_x+day_w),opts.y+i*(pad_y+day_h))
        cairo_rel_line_to(cr,day_w,day_h)
        cairo_stroke(cr)
        n=n+1
    end
    for i=0,4 do
        for j=0,6 do
            if i==0 then
                if j>=dow then
                    printdate(i,j)
                end
            elseif n<=daysinmonth then
                printdate(i,j)
            end
        end
    end

end


do
    local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    local function is_leap_year(year)
        return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
    end
    function dim(month, year)
        if month == 2 and is_leap_year(year) then
            return 29
        else
            return days_in_month[month]
        end
    end
end


function conky_mocp(opts)
    --detect if server is running first
    local running = tonumber(os.execute("mocp -i"))
    if 0~=running then return end

    local r = 5
    local trileg=4.5
    local state="OFF"
    local track=""
    local time=0
    local f=""

    f = io.popen("mocp -Q %state")
    state = string.gsub(f:read("*a"),"\n","")
    if state ~= "STOP" then
        f = io.popen("mocp -Q %song")
        track = string.gsub(f:read("*a"),"\n","")
        f = io.popen("mocp -Q %cs'/'%ts")
        time = loadstring("return "..string.gsub(f:read("*a"),"\n",""))()
    end

    --circle bg
    cairo_set_line_width(cr,2)
    cairo_set_source_rgba(cr,1,1,1,0.2)
    cairo_arc(cr,opts.x+r,opts.y+r,r,0,2*math.pi)
    cairo_stroke(cr)
    --circle active progress
    local grad = cairo_pattern_create_radial(opts.x+r,opts.y+r,0,opts.x+r,opts.y+r,r+3.3)
    cairo_pattern_add_color_stop_rgba(grad,0.2,0,1,1,1)
    cairo_pattern_add_color_stop_rgba(grad,1,1,0,1,1)
    cairo_set_source(cr,grad)
    cairo_arc(cr,opts.x+r,opts.y+r,r,math.rad(-90),math.rad((360*time-90)))
    cairo_stroke(cr)
    
    --playpause
    cairo_set_source_rgba(cr,0.4,.7,1,1)
    cairo_set_line_width(cr,1)
    if state=="PLAY" then
        cairo_move_to(cr,opts.x+r+trileg/2,opts.y+r-.5)
        cairo_rel_line_to(cr,-1*trileg,trileg*math.tan(math.rad(30)))
        cairo_rel_line_to(cr,0,-1*trileg)
        cairo_close_path(cr)
        cairo_fill(cr)
    elseif state=="PAUSE" then
        cairo_move_to(cr,opts.x+r-1.5,opts.y+r-2)
        cairo_rel_line_to(cr,0,4)
        cairo_rel_move_to(cr,3,0)
        cairo_rel_line_to(cr,0,-4)
        cairo_stroke(cr)
    else --stopped?
        cairo_rectangle(cr,opts.x+r-2,opts.y+r-2,4,4)
        cairo_fill(cr)
    end

    --track title
    cairo_select_font_face(cr,"terminus",CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_source_rgba(cr,color({1,1,1,1}))
    cairo_move_to(cr,opts.x+2*r+4,opts.y+9)
    cairo_show_text(cr,track)

end


function conky_bar(opts)
    if opts.color==nil then opts.color={1,1,1,1} end

    cairo_set_source_rgba(cr,color(opts.color))
    cairo_move_to(cr,opts.x,opts.y+12)
    cairo_show_text(cr,opts.val.."%")
    cairo_close_path(cr)
end
