local commands = {}

-- double check these
local left_motor = 2
local right_motor = 0
local STOP = 1510
local FORWARD = 1550 -- set this
local BACKWARD = 1460 -- set this
local TURN_TIMEOUT = 1000
local HOLD_MODE = 4
local GUIDED_MODE = 15

-- what happens if two set_output_pwm_chan_timeout() calls happen before the first timeout finishes?
-- set_heading is given a target heading and rotates the boat until it is reached 
function commands.set_heading(target_heading_min, target_heading_max)
    local current_heading = get_yaw()

    while target_heading_min > current_heading or target_heading_max < current_heading do
        if target_heading_min > current_heading then
            -- rotate clockwise
            print(format.string("turn clockwise, target_min %.3f, target_max %.3f, heading %.3f", target_heading_min, target_heading_max, current_heading))
            SRV_Channels:set_output_pwm_chan_timeout(left_motor, FORWARD, TURN_TIMEOUT)
        elseif target_heading_max < current_heading then
            -- rotate counterclockwise
            print(format.string("turn counterclockwise, target_min %.3f, target_max %.3f, heading %.3f", target_heading_min, target_heading_max, current_heading))
            SRV_Channels:set_output_pwm_chan_timeout(right_motor, FORWARD, TURN_TIMEOUT)
        end
        -- stop rotating and check again
    end
    print("Heading correct")
end


-- might need to correct drift?
-- start moves the boat forward
function commands.start(target_heading_min, target_heading_max)
    print("Start")
    vehicle:set_mode(GUIDED_MODE)
    SRV_Channels:set_output_pwm_chan(left_motor, FORWARD)
    SRV_Channels:set_output_pwm_chan(right_motor, FORWARD)
end


-- make it loiter?
-- stop stops the boat
function commands.stop()
    print("Stop")
    SRV_Channels:set_output_pwm_chan(left_motor, STOP)
    SRV_Channels:set_output_pwm_chan(right_motor, STOP)
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
