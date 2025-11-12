--- This module contains all of the logic to run the lightweight unit testing framework.
-- In order to make use of this system the user is required to define at least 1 thing: a unit.
-- @module lolwut
--[[ A unit is an isolated grouping of related logic to be tested. It is implemented here as a table containing a "name" field as
well as any number of individual unit tests defined as functions whose names are prefixed with the unit name followed by two
underscores (e.g.: unit_name__test_name). It is up to the developer to determine the appropriate scope and criteria for what
qualifies a "unit". For example, a developer may decide that it makes the most sense to define a unit as a single invocation of a
function with a specific fixed input. In practice, this would mean that each unit is comprised of exactly 1 unit test. However, a
developer may find it useful to organize related unit tests under a shared context. An example of this might be: I, as a
developer, want to test the functionality of every single function defined in a file, utils.lua. With each function within the
utils module I will define a corresponding set of test functions which verify the behavior of the function under conditions
specific to each test. Additionally, since all the functions under test exist within the same source file, I will define a
module-level unit (e.g.: "utils__test") to contain the tests. Here is an example of a multi-test unit:

function example__test()
    return {
        name = "example",
        example__given_A__then_X = function ()
            -- given
            -- initialize locals for test
            local TestClass
            -- ...

            -- when
            -- execute the logic under test
            TestClass = class()
            -- ...

            -- then
            -- evaluate the results
            assert(TestClass ~= nil)
            -- ...
        end,
        example__given_B__then_Y = function ()
            -- ...given B conditions...
            -- ...when example() invoked...
            -- ...then Y result...
        end,
        example__given_C__then_Z = function ()
            -- ...given...
            -- ...when...
            -- ...then...
        end -- , etc....
    }
end

After you've defined your tests simply #include the modules containing your tests as well as the lolwut module within your test
cart (e.g.: test.p8, etc.) and then your defined tests will automatically run when you run your cart. --]]

local TEST_SUFFIX = "__test" -- Prefix used to distinguish testing units from other functions in the environment.

-- Check whether the given object is a function.
local function is_function(thing) return type(thing) == "function" end
-- Check whether the given string refers to a testing unit.
local function is_unit(function_name) return sub(function_name, -#TEST_SUFFIX) == TEST_SUFFIX end
-- Check whether the given string refers to an individual unit test.
local function is_test(function_name, unit_name)
    local prefix = unit_name .. "__"
    return sub(function_name, 1, #prefix) == prefix
end

-- Convert the character in char_code to puny case if shift_puny == true or normal case otherwise.
local function to_or_from_puny_case(char_code, shift_puny)
    local lower_bound, upper_bound, case_shift
    if (shift_puny) then
        lower_bound, upper_bound, case_shift = 97, 122, -32
    else
        lower_bound, upper_bound, case_shift = 65,  90,  32
    end
    if char_code >= lower_bound and char_code <= upper_bound then
        return char_code + case_shift
    end
    return char_code
end

-- Transform a string so that each letter immediately preceeded by a space (" ") appears capitalized in the PICO-8 console.
local function to_puny_camel_case(str)
    local result = ""
    local capitalize_next = true -- Flag to indicate if the next character should be capitalized.
    for i = 1, #str do
        local char = sub(str, i, i)
        if char == " " then
            result = result .. char
            capitalize_next = true -- A space means the next character starts a new word to be capitalized.
        else
            if capitalize_next then
                result = result .. chr(to_or_from_puny_case(ord(char), false)) -- Convert leading letter to normal case (displayed as larger-case in PICO-8 console).
                capitalize_next = false
            else
                result = result .. chr(to_or_from_puny_case(ord(char), true)) -- Convert subsequent letters to puny case (displayed as smaller-case in PICO-8 console).
            end
        end
    end
    return result
end

-- Alias of print(str) which transforms the string in question into puny camel case.
local function puny_print(str) print(to_puny_camel_case(str)) end

-- Fetch all unit tests associated with the given unit as a table containing a test "count" field as well as the "tests" sequence.
local function unit_tests(unit)
    local count = 0
    local tests = {}
    for test_name, test_fun in pairs(unit) do
        if is_function(test_fun) and is_test(test_name, unit.name) then
            count += 1 -- Increment test count for this unit.
            tests[count] = {unit_prefix = unit.name .. "__", name = test_name, fun = test_fun} -- Set name and callback for the current test.
        end
    end
    return {count = count, tests = tests} -- Return unit under test.
end

-- Execute all test functions contained within each test unit returned by executing all global functions ending in TEST_SUFFIX.
local function run_tests()
    local units = {}
    cls()
    puny_print("\f6searching for unit tests...\n")
    for unit_name, unit_fun in pairs(_ENV) do
        if is_function(unit_fun) and is_unit(unit_name) then
            units[unit_name] = unit_fun
        end
    end
    print(".------------------------------.")
    for unit_name, unit_fun in pairs(units) do
        local unit = unit_fun() -- Retrieve unit under test.
        local unit_tests = unit_tests(unit) -- Retrieve individual unit tests.
        puny_print("|◀ Testing Unit: " .. sub(unit_name, 1, -7) .. " (" .. unit_tests.count .. ") ▶")
        print(":=----------------------------=:")
        for i = 1, unit_tests.count do
            local test = unit_tests.tests[i] -- Retrieve the current unit test.
            local cursor_y = peek(0x5f27)
            print("| \f8✽\f6 " .. sub(test.name, #test.unit_prefix + 1))
            test.fun() -- Execute the current unit test.
            cursor(0, cursor_y - (cursor_y >= 19 * 6 and 6 or 0))
            print("| \fb✽\f6 ")
        end
        print(":==============================:")
    end
end

run_tests() -- Run all tests on #include!