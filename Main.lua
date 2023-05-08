local code = [[
    local a = "hi"
    print(a)
]]
local lexer = require("lexer")
local coed = lexer(code)
local base64enc = require("base64enc")

function AddBase64Decoder(code)
    local amogus = "function decode(data) local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end "
    return amogus..code
end
function RenameStrings(code)
    local strings = {}
    for i,v in pairs(coed) do
        for a,b in pairs(v) do
            if b["type"] == "string" then
                table.insert(strings, b["data"])
            end
        end
    end
    for i,v in pairs(strings) do
        local str = string.format("%q", v)
        code = code:gsub(str:gsub("'","\\"), "decode('"..base64enc.encode(v).."')")
    end
    return code
end


code = AddBase64Decoder(code)
code = RenameStrings(code)
print(code)