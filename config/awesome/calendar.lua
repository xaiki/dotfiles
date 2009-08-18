
local io = io
local os = os
local math = math
local string = string
local print = print

module("calendar")
local diaryfile
local alarmfile

function initialize(settings)
   diaryfile = settings.diary
   alarmfile = settings.alarm
end

function time()
   local time
   time = os.date("%H:%M")
   return time
end

function date()
   local date
   date = os.date("%a, %d %B %Y")
   return date
end

function diary()
   local fh
   local diary
   local output = ""
   fh = io.open(diaryfile)
   if fh ~= nil then
      diary = fh:read("*a")
	  local datespec = os.date("%d %b")
	  local dayname = os.date("%A")
	  local r
	  for line in diary:gmatch("[^\r\n]+") do
		 if line:match("^"..datespec) then 
			output = output..line.."\n"
			r = true
		 elseif line:match("^"..dayname) then
			output = output..line.."\n"
			r = true
		 elseif line:match("^[ -]") and r then
			output = output..line.."\n"
		 else
			r = false
		 end
	  end

      fh:close()
   end
   return output
end

function to_string()
   local datespec = os.date("*t")
   datespec = datespec.year * 12 + datespec.month - 1
   datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
   local cal, err =  io.popen("cal -m " .. datespec)
   if cal then
	  cal = string.gsub(cal:read("*all"), "^%s*(.-)%s*$", "%1")
	  return cal
   else
	  print(err)
	  return err
   end
end


