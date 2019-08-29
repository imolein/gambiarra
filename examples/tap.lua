local test = require('gambiarra')
local count = 0
local failed = 0

test(function(state, testname, msg)
  if state == 'begin' then
    count = count + 1
  elseif state == 'pass' then
    io.write(string.format('ok %d - %s\n', count, testname))
  elseif state == 'fail' or state == 'except' then
    failed = failed + 1
    io.write(string.format('not ok %d - %s (%s) - %s\n', count, testname, state, msg))
  end
end)

test('First test', function()
  ok(1 == 1, 'One should be equal one')
end)

test('Second test', function()
  ok(2 == 2, 'Two should be equal two')
end)

io.write('1..' .. count .. '\n')

if failed == 0 then os.exit(0) else os.exit(1) end