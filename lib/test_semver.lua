-- test_semver.lua — unit test for lib/semver.lua, fed TSV (ver<TAB>range<TAB>rc)
-- on stdin by scripts/test.sh (avoids a JSON dependency in Lua).
package.path = (arg[0]:match("^(.*)/[^/]*$") or ".") .. "/?.lua;" .. package.path
local semver = require("semver")

local fail = 0
local n = 0
for line in io.lines() do
    local ver, range, rc = line:match("^(.-)\t(.-)\t(%d+)$")
    if ver then
        n = n + 1
        local got = semver.satisfies(ver, range)
        if got ~= tonumber(rc) then
            io.stderr:write(("FAIL ver=%s range=%s want=%s got=%s\n"):format(ver, range, rc, tostring(got)))
            fail = fail + 1
        end
    end
end
if fail > 0 then os.exit(1) end
print(("lua semver: ok (%d cases)"):format(n))
