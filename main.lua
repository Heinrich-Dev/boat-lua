-- Converts yaw from rads to degs, gets lat and lng and tries to print them all
function send_initial_istate()
    get_yaw()
    get_location()
    return send_initial_istate, 1000
end

-- Prints yaw from rads to degs and prints prints
function get_yaw()
    local yaw_radians = ahrs:get_yaw()
   
    if yaw_radians < 0.0 then
        yaw_radians = yaw_radians + (2 * 3.14159)
    end
    
    local yaw_degrees = yaw_radians * 57.2958
    
    print(string.format("Yaw: %.3f", yaw_degrees))
end

function get_location()
    local gps_instance = gps:primary_sensor()
    local location_ud = gps:location(gps_instance)
    
    print(string.format("Long: %.3f", location_ud:lng() / 1e+7))
    print(string.format("Lat: %.3f", location_ud:lat() / 1e+7))
end

return send_initial_istate()