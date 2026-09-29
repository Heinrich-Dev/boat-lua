-- double check these
local left_motor = 2
local right_motor = 0
local STOP = 1510
local FORWARD = 1550 -- set this
local BACKWARD = 1460 -- set this
local TURN_TIMEOUT = 1000


-- what happens if two set_output_pwm_chan_timeout() calls happen before the first timeout finishes?
-- set_heading is given a target heading and rotates the boat until it is reached 
function set_heading(target_heading_min, target_heading_max)
    local current_heading = get_yaw()

    while target_heading_min > current_heading or target_heading_max < current_heading do
        if target_heading_min > current_heading then
            -- rotate clockwise
            SRV_Channels:set_output_pwm_chan_timeout(left_motor, FORWARD, TURN_TIMEOUT)
        else if target_heading_max < current_heading then
            -- rotate counterclockwise
            SRV_Channels:set_output_pwm_chan_timeout(right_motor, FORWARD, TURN_TIMEOUT)
        end
        -- stop rotating and check again
    end
end


-- might need to correct drift?
-- start moves the boat forward
function start(target_heading_min, target_heading_max)
    SRV_Channels:set_output_pwm_chan(left_motor, FORWARD)
    SRV_Channels:set_output_pwm_chan(right_motor, FORWARD)
end


-- make it loiter?
-- stop stops the boat
function stop()
    SRV_Channels:set_output_pwm_chan(left_motor, STOP)
    SRV_Channels:set_output_pwm_chan(right_motor, STOP)
    -- mavcmddosetmode
    vehicle:set_mode(4)
end

-- Returns yaw in radians
function get_yaw()
    local yaw = ahrs:get_yaw()
   
    if yaw < 0.0 then
        yaw = yaw + (2 * 3.14159)
    end

    return yaw
end