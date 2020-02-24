[![Build Status](https://drone.kokolor.es/api/badges/imo/gambiarra/status.svg)](https://drone.kokolor.es/imo/gambiarra)

# Gambiarra

Gambiarra is a Lua version of Kludjs, and follows the idea of ultimately
minimal unit testing.

This is a fork from of [zserges's](https://bitbucket.org/zserge/) [Gambiarra](https://bitbucket.org/zserge/gambiarra). It was based on [salamandern's](https://bitbucket.org/salamandern/) [changes](https://bitbucket.org/salamandern/gambiarra/src), but I removed them in ce0ce2cbe4.

## Install

Get the sources:

`git clone https://git.kokolor.es/imo/gambiarra.git`

or `git clone https://codeberg.org/imo/gambiarra.git`

Or get only `gambiarra.lua` and start writing tests:

`wget https://git.kokolor.es/imo/gambiarra/raw/branch/master/gambiarra.lua`

or `wget https://codeberg.org/imo/gambiarra/raw/branch/master/gambiarra.lua`

## Example

```lua
-- Simple synchronous test
test('Check dogma', function()
    ok(2+2 == 5, 'two plus two equals five')
end)

-- A more advanced asyncrhonous test
test('Do it later', function(done)
    someAsyncFn(function(result)
        ok(result == expected)
        done()     -- this starts the next async test
    end)
end, true)     -- 'true' means 'async test' here
```

## API

`require('gambiarra')` returns a test function which can also be used to
customize test reports:

```lua
local test = require('gambiarra')
```

`test(name:string, f:function, [async:bool])` allows you to define a new test:

```lua
test('My sync test', function()
end)

test('My async test', function(done)
    done()
end, true)
```

`test()` defines also three helper functions that are added when test is
executed - `ok`, `eq`, and `spy`.

### `ok(cond:bool, [msg:string])`
It's a simple assertion helper. It takes any boolean condition and an optional assertion message.
If no message is defined - current filename and line will be used.

```lua
ok(1 == 1)                   -- prints 'foo.lua:42'
ok(1 == 1, 'one equals one') -- prints 'one equals one'
```

### `eq(a, b)`
It's a helper to deeply compare lua variables. It supports numbers, strings, booleans, nils,
functions and tables. It's mostly useful within `ok()`:

```lua
ok(eq(1, 1))
ok(eq('foo', 'bar'))
ok(eq({a='b',c='d'}, {c='d',a='b'})
```

If it is used within `ok()` and the compared values are not equal, `ok()` print what
it expected but what it got.

```lua
local x = 1
eq(ok(x, 1), "x is one") -- OUT: "One is one"
eq(ok(x, 2), "x is one") -- OUT: "One is one: Expected 2 but got 1"
eq(ok({a='b',c='d'}, {c='d',a='b'}), "Tables are equal") -- OUT: "Expected table 0864545 but got table 08115636"
-- If you define __tostring metamethods for your tables, they will be used.
```

### `spy([f])`
It creates function wrappers that remember each their call
(arguments, errors) but behaves much like the real function. Real function is
optional, in this case `spy()` will return `nil`, but will still record it's calls.
Spies are most helpful when passing them as callbacks and testing that they
were called with correct values.

```lua
local f = spy(function(s) return #s end)
ok(f('hello') == 5)
ok(f('foo') == 3)
ok(#f.called == 2)
ok(eq(f.called[1], {'hello'})
ok(eq(f.called[2], {'foo'})
f(nil)
ok(f.errors[3] ~= nil)
```

## Reports

To have gambiarra print a concluding report at the end, use `test:report()`:

```lua
local test = require "gambiarra"
test:report()
-- OUT: "All 0 tests passed."
```

Another useful feature is that you can customize test reports as you need.
But default tests are printed in color using ANSI escape sequences. If your
environment doesn't support it - you can easily override this behavior as
well as add any other information you need (number of passed/failed
assertions, time the test took etc):

```lua
local passed = 0
local failed = 0
local clock = 0

test(function(event, testfunc, msg)
    if event == 'begin' then
        print('Started test', testfunc)
        passed = 0
        failed = 0
        clock = os.clock()
    elseif event == 'end' then
        print('Finished test', testfunc, passed, failed, os.clock() - clock)
    elseif event == 'pass' then
        passed = passed + 1
    elseif event == 'fail' then
        print('FAIL', testfunc, msg)
        failed = failed + 1
    elseif event == 'except' then
        print('ERROR', testfunc, msg)
    end
end)
```

Additionally, you can pass a different environment to keep `_G` unpolluted:

```lua
test(function() ... end, myenv)

test('Some test', function()
    myenv.ok(myenv.eq(...))
    local f = myenv.spy()
end)
```

## Contributing

Please open issues or pull requests at codeberg: https://codeberg.org/imo/gambiarra

## Appendix

Library supports Lua >5.1. It is distributed under the MIT license. Contributers can be found in [CONTRIBUTORS.md](CONTRIBUTORS.md).
Enjoy!
