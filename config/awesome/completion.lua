local http = require("socket.http")
local table = table
local io = io
local os = os
local print = print

module("completion")

function tracker(command, cur_pos, ncomp)
   local wstart = 1
   local wend = 1
   local words = {}
   local cword_index = 0
   local cword_start = 0
   local cword_end = 0
   local i = 1

   if cur_pos ~= #command + 1 and command:sub(cur_pos, cur_pos) ~= " " then
      return command, cur_pos
   elseif #command == 0 then
      return command, cur_pos
   end
   while wend <= #command do
      wend = command:find(" ", wstart)
      if not wend then wend = #command + 1 end
      table.insert(words, command:sub(wstart, wend - 1))
      if cur_pos >= wstart and cur_pos <= wend + 1 then
		 cword_start = wstart
		 cword_end = wend
		 cword_index = i
      end
      wstart = wend + 1
      i = i + 1
   end
   local c, err = io.popen('tracker-search '..words[cword_index])

   local output = {}
   i = 0
   if c then
      while true do
		 local line = c:read("*line")
		 if not line then break end
		 table.insert(output, line)
      end

      c:close()
   else
      print(err)
   end

   if #output == 0 then
      return command, cur_pos
   end

   while ncomp > #output do
      ncomp = ncomp - #output
   end

   local str = command:sub(1, cword_start - 1) .. output[ncomp] .. command:sub(cword_end)
   cur_pos = cword_end + #output[ncomp] + 1

   return str, cur_pos
end

function ssh(command, cur_pos, ncomp)
   local hosts = {}
   local wstart = 1
   local wend = 1
   local words = {}
   local cword_index = 0
   local cword_start = 0
   local cword_end = 0
   local i = 1

   if cur_pos ~= #command + 1 and command:sub(cur_pos, cur_pos) ~= " " then
      return command, cur_pos
   elseif #command == 0 then
      return command, cur_pos
   end

   while wend <= #command do
      wend = command:find(" ", wstart)
      if not wend then wend = #command + 1 end
      table.insert(words, command:sub(wstart, wend - 1))
      if cur_pos >= wstart and cur_pos <= wend + 1 then
		 cword_start = wstart
		 cword_end = wend
		 cword_index = i
      end
      wstart = wend + 1
      i = i + 1
   end

   local c, err = io.popen('cut -d " " -f1 ' .. os.getenv("HOME") .. '/.ssh/known_hosts | cut -d, -f1')

   local output = {}
   i = 0
   if c then
      while true do
		 local line = c:read("*line")
		 if not line then break end
		 if line:find("^" .. command:sub(1,cur_pos)) then
			table.insert(output, line)
		 end
      end
      c:close()
   else
      print(err)
   end

   local fh = io.open(os.getenv("HOME") .. "/.ssh/config")
   if fh then
	  for line in fh:read("*all"):gmatch("Host ([%w%p]+)") do
		 if line:find("^" .. command:sub(1,cur_pos)) then
			table.insert(output, line)
		 end
      end
      fh:close()
   end

   if #output == 0 then
      return command, cur_pos
   end

   while ncomp > #output do
      ncomp = ncomp - #output
   end

   local str = command:sub(1, cword_start - 1) .. output[ncomp] .. command:sub(cword_end)
   cur_pos = cword_end + #output[ncomp] + 1

   return str, cur_pos
end

function zsh(command, cur_pos, ncomp)
   local wstart = 1
   local wend = 1
   local words = {}
   local cword_index = 0
   local cword_start = 0
   local cword_end = 0
   local i = 1
   local compfile = true

   -- do nothing if we are on a letter, i.e. not at len + 1 or on a space
   if cur_pos ~= #command + 1 and command:sub(cur_pos, cur_pos) ~= " " then
	  return command, cur_pos
   elseif #command == 0 then
	  return command, cur_pos
   end

   while wend <= #command do
	  wend = command:find(" ", wstart)
	  if not wend then wend = #command + 1 end
	  table.insert(words, command:sub(wstart, wend - 1))
	  if cur_pos >= wstart and cur_pos <= wend + 1 then
		 cword_start = wstart
		 cword_end = wend
		 cword_index = i
	  end
	  wstart = wend + 1
	  i = i + 1
   end

   if cword_index == 1 then
	  compfile = false
   end
   if compfile then
	  local zsh_cmd = "/usr/bin/env zsh -c 'local -a res; res=( ${IPREFIX}${PREFIX}*${SUFFIX}${ISUFFIX} ); print -l -- $(M)res[@]:#"..words[cword_index].."*}'"
   else
	  local zsh_cmd = "/usr/bin/env zsh -c 'local -a res; res=( \"${(k)commands[@]}\" \"${(k)aliases[@]}\" \"${(k)builtins[@]}\" \"${(k)functions[@]}\" \"${(k)reswords[@]}\" ); print -l -- ${(M)res[@]:#"..words[cword_index].."*}'"
   end
   local c, err = io.popen(zsh_cmd)
   local output = {}
   i = 0
   if c then
	  while true do
		 local line = c:read("*line")
		 if not line then break end
		 if os.execute("test -d " .. line) == 0 then
            line = line .. "/"
		 end
		 table.insert(output, line)
	  end

	  c:close()
   else
	  print(err)
   end

   -- no completion, return
   if #output == 0 then
	  return command, cur_pos
   end

   -- cycle
   while ncomp > #output do
	  ncomp = ncomp - #output
   end

   local str = command:sub(1, cword_start - 1) .. output[ncomp] .. command:sub(cword_end)
   cur_pos = cword_end + #output[ncomp] + 1

   return str, cur_pos
end

