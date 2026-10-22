local commands = {}

local HOLD_MODE = 4
local GUIDED_MODE = 15

-- set_heading is given a target heading and rotates the boat until it is reached 
function commands.set_heading(target_heading_min, target_heading_max)
    if vehicle:get_mode() == HOLD_MODE then
        vehicle:set_mode(GUIDED_MODE)
    end

    local target_heading = target_heading_min + (target_heading_max - target_heading_min)
    local heading_error_threshold = (target_heading_max - target_heading_min) / 2
    local current_heading = get_yaw()
    local heading_error
    
    local p = 0.2

    if current_heading - target_heading > math.pi then
        -- If the error is greater than pi, turn clockwise instead
        heading_error = ((2 * math.pi) - current_heading + target_heading)
    else
        -- Otherwise, turn counter clockwise
        heading_error = (current_heading - target_heading) * -1
    end

    if math.abs(heading_error) <= heading_error_threshold then
        print("Target heading reached...")
        return
    else
        local heading_correction = heading_error / math.pi
        print(string.format("Heading correction: %.2f", heading_correction))
        vehicle:set_steering_and_throttle(p * heading_correction, 0)
        return function() commands.set_heading(target_heading_min, target_heading_max) end, 1000
    end
end

-- start moves the boat forward
function commands.start(target_heading_min, target_heading_max)
    if vehicle:get_mode() == HOLD_MODE then
        vehicle:set_mode(GUIDED_MODE)
    end

    local target_heading = target_heading_min + (target_heading_max - target_heading_min)
    local heading_error_threshold = (target_heading_max - target_heading_min) / 2
    local current_heading = get_yaw()
    local heading_error
    
    local p = 0.2

    if current_heading - target_heading > math.pi then
        -- If the error is greater than pi, turn clockwise instead
        heading_error = ((2 * math.pi) - current_heading + target_heading)
    else
        -- Otherwise, turn counter clockwise
        heading_error = (current_heading - target_heading) * -1
    end

    local heading_correction = heading_error / math.pi
    vehicle:set_steering_and_throttle(p * heading_correction, 0.4)
end


-- make it loiter?
-- stop stops the boat
function commands.stop()
    vehicle:set_steering_and_throttle(0, 0)
    vehicle:set_mode(HOLD_MODE)
end

-- Returns yaw in radians
function get_yaw()
    local yaw = ahrs:get_yaw()
   
    if yaw < 0.0 then
        yaw = yaw + (2 * 3.14159)
    end

    return yaw
end

return commands

