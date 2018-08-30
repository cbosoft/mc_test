local math = math

function p(system)

   local p = 0
   
   for _,v in ipairs(system) do
      p = p + math.sin(v)
   end
   
   return p
end

function permutate(system)
   for i,v in ipairs(system) do
      system[i] = system[i] + 1000*(1 - 2 * math.random())
   end
   return system
end

function energy(system)
   local tot = 0
   for _,v in ipairs(system) do
      tot = tot + v
   end
   return tot
end

function step(system, list)
   local new_system = permutate(system)

   local p_new_system = p(new_system)
   local p_old_system = p(system)
   local p_ratio = p_new_system / p_old_system

   if p_ratio > 1 or math.random() < p_ratio then
      table.insert(list, energy(system))
   end

   return new_system, list
end

local system = {}
local list = {}

for i=1,10 do
   system[i] = math.random()
end

for t=0,100000000 do
   system, list = step(system, list)
end

for _,v in ipairs(list) do
   print(v)
end
   
