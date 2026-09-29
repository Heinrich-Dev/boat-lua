local contourModule = {}
local tolerance = .0001
-- contour should be a single contour, so an index
-- in the IStates table, not the whole table
function contourModule.distanceFromContour(location, contour)
    local x0 = location:lng() / 1e+7
    local y0 = location:lat() / 1e+7

    local x1 = contour["point_one"]["x"]
    local y1 = contour["point_one"]["y"]
    local x2 = contour["point_two"]["x"]
    local y2 = contour["point_two"]["y"]

    local n1 = (y2-y1)*x0
    local n2 = (x2-x1)*y0
    local numerator = math.abs(n1-n2+(x2*y1)-(y2*x1))
    local denominator = math.sqrt(math.pow(y2-y1, 2) + math.pow(x2-x1, 2))
    local distance = numerator / denominator

    if distance <= tolerance then
        return true
    end
    return false
end

function contourModule.checkApproach(distance, prev_distance)
    if distance <= prev_distance then
        return true
    end
    return false
end

return contourModule
