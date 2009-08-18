----------------------------------------------------------------------------
-- @author Christian Kuka &lt;ckuka@madkooky.de&gt;
-- @copyright 2008 Christian Kuka
----------------------------------------------------------------------------


local http = require("socket.http")
local print = print
local math = math
local string = string
local tonumber = tonumber
local sin = math.sin
local cos = math.cos
local asin = math.asin
local sqrt = math.sqrt
local min = math.min
local abs = math.abs
local pi = math.pi

module("geo")
local googleKey

--- Calculate the distance (in meter) between two locations
-- @param from Location with latitude and longitude
-- @param to Location with latitude and longitude
-- @return Distance between this locations
function distance(from, to)
   local distance = 0
   local radius = 6367000
   local radian = pi / 180
   local deltaLatitude = sin(radian * (from.latitude - to.latitude) /2)
   local deltaLongitude = sin(radian * (from.longitude - to.longitude) / 2)

   local circleDistance = 2 * asin(min(1, sqrt(deltaLatitude * deltaLatitude + cos(radian * from.latitude) * cos(radian * to.latitude) * deltaLongitude * deltaLongitude)))
   distance = abs(radius * circleDistance)
   return distance
end

--- Uses google to find out the coordinates of an address
-- @param address String containing street and city
-- @return A point containing latitude, longitude and accuracy 
function point(address)
   local point = {}
   point.accuracy = 0
   point.latitude = 0.0
   point.longitude = 0.0
   address = string.gsub(address, "([^A-Za-z0-9_])", function(c)
														return string.format("%%%02x", string.byte(c))
													 end)
   local request = "http://maps.google.com/maps/geo?output=csv&q="..address.."&key="
   if googleKey then
	  request = request..googleKey
   end

   local c, err, h = http.request(request)
   if c then
	  err, point.accuracy, point.latitude, point.longitude = c:match("(.*),(.*),(.*),(.*)")
   end
   
   point.accuracy = tonumber(point.accuracy)
   point.latitude = tonumber(point.latitude)
   point.longitude = tonumber(point.longitude)


   return point
end




