local math,table,ipairs,io = math,table,ipairs,io
--[[
   
   Monte-Carlo simulation of a box of N particles with sidelength L.

   Metropolis-Hastings algorithm used to find the probability that a 
   particle occupies a small section of the sim-box.
]]


function arradd(a1, a2, l)
   res = {}
   for d=1,3 do
      table.insert(res, a1[d]+a2[d])
   end
   for d=1,3 do
      if res[d] > l then
	 res[d] = res[d] - l
      elseif res[d] < 0 then
	 res[d] = res[d] + l
      end
   end
   return res
end      


function get_distance(dr)
   local d2 = 0
   for d=1,3 do
      d2 = d2 + dr[d]*dr[d]
   end

   local d = math.pow(d2, 0.5)
   return d
end


function lennard_jones(ri, rj)
   local dr = {}
   for d=1,3 do
      dr[d] = rj[d] - ri[d]
   end

   local r = get_distance(dr)
   local rinv = 1/r
   local U = math.pow(rinv, 12) - 2*math.pow(rinv, 6)
   return U
end


function yukawa(ri, rj)
   local dr = {}
   for d=1,3 do
      dr[d] = rj[d] - ri[d]
   end

   local r = get_distance(dr)
   local rinv = 1/r
   local U = rinv*math.exp(rinv)
   return U
end


local potential = yukawa


function energy(system)
   local tot = 0

   for i,ri in ipairs(system.positions) do
      for j,rj in ipairs(system.positions) do
	 if j >= i then break end
	 tot = tot + potential(ri, rj)
      end
   end

   return tot/system.N
end


function randarr(dim,scale)
   arr = {}

   for d=1,dim do
      table.insert(arr, scale*math.random())
   end
   
   return arr
end


function init(arg)
   if arg.d then
      if arg.L then
	 arg.N = math.pow(arg.L, 3)*arg.d
      elseif arg.N then
	 arg.L = math.pow(arg.N/arg.d,1/3)
      end
   end
   
   local system = {N=arg.N, L=arg.L, d=arg.D, positions={}}
   for n=1,system.N do
      table.insert(system.positions, randarr(3, system.L))
   end
   return system
end


function permutate(system)
   for i,position in ipairs(system.positions) do
      system.positions[i] = arradd(position, randarr(3,system.L*(1-2*math.random())), system.L)
   end
   return system
end

function probability(system)
   local nin, nout = 0, 0

   for i,pos in ipairs(system) do
      if (pos[1] < 0.1*system.L and pos[2] < 0.1*system.L and pos[3] < 0.1*system.L) then
	 nin = nin + 1
      else
	 nout = nout + 1
      end
   end

   return nin / system.N
end


-- Initialise
local system = init{N=10,L=1}


-- Main loop
local T = 100000
io.stderr:write("0%")
for t=1,T do
   local p = t*100/T
   if p % 10 == 0 then
      io.stderr:write("\r"..p.."%")
   end

   local new_system = permutate(system)
   local new_energy = energy(new_system)
   
   local p_new_system = probability(new_system) --math.exp(-new_energy)
   local p_old_system = probability(system) --math.exp(-energy(system))
   local p_ratio = p_new_system / p_old_system
   
   if ((p_ratio >= 1) or (math.random() <= p_ratio)) then
      print( new_energy )
      --print(system.positions[1][1])
   end
end
io.stderr:write("\ndone\n")
