#!/usr/bin/lua
--[[

* Monte-Carlo simulation to calculate pi

(See Wikipedia: https://.en.wikipedia.org/wiki/Monte_Carlo_method)
  
* Method
- Construct square of unit sidelength
- Position $N particles randomly
- Form probability distribution of (is r(p) <= 1?)
- P(r <= 1) / N = \pi/4

* General method
We're looking to reconstrct an unknown /pdf/, in the above case the 
probability a randomly place particle is within the quadrant of a circle. This
is used to gain information about the ratio of areas, and thus used to obtain a
value for pi. 

To gain information about a system, create an /ensemble/ of state 
configurations to gain statistics, forming the desired /pdf/.

--]]

local math,table,ipairs = math,table,ipairs

-- simple pythagoras' theorem to get length of long side of triangle
function get_distance(p)
  local h = math.pow(math.pow(p.x, 2) + math.pow(p.y, 2), 0.5)
  return h
end

-- returns a random 2D position in the range (0,0) to (1,1)
function random_position()
	local xpos, ypos = math.random(), math.random()
  local position = {x=xpos, y=ypos}
	return position 
end


-- modulus :(
function mod(a,b)
  return a - math.ceil(a/b)*b
end

-- displays progress in the form of a percentage
function progress(n, N)
  local percentage = 100 * n / N
  if mod(percentage, 10) == 0 then io.write("\r"..percentage.."%") io.flush() end
end


-- fills a square with N particles with uniform random position
function init (N)
  local system = {}
	
  for n=1,N do
    system[n] = {}
		system[n].x = math.random()
    system[n].y = math.random()
    progress(n,N)
	end

	return system
end

-- Main program loop
function main (arg)

  local N, R, tot = arg[1] or 1000, arg[2] or 10, 0

  if tonumber(N) >= 10000000 then 
    io.write("Too large of a system! Please restrict N to under 1E7.\n")
    --io.flush()
    return
  end

  for r=1,R do
    local pi, pin = 0, 0
    system = init(N)
    for i,position in ipairs(system) do
      if get_distance(position) <= 1 then pin = pin + 1 end
    end

    pi = 4 * pin / N
    io.write("\rPi: "..pi.."\n")
    tot = tot + pi
  end
  local av = tot/R
  local err = av - math.pi
  io.write(R.." runs, with average "..av.." (err="..err..")\n")
end

main(arg)
