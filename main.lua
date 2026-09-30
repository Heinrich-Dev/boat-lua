local contour_module = require("contour")
local command_module = require("commands")
local plan_table = require("plan")

local acc = 0
local curr_contour = 1
local prev_distance = {}
local tolerance = .00001 -- in lat/long, how close bot needs to be to move to next contour

function start()
    local curr_location = get_location()
    prev_distance = contour_module.distance_from_contour(curr_location, plan_table[curr_contour])
    local heading_min = plan_table[curr_contour]["heading"]["heading_start"]
    local heading_max = plan_table[curr_contour]["heading"]["heading_end"]
    command_module.set_heading(heading_min, heading_max)
    command_module.start()
    return loop, 1000
end

function loop()
    local curr_yaw = get_yaw()
    local curr_location = get_location()
    local curr_distance = contour_module.distance_from_contour()

    if curr_distance <= tolerance then
        command_module.stop()
        local heading_min = plan_table[curr_contour]["heading"]["heading_start"]
        local heading_max = plan_table[curr_contour]["heading"]["heading_end"]
        command_module.set_heading(heading_min, heading_max)
        curr_contour = curr_contour + 1
        command_module.start()
    end

    if acc == 5 then
        counter_module.check_approach(prev_distance, curr_distance)
        acc = 0
    end

    acc = acc + 1

    return loop, 1000
end

function get_yaw()
    local yaw_radians = ahrs:get_yaw()
   
    if yaw_radians < 0.0 then
        yaw_radians = yaw_radians + (2 * 3.14159)
    end
    
    return yaw_radians
end

function get_location()
    local gps_instance = gps:primary_sensor()
    local location_ud = gps:location(gps_instance)
    
    return location_ud
end

return start()
