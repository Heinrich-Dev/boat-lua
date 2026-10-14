local PLAN_FILENAME = "plan.lua"
local contour_table = {}
local heading_table = {}

-- Splits the given string by the given delim
function split(str, delim)
    local sub = {}
    for substr in string.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(sub, substr)
    end
    return sub
end

-- Converts a single contour of a .plan file to a table
function load_contour(line)
    line_split = split(line, ",")
    return {
        point_one = {line_split[1], line_split[2]},
        point_two = {line_split[3], line_split[4]},
    }
end

-- Converts the headings to a table
function load_headings(input)
    line = input:read("*line")
    line_split = split(line, ",")
    return line_split
end

-- Writes a list of contours to a file
function write_contours(file, table)
    file:write("local plan_table = {\n") -- This is always the start to a lua file with a table
    for index, contour in ipairs(table) do
        file:write("    {\n") -- Start of contour
        file:write("        point_one = {\n")
        file:write("            x = ", contour.point_one[1])
        file:write(",\n            y = ", contour.point_one[2])
        file:write("\n        },\n")
        file:write("        point_two = {\n")
        file:write("            x = ", contour.point_two[1])
        file:write(",\n            y = ", contour.point_two[2])
        file:write("\n        },")
        file:write("\n    },\n") -- End of contour
    end
    file:write("}")
end

-- Writes a list of headings to a file
function write_headings(file, table)
    file:write("\nlocal heading_table = {\n") -- This is always the start to a lua file with a table
    for index, heading in ipairs(table) do
        file:write("    ", heading)
        file:write(",\n")
    end
    file:write("}")
end

function load_file()
    -- Make sure user passed an input filename
    if arg[1] == nil then
        print("Error: usage load_file.lua [.plan file]")
        return
    end

    -- Open the .plan file
    local input, err = io.open(arg[1], "r")
    if input == nil then
        print("Error opening file, ", err)
        return
    end

    -- Read each line and store it in a table
    while true do
        local line = input:read("*line")
        if not line then
            break
        elseif line == "" then -- if there is an empty line, read the next line as headings then exit the loop
            heading_table = load_headings(input)
            break
        end
        table.insert(contour_table, load_contour(line)) -- insert the next contour
    end

    -- Open the output file
    local plan_file, err = io.open(PLAN_FILENAME, "w")
    if plan_file == nil then
        print("Error opening file, ", err)
        return
    end

    -- Write the contours and headings to the table file
    write_contours(plan_file, contour_table)
    write_headings(plan_file, heading_table)
    plan_file:write("\nreturn {plan_table, heading_table}")

    plan_file:close()
end

load_file()