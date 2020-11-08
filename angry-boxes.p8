pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

objs = {}

num_boxes = 13
cars_picked_up = 0

function _init()
 for x = 1, num_boxes do
	 local box = make_box(6 + (x-1) * 9)
 	add(objs, box)
 end
 
 local robot = make_robot()
 add(objs, robot)
end

function _update()
 for obj in all(objs) do
  obj.update()
 end
end

function _draw()
 rectfill(0, 0, 128, 128, 2)
 
 for obj in all(objs) do
  obj.draw()
 end
 
 print (cars_picked_up, 5, 120, 12)
end
-->8

function make_box(x)
 local o = {}
 o.w = 8
 o.h = 8
 o.s = 1
 o.x = x
 o.y = 5
 o.t = "box"
 
 o.fire_timer = 0
 o.fire_timer_max = 120 + rnd(800)
 
 o.update = function()
  o.fire_timer += 1
  
  if (o.fire_timer > o.fire_timer_max) then
   local car = make_car(o.x, o.y)
   add(objs, car)
   o.fire_timer = 0
    o.fire_timer_max = 120 + rnd(800)
  end
 end
 
 o.draw = function()
  spr(o.s, o.x, o.y)
 end
 
 return o
end
-->8

function make_car(x, y)
 local o = {}
 o.w = 8
 o.h = 8
 o.s = 2
 o.x = x
 o.y = y
 o.t = "car"
 
 o.update = function()
  local speed = 0.25
  o.y += speed
  
  if (o.y > 128) then
   del(o, objs)
  end
 end
 
 o.draw = function()
  spr(o.s, o.x, o.y)
 end
 
 return o
end
-->8

function make_robot()
 local o = {}
 o.w = 8
 o.h = 8
 o.s = 3
 o.x = 60
 o.y = 115
 o.t = "robot"
 
 o.update = function()
  local speed = 2
 
  if (btn(0)) then
   o.x -= speed
  elseif (btn(1)) then
   o.x += speed
  end
  
  if (o.x < 0) then
   o.x = 0
  elseif (o.x > 120) then
   o.x =120
  end
  
  for obj in all(objs) do
   if (obj.t == "car") then
    if (collision(obj, o)) then
     del(objs, obj)
     sfx(0)
     cars_picked_up += 1
    end
   end
  end
  
 end
 
 o.draw = function()
  spr(o.s, o.x, o.y)
 end
 
 return o
end
-->8

function collision(ent1, ent2)
 if (ent1.x <= ent2.x + ent2.w and
       ent1.x + ent1.w >= ent2.x and
       ent1.y <= ent2.y + ent2.h and
       ent1.h + ent1.y >= ent2.y) then
  return true
 else
 	return false
 end
end

__gfx__
000000004b44444b0000000000646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044b444b40777770000444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700444b4b447ccccc7000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700044b444b47cccccc744444409000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000444444447c777c7744999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007004444bb440700070044444409000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044bb44bb0000000049999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444440000000090000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010600001055011550135501555017550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
