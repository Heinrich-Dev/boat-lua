local PLAN_OUTPUT = "plan.lua"
local plan_table = {}

-- Splits the given string by the given delim
function split(str, delim)
    local sub = {}
    for substr in string.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(sub, substr)
    end
    return sub
end

-- Converts a single line of a .plan file to a table
function load_contour(line)
    line_split = split(line, ",")
    return {
        point_one = {line_split[1], line_split[2]},
        point_two = {line_split[3], line_split[4]},
        heading = {line_split[5], line_split[6]}
    }
end

-- Writes a table to a file. Assumes the file is open
function write_table(file, table)
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
            file:write("\n        heading = {\n")
            file:write("            heading_start = ", contour.heading[1])
            file:write(",\n            heading_end = ", contour.heading[2])
            file:write("\n        }")
            file:write("\n    },\n") -- End of contour
        end
    file:write("}")
    file:write("\nreturn plan_table") -- This is always the end the a lua file with a table
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
        end
        table.insert(plan_table, load_contour(line))
    end

    -- Open the output file
    local output, err = io.open(PLAN_OUTPUT, "w")
    if output == nil then
        print("Error opening file, ", err)
        return
    end

    write_table(output, plan_table)
    output:close()
end

load_file()