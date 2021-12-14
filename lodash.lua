--- This module provides a 1:1 copy of lodash functions for use in the lua programming language.
-- @module lib.lodash

local lodash = {}

-- "Function" Methods

---The opposite of _.before; this method creates a function that invokes `func` once it's called `n` or more times.
---@param n number @The number of calls before `func` is invoked.
---@param func function @The function to restrict.
---@return function @Returns the new restricted function.
function lodash.after(n, func)
    local result = function(...)
        if n == 0 then
            return func(...)
        end
        n = n - 1
    end
    return result
end

---Create a function that invoke `func`, with up to `n` arguments, ignoring any additional arguments.
---@param func function @The function to wrap.
---@param n number @The arity cap
---@return function @Returns the new capped function.
function lodash.ary(func, n)
    local result = function(...)
        return func(table.unpack(arg))
    end
    return result
end

---Create a function that invokes func, when the `self` binding and arguments of the created function function, while it's called less than `n` times. Subsequent calls to the created function return the result of the last `func` invocation.
---@param n number @The number of calls at which `func` is no longer invoked.
---@param func function @The function to restrict.
---@return function @Returns the new restricted function.
function lodash.before(n, func)
    local result = function(...)
        if n > 0 then
            n = n - 1
            return func(...)
        end
    end
    return result
end

---Creates a function that invokes `func` with `self` binding of `thisArg` and `partials` preprended to the arguments it receives.
---@param func function @The function to bind.
---@param thisArg any @The `self` binding of `func`.
---@param ... any @The arguments to prepend to those provided to the new function.
---@return function @Returns the new bound function.
function lodash.bind(func, thisArg, ...)
    local result = function(...)
        return func(thisArg, ...)
    end
    return result
end

---Create a function that invokes the method at `object[key]` with `partials` prepended to the arguments it receives.
---
---This method differs from `_.bind` by allowing bound functions to reference methods that may be redefined or don't yet exist. See [Peter Michaux's article](http://peter.michaux.ca/articles/lazy-function-definition-pattern) for more details.
---@param object table @The object to invoke the method on.
---@param key string @The key of the method.
---@param ... any @The arguments to prepend to those provided to the new function.
---@return function @Returns the new bound function.
function lodash.bindKey(object, key, ...)
    local result = function(...)
        return object[key](object, ...)
    end
    return result
end

---Creates a function that accepts arguments of `func` and either invokes `func` returning its result, if at least `arity` number of arguments have been provided, or returns a function that accepts the remaining `func` arguments, and so on. The arity of `func` may be specified if `func.length` is not sufficient.
---@param func function @The function to curry.
---@param arity number @The arity of `func`.
---@return function @Returns the new curried function.
function lodash.curry(func, arity)
    local result = function(...)
        local args = {...}
        if #args >= arity then
            return func(table.unpack(args))
        else
            return lodash.curry(function(...)
                local newArgs = {...}
                for i = 1, #args do
                    newArgs[i] = args[i]
                end
                return func(table.unpack(newArgs))
            end, arity - #args)
        end
    end
    return result
end

---This method is like `_.curry` except that arguments are applied to `func` in the manner of `_.partialRight` instead of `_.partial`.
---@param func function @The function to curry.
---@param arity number @The arity of `func`.
---@return function @Returns the new curried function.
function lodash.curryRight(func, arity)
    local result = function(...)
        local args = {...}
        if #args >= arity then
            return func(table.unpack(args))
        else
            return lodash.curryRight(function(...)
                local newArgs = {...}
                for i = #args, -1 do
                    newArgs[i] = args[i]
                end
                return func(table.unpack(newArgs))
            end, arity - #args)
        end
    end
    return result
end

---Create a function that negate the result of the predicate `func`. The `func` predicate is invoked with the `self` binding and arguments of the created function.
---@param func function @The predicate function.
---@return function @Returns the new function.
function lodash.negate(func)
    local result = function(...)
        return not func(...)
    end
    return result
end

---Creates a function that is restricted to invoking `func` once. Repeat calls to the function return the value of the first invocation. The `func` is invoked with the `self` binding and arguments of the created function.
---@param func function @The function to restrict.
---@return function @Returns the new restricted function.
function lodash.once(func)
    local called = false
    local value

    local result = function(...)
        if called then
            return value
        end
        called = true
        value = func(...)
        return value
    end
    called = false
    return result
end

---Create a function that invoke `func` with its arguments transformed.
---@param func function @The function to wrap.
---@param ... any @The arguments transforms.
---@return function @Returns the new function.
function lodash.overArgs(func, ...)
    local result = function(...)
        local args = {...}
        for i = 1, #args do
            args[i] = args[i]()
        end
        return func(table.unpack(args))
    end
    return result
end

---Create a function that invokes `func` with `partials` prepended to the arguments it receives. This method is like `_.bind` except it does **not** alter the `this` binding.
---@param func function @The function to partially apply arguments to.
---@param ... any @The arguments to be partially applied.
---@return function @Returns the new partially applied function.
function lodash.partial(func, ...)
    local result = function(...)
        local args = {...}
        for i = 1, #args do
            args[i] = args[i]
        end
        return func(table.unpack(args))
    end
    return result
end

---This method is like `_.partial` except that partially applied arguments are appended to the arguments it receives.
---@param func function @The function to partially apply arguments to.
---@param ... any @The arguments to be partially applied.
---@return function @Returns the new partially applied function.
function lodash.partialRight(func, ...)
    local result = function(...)
        local args = {...}
        for i = #args, 1, -1 do
            args[i] = args[i]
        end
        return func(table.unpack(args))
    end
    return result
end

---Create a function that invokes `func` with arguments arranged according to the specified `indexes` where the argument value at the first index is provided as the first argument, the argument value at the second index is provided as the second argument, and so on.
---@param func function @The function to rearrange arguments for.
---@param indexes table @The arranged argument indexes, which specifies the place of each argument on the return array.
---@return function @Returns the new function.
function lodash.rearg(func, indexes)
    local result = function(...)
        local args = {...}
        local newArgs = {}
        for i = 1, #indexes do
            newArgs[i] = args[indexes[i]]
        end
        return func(table.unpack(newArgs))
    end
    return result
end

---Creates a function that invokes `func` with the `this` binding of the created function and arguments from `start` and beyond provided as an array.
---@param func function @The function to apply a rest parameter to.
---@param start number @The start position of the rest parameter.
---@return function @Returns the new function.
function lodash.rest(func, start)
    local result = function(...)
        local args = {...}
        local newArgs = {}
        for i = start or 1, #args do
            newArgs[i - start + 1] = args[i]
        end
        return func(table.unpack(newArgs))
    end
    return result
end

---Creates a function that invokes `func` with the `self` binding of the created function and an array of arguments much like [Function#apply](http://www.ecma-international.org/ecma-262/7.0/#sec-function.prototype.apply) does.
---@param func function @The function to spread arguments over.
---@return function @Returns the new function.
function lodash.spread(func)
    local result = function(args)
        return func(table.unpack(args))
    end
    return result
end

---Creates a function that accepts up to one argument, ignoring any additional arguments.
---@param func function @The function to cap arguments for.
---@return function @Returns the new function.
function lodash.unary(func)
    local result = function(a1)
        return func(a1)
    end
    return result
end

---Create a function that provides `values` to `wrapper` as its arguments. Any additional arguments provided to the created function are appended to those provided to the `wrapper`. The created function is invoked with the `self` binding of the created function.
---@param value any @The value to wrap.
---@param wrapper function @The wrapper function.
---@return function @Returns the new function.
function lodash.wrap(value, wrapper)
    local result = function(...)
        local args = {...}
        for i = 1, #args do
            args[i] = args[i]
        end
        return wrapper(value, table.unpack(args))
    end
    return result
end

-- "Lang" methods

---Casts value to an array if it's not one.
---@param value any @The value to inspect.
---@return table @Returns the cast array.
function lodash.castArray(value)
    if lodash.isArray(value) then
        return value
    else
        return {value}
    end
end

---Creates the shallow clone of `value`.
---
---Note: This method is loosely based on the [structured clone algorithm](https://mdn.io/Structured_clone_algorithm) and supports cloning arrays, array buffers, booleans, date objects, maps, numbers, Object objects, regexes, sets, strings, symbols, and typed arrays. The own enumerable properties of `arguments` objects are cloned as plain objects. An empty object is returned for uncloneable values such as error objects, functions, DOM nodes, and WeakMaps.
---@param value any @The value to clone.
---@return any @Returns the cloned value.
function lodash.clone(value)
    local result = {}
    if lodash.isArray(value) then
        for i = 1, #value do
            result[i] = value[i]
        end
    elseif lodash.isObject(value) then
        for k, v in pairs(value) do
            result[k] = v
        end
    else
        result = value
    end
    return result
end

---This method is like `_.clone` except that it recursively clones `value`.
---@param value any @The value to recursively clone.
---@return any @Returns the deep cloned value.
function lodash.cloneDeep(value)
    local result = {}
    if lodash.isArray(value) then
        for i = 1, #value do
            result[i] = lodash.cloneDeep(value[i])
        end
    elseif lodash.isObject(value) then
        for k, v in pairs(value) do
            result[k] = lodash.cloneDeep(v)
        end
    else
        result = value
    end
    return result
end

---This method is like `cloneWith` except that it recursively clones `value`.
---@param value any @The value to recursively clone.
---@param customizer function @The function to customize cloning.
---@return any @Returns the deep cloned value.
function lodash.cloneDeepWith(value, customizer)
    local result = {}
    if lodash.isArray(value) then
        for i = 1, #value do
            result[i] = lodash.cloneDeepWith(value[i], customizer)
        end
    elseif lodash.isObject(value) then
        for k, v in pairs(value) do
            result[k] = lodash.cloneDeepWith(v, customizer)
        end
    else
        result = value
    end
    return customizer(result)
end

---This method is like `_.clone` except that it accepts `customizer` which is invoked to produce the cloned value. If `customizer` returns `undefined`, cloning is handled by the method instead. The `customizer` is invoked with up to six arguments; (value [, index|key, object, stack]).
---@param value any @The value to clone.
---@param customizer function @The function to customize cloning.
---@return any @Returns the cloned value.
function lodash.cloneWith(value, customizer)
    local result = {}
    if lodash.isArray(value) then
        for i = 1, #value do
            result[i] = lodash.cloneWith(value[i], customizer)
        end
    elseif lodash.isObject(value) then
        for k, v in pairs(value) do
            result[k] = lodash.cloneWith(v, customizer)
        end
    else
        result = value
    end
    return customizer(result)
end

---Checks if `object` conforms to `source` by invoking the predicate properties of `source` with the corresponding property values of `object`.
---
---**Note:** This method is equivalent to `_.conformsTo` with `source` partially applied.
---@param object any @The object to inspect.
---@param source table @The object of property predicates to conform to.
---@return boolean @Returns `true` if `object` conforms, else `false`.
function lodash.conformsTo(object, source)
    for k, v in pairs(source) do
        if not lodash.isFunction(v) then
            if not lodash.isEqual(object[k], v) then
                return false
            end
        else
            if not v(object[k]) then
                return false
            end
        end
    end
    return true
end

---Performs a SameValueZero comparison between two values to determine if they are equivalent. \
---@param value any @The value to compare.
---@param other any @The other value to compare.
---@return boolean @Returns `true` if the values are equivalent, else `false`.
function lodash.eq(value, other)
    return value == other
end

---Check if value is greater than `other`.
---@param value any @The value to compare.
---@param other any @The other value to compare.
---@return boolean @Returns `true` if `value` is greater than `other`, else `false`.
function lodash.gt(value, other)
    return value > other
end

---Check if value is greater than or equal to `other`.
---@param value any @The value to compare.
---@param other any @The other value to compare.
---@return boolean @Returns `true` if `value` is greater than or equal to `other`, else `false`.
function lodash.gte(value, other)
    return value >= other
end

---Check if `value` is classified as an `Array` object.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is an array, else `false`.
function lodash.isArray(value)
    return type(value) == "table" and getmetatable(value) == nil and #value > 0
end

---Check if `value` is classified as a boolean primitive
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is a boolean, else `false`.
function lodash.isBoolean(value)
    return type(value) == "boolean"
end

---Check if `value` is an empyu object.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is an empty object, else `false`.
function lodash.isEmpty(value)
    if lodash.isObject(value) then
        for _ in pairs(value) do
            return false
        end
    end
    return true
end

---Performs a deep comparison between two values to determine if they are equivalent.
---@param value any @The value to compare.
---@param other any @The other value to compare.
---@return boolean @Returns `true` if the values are equivalent, else `false`.
function lodash.isEqual(value, other)
    if lodash.isObject(value) then
        if lodash.isObject(other) then
            if lodash.isArray(value) then
                if lodash.isArray(other) then
                    if #value == #other then
                        for i = 1, #value do
                            if not lodash.isEqual(value[i], other[i]) then
                                return false
                            end
                        end
                        return true
                    end
                end
            else
                for k, v in pairs(value) do
                    if not lodash.isEqual(v, other[k]) then
                        return false
                    end
                end
                for k, v in pairs(other) do
                    if not lodash.isEqual(value[k], v) then
                        return false
                    end
                end
                return true
            end
        end
    else
        return value == other
    end
    return false
end

---This method is like `isEqual` except that it accepts `customizer` which is invoked to compare values. If `customizer` returns `undefined`, comparisons are handled by the method instead. The `customizer` is invoked with up to six arguments; (value, other, index|key, object, stack).
---@param value any @The value to compare.
---@param other any @The other value to compare.
---@param customizer function @The function to customize comparisons.
---@return boolean @Returns `true` if the values are equivalent, else `false`.
function lodash.isEqualWith(value, other, customizer)
    if lodash.isObject(value) then
        if lodash.isObject(other) then
            if lodash.isArray(value) then
                if lodash.isArray(other) then
                    if #value == #other then
                        for i = 1, #value do
                            if not lodash.isEqualWith(value[i], other[i], customizer) then
                                return false
                            end
                        end
                        return true
                    end
                end
            else
                for k, v in pairs(value) do
                    if not lodash.isEqualWith(v, other[k], customizer) then
                        return false
                    end
                end
                for k, v in pairs(other) do
                    if not lodash.isEqualWith(value[k], v, customizer) then
                        return false
                    end
                end
                return true
            end
        end
    else
        return customizer(value, other) == nil
    end
    return false
end

---Check if `value` is a error string
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is a error string, else `false`.
function lodash.isError(value)
    return type(value) == "string" and string.find(value, "^[Ee]rror:")
end

---Check if `value` is a finite number.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is a finite number, else `false`.
function lodash.isFinite(value)
    return type(value) == "number" and value > -math.huge and value < math.huge
end

---Check if `value` is a function.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is a function, else `false`.
function lodash.isFunction(value)
    return type(value) == "function"
end

---Check if `value` is an integer.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is an integer, else `false`.
function lodash.isInteger(value)
    return type(value) == "number" and math.floor(value) == value
end

---Performs a partial deep comparison between `object` and `other` to determine if they have equivalent property values.
---
---**Note:** This method is equivalent to `_.matches` when `source` is partially applied.
---@param object table @The object to inspect.
---@param source table @The other object to compare.
---@return boolean @Returns `true` if the objects are equivalent, else `false`.
function lodash.isMatch(object, source)
    for k, v in next, object do
        for k2, v2 in next, source do
            if k == k2 and not lodash.isEqual(v, v2) then
                return false
            end
        end
    end
    return true
end

---Check if `value` is classified as a `Number` primitive
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is a number, else `false`.
function lodash.isNumber(value)
    return type(value) == "number"
end

---Check if `value` is classified as a `Object` primitive.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is an object, else `false`.
function lodash.isObject(value)
    return type(value) == "table" or type(value) == "userdata"
end

---Check if `value` is object-like. A value is object-like if it's not null and has a type of object or userdata.
---@param value any @The value to check.
---@return boolean @Returns `true` if `value` is object-like, else `false`.
function lodash.isObjectLike(value)
    return value ~= nil and type(value) == "table" or type(value) == "userdata"
end

---Check if `value` is less than `other`.
---@param value any @The value to check.
---@param other any @The other value to compare.
---@return boolean @Returns `true` if `value` is less than `other`, else `false`.
function lodash.lt(value, other)
    return value < other
end

---Check if `value` is less than or equal to `other`.
---@param value any @The value to check.
---@param other any @The other value to compare.
---@return boolean @Returns `true` if `value` is less than or equal to `other`, else `false`.
function lodash.lte(value, other)
    return value <= other
end

---Converts `value` to an `array`.
---@param value any @The value to convert.
---@return table @Returns the converted array.
function lodash.toArray(value)
    if lodash.isArray(value) then
        return value
    elseif lodash.isObject(value) then
        local result = {}
        for k, v in pairs(value) do
            result[k] = v
        end
        return result
    else
        return {value}
    end
end

---Converts `value` to a number.
---@param value any @The value to convert.
---@return any @Returns the converted number.
function lodash.toInteger(value)
    if lodash.isInteger(value) then
        return value
    elseif lodash.isNumber(value) then
        return math.floor(value)
    else
        return 0
    end
end


-- "Array" methods

---Creates an array of elements split into groups the length of size. If array can't be split evenly, the final chunk will be the remaining elements.
---@param array table @The array to process.
---@param size number @The length of each chunk.
---@return table @Returns the new array of chunks.
function lodash.chunk(array, size)
    local result = {}
    local n = #array
    for i = 1, n, size do
        result[#result + 1] = lodash.slice(array, i, i + size - 1)
    end
    return result
end

---Creates an array with all falsey values removed. The values false, nil, 0, "", null, and NaN are falsey.
---@param array table @The array to compact.
---@return table @Returns the new array of filtered values.
function lodash.compact(array)
    local result = {}
    for i = 1, #array do
        if array[i] then
            result[#result + 1] = array[i]
        end
    end
    return result
end

---Creates a new array concatenating `array` with any additional arrays and/or values.
---@param array table @The array to concatenate.
---@param ... table The values to concatenate.
---@return table @Returns the new concatenated array.
function lodash.concat(array, ...)
    local result = {}
    for i = 1, #array do
        result[#result + 1] = array[i]
    end
    for i = 1, select('#', ...) do
        local arg = select(i, ...)
        if lodash.isArray(arg) then
            for j = 1, #arg do
                result[#result + 1] = arg[j]
            end
        else
            result[#result + 1] = arg
        end
    end
    return result
end

--- Creates an array of unique array values not included in the other given arrays using [SameValueZero](http://ecma-international.org/ecma-262/7.0/#sec-samevaluezero) for equality comparisons.
--- The order and references of result values are determined by the first array.
--- @param array table @The array to inspect.
--- @param ... table @The arrays of values to exclude.
--- @return table @Returns the new array of filtered values.
function lodash.difference(array, ...)
    local result = {}
    for i = 1, #array do
        result[#result + 1] = array[i]
    end
    for i = 1, select('#', ...) do
        local arg = select(i, ...)
        for j = 1, #arg do
            for k = 1, #result do
                if lodash.isEqual(result[k], arg[j]) then
                    result[k] = nil
                end
            end
        end
    end
    return lodash.compact(result)
end

---This method is like [`_.difference`](#_.difference) except that it accepts iteratee which is invoked for each element of array and values to generate the criterion by which they're compared. The order and references of result values are determined by the first array. The iteratee is invoked with one argument: (value).
---
---**Note** Unlike [`_.pullAllBy`](#_.pullAllBy), this method returns a new array.
---@param array table @The array to inspect.
---@param iteratee function @The iteratee invoked per element.
---@param ... table @The values to exclude.
---@return table @Returns the new array of filtered values.
function lodash.differenceBy(array, iteratee, ...)
    if not iteratee then
        iteratee = lodash.identity
    end
    if lodash.isFunction(iteratee) then
        local result = {}
        for i = 1, #array do
            result[#result + 1] = array[i]
        end
        for i = 1, select('#', ...) do
            local arg = select(i, ...)
            for j = 1, #arg do
                for k = 1, #result do
                    if lodash.isEqual(iteratee(result[k]), iteratee(arg[j])) then
                        result[k] = nil
                    end
                end
            end
        end
        return lodash.compact(result)
    else
        return lodash.difference(array, ...)
    end
end

---This method is like [`_.difference`](#_.difference) except that it accepts comparator which is invoked to compare elements of array to values. The order and references of result values are determined by the first array. The comparator is invoked with two arguments: (arrVal, othVal).
---
---**Note:** Unlike [`_.pullAllWith`](#_.pullAllWith), this method returns a new array.
---@param array table @The array to inspect.
---@param values table @The values to exclude.
---@param comparator function @The comparator invoked per element.
---@return table @Returns the new array of filtered values.
function lodash.differenceWith(array, values, comparator)
    local result = {}
    for i = 1, #array do
        result[#result + 1] = array[i]
    end
    for i = 1, #values do
        for k = 1, #result do
            if comparator(result[k], values[i]) then
                result[k] = nil
            end
        end
    end
    return lodash.compact(result)
end

---Create a slice of `array` with `n` elements dropped from the beginning.
---@param array table @The array to query.
---@param n number @The number of elements to drop. Default: 1.
---@return table @Returns the slice of `array`.
function lodash.drop(array, n)
    n = n or 1
    return lodash.slice(array, n + 1)
end

---Creates a slice of `array` with `n` elements dropped from the end.
---@param array table @The array to query.
---@param n number @The number of elements to drop. Default: 1.
---@return table @Returns the slice of `array`.
function lodash.dropRight(array, n)
    n = n or 1
    return lodash.slice(array, 1, #array - n)
end

--- Creates a slice of `array` excluding elements dropped from the end.
--- Elements are dropped until `predicate` returns falsey.
--- The predicate is invoked with three arguments: (value, index, array).
--- @param array table @The array to query.
--- @param predicate function @The function invoked per iteration.
--- @return table @Returns the slice of `array`.
function lodash.dropRightWhile(array, predicate)
    for i = #array, 1, -1 do
        if not predicate(array[i], i, array) then
            return lodash.slice(array, 1, i)
        end
    end
    return {}
end

---Creates a slice of `array` excluding elements dropped from the beginning.
---Elements are dropped until `predicate` returns falsey. The predicate is invoked with three arguments: (value, index, array).
---@param array table @The array to query.
---@param predicate function @The function invoked per iteration.
---@return table @Returns the slice of `array`.
function lodash.dropWhile(array, predicate)
    for i = 1, #array do
        if not predicate(array[i], i, array) then
            return lodash.slice(array, i)
        end
    end
    return {}
end

---Fill elements of `array` with `value` from `start` up to, but not including, `end`.
---@param array table @The array to fill.
---@param value any @The value to fill `array` with.
---@param start number @The start position.
---@param endPos number @The end position.
---@return table @Returns `array`.
function lodash.fill(array, value, start, endPos)
    for i = start or 1, endPos or #array do
        array[i] = value
    end
    return array
end

---This method is like [`_.find`](#_.find) except that it returns the index of the first element `predicate` returns truthy for instead of the element itself.
---@param array table @The array to inspect.
---@param predicate function @The function invoked per iteration.
---@param fromIndex number @The index to search from.
---@return number @Returns the index of the found element, else `-1`.
function lodash.findIndex(array, predicate, fromIndex)
    local length = #array
    if length == 0 then
        return -1
    end
    fromIndex = fromIndex or 1
    if fromIndex < 0 then
        fromIndex = length + fromIndex
    end
    for i = fromIndex, length do
        if predicate(array[i], i, array) then
            return i
        end
    end
    return -1
end

---This method is like [`_.findIndex`](#_.findIndex) except that it iterates over elements of `collection` from right to left.
---@param array table @The array to inspect.
---@param predicate function @The function invoked per iteration.
---@param fromIndex number @The index to search from.
---@return number @Returns the index of the found element, else `-1`.
function lodash.findLastIndex(array, predicate, fromIndex)
    local length = #array
    if length == 0 then
        return -1
    end
    fromIndex = fromIndex or length
    if fromIndex > length then
        fromIndex = length
    end
    for i = fromIndex, 1, -1 do
        if predicate(array[i], i, array) then
            return i
        end
    end
    return -1
end

---Flattens `array` a single level deep.
---@param array table @The array to flatten.
---@return table @Returns the new flattened array.
function lodash.flatten(array)
    local result = {}
    for i = 1, #array do
        if lodash.isArray(array[i]) then
            for j = 1, #array[i] do
                result[#result + 1] = array[i][j]
            end
        else
            result[#result + 1] = array[i]
        end
    end
    return result
end

---Recursively flattens `array`.
---@param array table @The array to flatten.
---@return table @Returns the new flattened array.
function lodash.flattenDeep(array)
    local result = {}
    for i = 1, #array do
        if lodash.isArray(array[i]) then
            for j = 1, #array[i] do
                result[#result + 1] = array[i][j]
            end
        else
            result[#result + 1] = array[i]
        end
    end
    return lodash.flatten(result)
end

---Recursively flatten `array` up to `depth` times.
---@param array table @The array to flatten.
---@param depth number @The maximum recursion depth **Default:** 1.
---@return table @Returns the new flattened array.
function lodash.flattenDepth(array, depth)
    depth = depth or 1
    if depth == 0 then
        return array
    end
    local result = {}
    for i = 1, #array do
        if lodash.isArray(array[i]) then
            for j = 1, #array[i] do
                result[#result + 1] = array[i][j]
            end
        else
            result[#result + 1] = array[i]
        end
    end
    return lodash.flattenDepth(result, depth - 1)
end

---The inverse of [`_.toPairs`](#_.toPairs); this method returns an object composed from key-value `pairs`.
---@param pairs table @The key-value pairs.
---@return table @Returns the new object.
function lodash.fromPairs(pairs)
    local result = {}
    for i = 1, #pairs do
        result[pairs[i][1]] = pairs[i][2]
    end
    return result
end

---Get the first element of `array`.
---@param array table @The array to query.
---@return any @Returns the first element of `array`.
function lodash.head(array)
    return array[1]
end

---Gets the index at which the first occurrence of `value` is found in `array`. If `fromIndex` is negative, it's used as the offset from the end of array.
---@param array table @The array to inspect.
---@param value any @The value to search for.
---@param fromIndex number @The index to search from. (0 by default)
---@return number @Returns the index of the matched value, else `-1`.
function lodash.indexOf(array, value, fromIndex)
    local length = #array
    if length == 0 then
        return -1
    end
    fromIndex = fromIndex or 0
    if fromIndex < 0 then
        fromIndex = length + fromIndex
    end
    for i = fromIndex, length do
        if array[i] == value then
            return i
        end
    end
    return -1
end

---Gets all but the last element of `array`.
---@param array table @The array to query.
---@return table @Returns the slice of `array`.
function lodash.initial(array)
    return lodash.slice(array, 1, #array - 1)
end

---Create an array of unique values that are included in all given arrays. The order and references of result values are determined by the first array.
---@param ... table @The arrays to inspect.
---@return table @Returns the new array of intersecting values.
function lodash.intersection(...)
    local result = {}
    local args = {...}
    local length = #args
    if length == 0 then
        return result
    end
    local array = args[1]
    for i = 1, #array do
        local value = array[i]
        for j = 2, length do
            if not lodash.includes(args[j], value) then
                break
            end
            if j == length then
                result[#result + 1] = value
            end
        end
    end
    return result
end

---This method is like [`_.intersection`](#_.intersection) except that it accepts `iteratee`. The iteratee is invoked for each element of each arrays to generate the criterion by which they're compared. The order and references of result values are determined by the first array. The iteratee is invoked with one argument: (value).
---@param array table @The array to inspect.
---@param iteratee function @The iteratee invoked per element.
---@param ... table @The arrays to inspect.
---@return table @Returns the new array of intersecting values.
function lodash.intersectionBy(array, iteratee, ...)
    if not iteratee then
        iteratee = lodash.identity
    end
    local result = {}
    local args = {...}
    local length = #args
    if length == 0 then
        return result
    end
    local array = args[1]
    for i = 1, #array do
        local value = array[i]
        for j = 2, length do
            if not lodash.includes(args[j], value, iteratee) then
                break
            end
            if j == length then
                result[#result + 1] = value
            end
        end
    end
    return result
end

---This method is like [`_.intersection`](#_.intersection) except that it accepts `comparator`. The comparator is invoked with two arguments: (arrVal, othVal).
---@param array table @The array to inspect.
---@param comparator function @The comparator invoked per element.
---@param ... table @The arrays to inspect.
---@return table @Returns the new array of intersecting values.
function lodash.intersectionWith(array, comparator, ...)
    local result = {}
    local args = {...}
    local length = #args
    if length == 0 then
        return result
    end
    for i = 1, #array do
        local value = array[i]
        for j = 2, length do
            if not lodash.includes(args[j], value, comparator) then
                break
            end
            if j == length then
                result[#result + 1] = value
            end
        end
    end
    return result
end

---Converts all elements in `array` into a string separated by `separator`.
---@param array table @The array to convert.
---@param separator string @The element separator.
---@return string @Returns the joined string.
function lodash.join(array, separator)
    local result = ""
    for i = 1, #array do
        result = result .. array[i]
        if i ~= #array then
            result = tostring(result) .. separator
        end
    end
    return result
end

---Gets the last element of `array`.
---@param array table @The array to query.
---@return any @Returns the last element of `array`.
function lodash.last(array)
    return array[#array]
end

---This method is like `_.indexOf` except that it iterates over elements of `array` from right to left.
---@param array table @The array to inspect.
---@param value any @The value to search for.
---@param fromIndex number @The index to search from. *(optional)*
function lodash.lastIndexOf(array, value, fromIndex)
    local length = #array
    if length == 0 then
        return -1
    end
    fromIndex = fromIndex or length
    if fromIndex < 0 then
        fromIndex = length + fromIndex
    end
    for i = fromIndex, 1, -1 do
        if array[i] == value then
            return i
        end
    end
    return -1
end

---Gets the element at index `n` of array. If `n` is negative, the nth element from the end is returned.
---@param array table @The array to query.
---@param n number @The index of the element to return.
---@return any @Returns the nth element of `array`.
function lodash.nth(array, n)
    return array[n]
end

---Remove all elements from `array` that `predicate` returns truthy for and return an array of the removed elements. The predicate is invoked with three arguments: (value, index, array).
---@param array table @The array to modify.
---@param predicate function @The function invoked per iteration. *(optional)*
---@return table @Returns the new array of removed elements.
function lodash.remove(array, predicate)
    local result = {}
    local length = #array
    if length == 0 then
        return result
    end
    local index = 1
    for i = 1, length do
        local value = array[i]
        if not predicate or predicate(value, i, array) then
            result[#result + 1] = value
            table.remove(array, i)
        else
            array[index] = value
            index = index + 1
        end
    end
    return result
end


---Remove all given values from `array`.
---@param array table @The array to modify.
---@param ... any @The values to remove.
---@return table @Returns `array`.
function lodash.pull(array, ...)
    local args = {...}
    local length = #args
    if length == 0 then
        return
    end
    local index = 1
    for i = 1, #array do
        local value = array[i]
        for j = 1, length do
            if value == args[j] then
                table.remove(array, i)
                break
            end
        end
    end
    return array
end

---This method is like `_.pull` except that it accepts an array of values to remove.
---@param array table @The array to modify.
---@param values table @The values to remove.
---@return table @Returns `array`.
function lodash.pullAll(array, values)
    local length = #values
    if length == 0 then
        return
    end
    local index = 1
    for i = 1, #array do
        local value = array[i]
        for j = 1, length do
            if value == values[j] then
                table.remove(array, i)
                break
            end
        end
    end
    return array
end

---This method is like `_.pullAll` except that it accepts `iteratee` which is invoked for each element of `array` and `values` to generate the criterion of whether or not to remove the element.
---@param array table @The array to modify.
---@param values table @The values to remove.
---@param iteratee function @The iteratee invoked per element.
---@return table @Returns `array`.
function lodash.pullAllBy(array, values, iteratee)
    if not iteratee then
        iteratee = lodash.identity
    end
    local length = #values
    if length == 0 then
        return
    end
    local index = 1
    for i = 1, #array do
        local value = array[i]
        for j = 1, length do
            if not iteratee(values[j], value) then
                break
            end
            if j == length then
                table.remove(array, i)
                break
            end
        end
    end
    return array
end

---This method is like `_.pullAll` except that it accepts `comparator` which is invoked to compare elements of `array` to `values`. The comparator is invoked with two arguments: (arrVal, othVal).
---@param array table @The array to modify.
---@param values table @The values to remove.
---@param comparator function @The comparator invoked per element.
---@return table @Returns `array`.
function lodash.pullAllWith(array, values, comparator)
    local length = #values
    if length == 0 then
        return
    end
    local index = 1
    for i = 1, #array do
        local value = array[i]
        for j = 1, length do
            if not comparator(value, values[j])
                or j == length then
                break
            end
        end
        table.remove(array, i)
    end
    return array
end

---Removes elements from `array` corresponding to `indexes` and returns an array of removed elements.\
---@param array table @The array to modify.
---@param ... table @The indexes of elements to remove.
---@return table @Returns the new array of removed elements.
function lodash.pullAt(array, ...)
    local args = {...}
    local length = #args
    if length == 0 then
        return
    end
    local result = {}
    local index = 1
    for i = 1, #array do
        local value = array[i]
        for j = 1, length do
            if i == args[j] then
                table.insert(result, value)
                table.remove(array, i)
                break
            end
        end
    end
    return result
end

---Reverse `array` so that the first element becomes the last, the second element becomes the second to last, and so on.
---@param array table @The array to modify.
---@return table @Returns `array`.
function lodash.reverse(array)
    local len = #array
    local result = {}
    for idx = len, 1, -1 do
        result[#result + 1] = array[idx]
    end
    return result
end

---Creates a slice of `array` from `start` up to, but not including, `end`.
---@param array table @The array to slice.
---@param start number @The start position. (default: 1) *(optional)*
---@param endPos number @The end position. (default: array length) *(optional)*
---@return table @Returns the slice of `array`.
function lodash.slice(array, start, endPos)
    local len = #array
    start = start or 1
    if start < 0 then
        start = len + start
    end
    endPos = endPos or len
    if endPos < 0 then
        endPos = len + endPos
    end
    local result = {}
    for i = start, endPos do
        result[#result + 1] = array[i]
    end
    return result
end

---Uses a binary search to determine the lowest index at which `value` should be inserted into `array` in order to maintain its sort order.
---@param array table @The sorted array to inspect.
---@param value any @The value to evaluate.
---@return number @Returns the index at which `value` should be inserted into `array`.
function lodash.sortedIndex(array, value)
    array = table.sort(array)
    local len = #array
    local mid = math.floor(len / 2)
    local start = 1
    local endPos = len
    while start <= endPos do
        if array[mid] < value then
            start = mid + 1
        else
            endPos = mid - 1
        end
        mid = math.floor((start + endPos) / 2)
    end
    return start
end

---This method is like `_.sortedIndex` except that it accepts `iteratee` which is invoked for `value` and each element of `array` to compute their sort ranking. The iteratee is invoked with one argument: *(value)*.
---@param array table @The sorted array to inspect.
---@param value any @The value to evaluate.
---@param iteratee function @The iteratee invoked per element.
---@return number @Returns the index at which `value` should be inserted into `array`.
function lodash.sortedIndexBy(array, value, iteratee)
    array = table.sort(array, function(a, b)
        return iteratee(a) < iteratee(b)
    end)
    if not iteratee then
        iteratee = lodash.identity
    end
    local len = #array
    local mid = math.floor(len / 2)
    local start = 1
    local endPos = len
    while start <= endPos do
        if iteratee(array[mid]) < iteratee(value) then
            start = mid + 1
        else
            endPos = mid - 1
        end
        mid = math.floor((start + endPos) / 2)
    end
    return start
end

---This method is like `_.sortedIndexOf` except that it performs a binary search on a sorted `array`.
---@param array table @The sorted array to inspect.
---@param value any @The value to evaluate.
---@return number @Returns the index at which `value` should be inserted into `array`.
function lodash.sortedIndexOf(array, value)
    array = table.sort(array)
    local len = #array
    local mid = math.floor(len / 2)
    local start = 1
    local endPos = len
    while start <= endPos do
        if array[mid] == value then
            return mid
        elseif array[mid] < value then
            start = mid + 1
        else
            endPos = mid - 1
        end
        mid = math.floor((start + endPos) / 2)
    end
    return -1
end

---This method is like `_.sortedIndex` except that it returns the highest index at which `value` should be inserted into `array` in order to maintain its sort order.
---@param array table @The sorted array to inspect.
---@param value any @The value to evaluate.
---@return number @Returns the index at which `value` should be inserted into `array`.
function lodash.sortedLastIndex(array, value)
    array = table.sort(array)
    local len = #array
    local mid = math.floor(len / 2)
    local start = 1
    local endPos = len
    while start <= endPos do
        if array[mid] < value then
            start = mid + 1
        else
            endPos = mid - 1
        end
        mid = math.floor((start + endPos) / 2)
    end
    return start
end

---This method is like `_.sortedLastIndex` except that it accepts `iteratee` which is invoked for `value` and each element of `array` to compute their sort ranking. The iteratee is invoked with one argument: *(value)*.
---@param array table @The sorted array to inspect.
---@param value any @The value to evaluate.
---@param iteratee function @The iteratee invoked per element. .identity)
---@return number @Returns the index at which `value` should be inserted into `array`.
function lodash.sortedLastIndexBy(array, value, iteratee)
    array = table.sort(array, function(a, b)
        return iteratee(a) < iteratee(b)
    end)
    if iteratee then
        iteratee = lodash.identity
    end
    local len = #array
    local mid = math.floor(len / 2)
    local start = 1
    local endPos = len
    while start <= endPos do
        if iteratee(array[mid]) < iteratee(value) then
            start = mid + 1
        else
            endPos = mid - 1
        end
        mid = math.floor((start + endPos) / 2)
    end
    return start
end

---This method is like `_.sortedIndexOf` except that it performs a binary search on a sorted `array`.
---@param array table @The sorted array to inspect.
---@param value any @The value to evaluate.
---@return number @Returns the index at which `value` should be inserted into `array`.
function lodash.sortedLastIndexOf(array, value)
    array = table.sort(array)
    local len = #array
    local mid = math.floor(len / 2)
    local start = 1
    local endPos = len
    while start <= endPos do
        if array[mid] == value then
            return mid
        elseif array[mid] < value then
            start = mid + 1
        else
            endPos = mid - 1
        end
        mid = math.floor((start + endPos) / 2)
    end
    return -1
end

---This method is like `_.uniq` except that it's designed and optimized for sorted arrays.
---@param array table @The array to inspect.
---@return table @Returns the new duplicate free array.
function lodash.sortedUniq(array)
    local result = {}
    local len = #array
    local index = 1
    local last = array[len]
    for i = 1, len do
        if array[i] ~= last then
            result[index] = array[i]
            index = index + 1
            last = array[i]
        end
    end
    return result
end

---This method is like `_.uniqBy` except that it's designed and optimized for sorted arrays.
---@param array table @The array to inspect.
---@param iteratee function @The iteratee invoked per element.
---@return table @Returns the new duplicate free array.
function lodash.sortedUniqBy(array, iteratee)
    local result = {}
    local len = #array
    local index = 1
    local last = iteratee(array[len])
    for i = 1, len do
        local value = iteratee(array[i])
        if value ~= last then
            result[index] = array[i]
            index = index + 1
            last = value
        end
    end
    return result
end

---Gets all but the first element of `array`.
---@param array table @The array to query.
---@return table @Returns the slice of `array`.
function lodash.tail(array)
    local result = {}
    for i = 1, #array - 1 do
        result[i] = array[i + 1]
    end
    return result
end

---Create a slice of `array` with `n` elements taken from the beginning.
---@param array table @The array to query.
---@param n number @The number of elements to take. *(optional)* (default: 1)
---@return table @Returns the slice of `array`.
function lodash.take(array, n)
    n = n or 1
    local result = {}
    for i = 1, n do
        result[i] = array[i]
    end
    return result
end

---Create a slice of `array` with `n` elements taken from the end.
---@param array table @The array to query.
---@param n number @The number of elements to take. *(optional)* (default: 1)
---@return table @Returns the slice of `array`.
function lodash.takeRight(array, n)
    n = n or 1
    local result = {}
    local len = #array
    for i = len - n + 1, len do
        result[i - len + n] = array[i]
    end
    return result
end

---Create a slice of `array` with elements taken from the end. Elements are taken until `predicate` returns falsey. The predicate is invoked with three arguments: (value, index, array).
---@param array table @The array to query.
---@param predicate function @The function invoked per iteration. .identity)
---@return table @Returns the slice of `array`.
function lodash.takeRightWhile(array, predicate)
    predicate = predicate or lodash.identity
    local result = {}
    local len = #array
    for i = len, 1, -1 do
        if not predicate(array[i]) then
            len = i
            break
        end
    end
    for i = len, 1, -1 do
        result[i - len + 1] = array[i]
    end
    return result
end

---Create a slice of `array` with elements taken from the beginning. Elements are taken until `predicate` returns falsey. The predicate is invoked with three arguments: (value, index, array).
---@param array table @The array to query.
---@param predicate function @The function invoked per iteration. .identity)
---@return table @Returns the slice of `array`.
function lodash.takeWhile(array, predicate)
    predicate = predicate or lodash.identity
    local result = {}
    for i = 1, #array do
        if predicate(array[i]) then
            result[i] = array[i]
        else
            break
        end
    end
    return result
end

---Creates an array of unique values, in order, from all given arrays using [`SameValueZero`](http://ecma-international.org/ecma-262/7.0/#sec-samevaluezero) for equality comparisons.
---@param ... table @The arrays to inspect.
---@return table @Returns the new array of combined values.
function lodash.union(...)
    local result = {}
    local args = {...}
    for i = 1, #args do
        for j = 1, #args[i] do
            if not lodash.includes(result, args[i][j]) then
                result[#result + 1] = args[i][j]
            end
        end
    end
    return result
end

---This method is like `_.union` except that it accepts `iteratee` which is invoked for each element of each `arrays` to generate the criterion by which uniqueness is computed.
---@param iteratee function @The iteratee invoked per element. .identity)
---@param ... table @The arrays to inspect.
---@return table @Returns the new array of combined values.
function lodash.unionBy(iteratee, ...)
    local result = {}
    local args = {...}
    for i = 1, #args do
        for j = 1, #args[i] do
            local value = iteratee(args[i][j])
            if not lodash.includes(result, value) then
                result[#result + 1] = value
            end
        end
    end
    return result
end

---This method is like `_.union` except that it accepts `comparator` which is invoked to compare elements of `arrays`. Right values are chosen from the first array in which the value occurs. The comparator is invoked with two arguments: *(arrVal, othVal)*.
---@param comparator function @The comparator invoked per element.
---@param ... table @The arrays to inspect.
---@return table @Returns the new array of combined values.
function lodash.unionWith(comparator, ...)
    local result = {}
    local args = {...}
    for i = 1, #args do
        for j = 1, #args[i] do
            local value = args[i][j]
            if not lodash.includesWith(result, value, comparator) then
                result[#result + 1] = value
            end
        end
    end
    return result
end

---Create a duplicate-free version of an array, using [`SameValueZero`](http://ecma-international.org/ecma-262/7.0/#sec-samevaluezero) for equality comparisons, in which only the first occurrence of each element is kept. The order of result values is determined by the order they occur in the array.
---@param array table @The array to inspect.
---@return table @Returns the new duplicate free array.
function lodash.uniq(array)
    local result = {}
    for i = 1, #array do
        if not lodash.includes(result, array[i]) then
            result[#result + 1] = array[i]
        end
    end
    return result
end

---This method is like `_.uniq` except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which uniqueness is computed. The order of result values is determined by the order they occur in the array. The iteratee is invoked with one argument: (value).
---@param iteratee function @The iteratee invoked per element. .identity)
---@param array table @The array to inspect.
---@return table @Returns the new duplicate free array.
function lodash.uniqBy(iteratee, array)
    iteratee = iteratee or lodash.identity
    local result = {}
    for i = 1, #array do
        local value = iteratee(array[i])
        if not lodash.includes(result, value) then
            result[#result + 1] = value
        end
    end
    return result
end

---This method is like `_.uniq` except that it accepts `comparator` which is invoked to compare elements of `array`. The order of result values is determined by the order they occur in the array.The comparator is invoked with two arguments: (arrVal, othVal).
---@param comparator function @The comparator invoked per element.
---@param array table @The array to inspect.
---@return table @Returns the new duplicate free array.
function lodash.uniqWith(comparator, array)
    local result = {}
    for i = 1, #array do
        local value = array[i]
        if not lodash.includesWith(result, value, comparator) then
            result[#result + 1] = value
        end
    end
    return result
end

---This method is like `_.zip` except that it accepts an array of grouped elements and creates an array regrouping the elements to their pre-zip configuration.
---@param array table @The array of grouped elements to process.
---@return table @Returns the new array of regrouped elements.
function lodash.unzip(array)
    local result = {}
    for i = 1, #array do
        result[i] = array[i]
    end
    return result
end

---This method is like `_.unzip` except that it accepts `iteratee` to specify how regrouped values should be combined. The iteratee is invoked with the elements of each group: (...group).
---@param array table @The array of grouped elements to process.
---@param iteratee function @The function to combine regrouped values. .identity)
---@return table @Returns the new array of regrouped elements.
function lodash.unzipWith(array, iteratee)
    local result = {}
    for i = 1, #array do
        if type(iteratee) == "function" then
            result[i] = iteratee(array[i])
        else
            result[i] = lodash.identity(array[i])
        end
    end
    return result
end

---Create a array excluding all given values using [`SameValueZero`](http://ecma-international.org/ecma-262/7.0/#sec-samevaluezero) for equality comparisons.
---@param array table @The array to inspect.
---@param ... table @The values to exclude.
---@return table @Returns the new array of filtered values.
function lodash.without(array, ...)
    local result = {}
    local args = {...}
    for i = 1, #array do
        if not lodash.includes(args, array[i]) then
            result[#result + 1] = array[i]
        end
    end
    return result
end

--Create a array of grouped elements, the first of which contains the first elements of the given arrays, the second of which contains the second elements of the given arrays, and so on.
---@param ... table @The arrays to process.
---@return table @Returns the new array of grouped elements.
function lodash.zip(...)
    local result = {}
    local args = {...}
    for i = 1, #args do
        result[i] = args[i]
    end
    return result
end

---This method is like `_.fromPairs` except that it accepts two arrays, one of property identifiers and one of corresponding values.
---@param props table @The property identifiers.
---@param values table @The property values.
---@return table @Returns the new table of own enumerable string keyed properties.
function lodash.zipObject(props, values)
    local result = {}
    for i = 1, #props do
        result[props[i]] = values[i]
    end
    return result
end

---This method is like `_.zipObject` except that it supports property paths.
---@param props table @The property identifiers.
---@param values table @The property values.
---@return table @Returns the new table of own enumerable string keyed properties.
function lodash.zipObjectDeep(props, values)
    local result = {}
    for i = 1, #props do
        local value = values[i]
        if type(value) == "table" then
            result[props[i]] = lodash.zipObjectDeep(value)
        else
            result[props[i]] = value
        end
    end
    return result
end

---This method is like `_.zip` except that it accepts `iteratee` to specify how grouped values should be combined. The iteratee is invoked with the elements of each group: (...group).
---@param iteratee function @The function to combine regrouped values. .identity)
---@param ... table @The arrays to process.
---@return table @Returns the new array of grouped elements.
function lodash.zipWith(iteratee, ...)
    local result = {}
    local args = {...}
    for i = 1, #args do
        if type(iteratee) == "function" then
            result[i] = iteratee(args[i])
        else
            result[i] = lodash.identity(args[i])
        end
    end
    return result
end

-- “Collection” Methods

---Create a object composed of keys generated from the results of running each element of `collection` thru `iteratee`. The order of grouped values is determined by the order they occur in `collection`. The corresponding value of each key is an array of elements responsible for generating the key. The iteratee is invoked with one argument: (value).
---@param collection table @The collection to iterate over.
---@param iteratee function @The iteratee to transform keys.
---@return table @Returns the composed aggregate object.
function lodash.countBy(collection, iteratee)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local key = iteratee(value)
        if not lodash.has(result, key) then
            result[key] = {}
        end
        result[key][#result[key] + 1] = value
    end
    return result
end

---Check if `predicate` returns truthy for **all** elements of `collection`. Iteration is stopped once `predicate` returns falsey. The predicate is invoked with three arguments: (value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@return boolean @Returns `true` if all elements pass the predicate check, else `false`.
function lodash.every(collection, predicate)
    for i = 1, #collection do
        if not predicate(collection[i], i, collection) then
            return false
        end
    end
    return true
end

---Iterate over elements of `collection`, returning an array of all elements predicate returns truthy for. The predicate is invoked with three arguments: (value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@return table @Returns the new filtered array.
function lodash.filter(collection, predicate)
    local result = {}
    for i = 1, #collection do
        if predicate(collection[i], i, collection) then
            result[#result + 1] = collection[i]
        end
    end
    return result
end

---Iterate over elements of `collection`, returning the first element predicate returns truthy for. The predicate is invoked with three arguments: (value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@param fromIndex number @The index to search from. Defaults to `1`.
---@return any @Returns the matched element, else `nil`.
function lodash.find(collection, predicate, fromIndex)
    local length = #collection
    if fromIndex == nil then
        fromIndex = 1
    end
    for i = fromIndex, length do
        if predicate(collection[i], i, collection) then
            return collection[i]
        end
    end
end

---This method is like `_.find` except that it iterates over elements of `collection` from right to left.
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@param fromIndex number @The index to search from. Defaults to `#collection`.
---@return any @Returns the matched element, else `nil`.
function lodash.findLast(collection, predicate, fromIndex)
    local length = #collection
    if fromIndex == nil then
        fromIndex = length
    end
    for i = fromIndex, 1, -1 do
        if predicate(collection[i], i, collection) then
            return collection[i]
        end
    end
end

---Create a flattened array of values by running each element in `collection` thru `iteratee` and flattening the mapped results. The iteratee is invoked with three arguments: (value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns the new flattened array.
function lodash.flatMap(collection, iteratee)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local iterateeResult = iteratee(value, i, collection)
        if type(iterateeResult) == "table" then
            for j = 1, #iterateeResult do
                result[#result + 1] = iterateeResult[j]
            end
        else
            result[#result + 1] = iterateeResult
        end
    end
    return result
end

---This method is like `_.flatMap` except that it recursively flattens the mapped results.
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns the new flattened array.
function lodash.flatMapDeep(collection, iteratee)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local iterateeResult = iteratee(value, i, collection)
        if type(iterateeResult) == "table" then
            result = lodash.concat(result, lodash.flatMapDeep(iterateeResult))
        else
            result[#result + 1] = iterateeResult
        end
    end
    return result
end

---This method is like `_.flatMap` except that it recursively flattens the mapped results up to `depth` times.
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@param depth number @The maximum recursion depth.
---@return table @Returns the new flattened array.
function lodash.flatMapDepth(collection, iteratee, depth)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local iterateeResult = iteratee(value, i, collection)
        if type(iterateeResult) == "table" then
            result = lodash.concat(result, lodash.flatMapDepth(iterateeResult, iteratee, depth - 1))
        else
            result[#result + 1] = iterateeResult
        end
    end
    return result
end

---Iterate over elements of `collection`, returning the first element predicate returns truthy for. The predicate is invoked with three arguments: (value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns `collection`.
function lodash.forEach(collection, iteratee)
    for i = 1, #collection do
        iteratee(collection[i], i, collection)
    end
    return collection
end

lodash.each = lodash.forEach

---This method is like `_.forEach` except that it iterates over elements of `collection` from right to left.
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns `collection`.
function lodash.forEachRight(collection, iteratee)
    for i = #collection, 1, -1 do
        iteratee(collection[i], i, collection)
    end
    return collection
end

lodash.eachRight = lodash.forEachRight

---Create an object composed of keys generated from the results of running each element of `collection` thru `iteratee`.  The order of grouped values is determined by the order they occur in `collection`. The corresponding value of each key is an array of elements responsible for generating the key. The iteratee is invoked with one argument: (value).
---@param collection table @The collection to iterate over.
---@param iteratee function @The iteratee to transform keys.
---@return table @Returns the composed aggregate object.
function lodash.groupBy(collection, iteratee)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local key = iteratee(value, i, collection)
        if result[key] == nil then
            result[key] = {}
        end
        result[key][#result[key] + 1] = value
    end
    return result
end

---Check if `values` is in `collection`. If `collection` is a string, it's checked for a substring of `values`. If `collection` is a set, it's checked if `values` is a member of it. If fromIndex is negative, it's used as the offset from the end of `collection`.
---@param collection table @The collection to inspect.
---@param values any @The values to search for.
---@param fromIndex number @The index to search from.
---@return boolean @Returns `true` if `values` is found, else `false`.
function lodash.includes(collection, values, fromIndex)
    if type(collection) == "string" then
        return string.find(collection, values, fromIndex) ~= nil
    end
    if type(collection) == "table" then
        if fromIndex == nil then
            fromIndex = 1
        end
        for i = fromIndex, #collection do
            if collection[i] == values then
                return true
            end
        end
    end
    return false
end

---Invoke the method at `path` of each element in `collection`, returning an array of the results of each invoked method. Any additional arguments are provided to each invoked method. If `path` is a function, it's invoked for, and `self` bound to, each element in `collection`.
---@param collection table @The collection to iterate over.
---@param path string|function @The path of the method to invoke.
---@param ... any @Additional arguments to invoke the method with.
---@return table @Returns the array of results.
function lodash.invokeMap(collection, path, ...)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local method = path
        if type(path) == "string" then
            method = value[path]
        end
        result[i] = method(value, ...)
    end
    return result
end

---Create an object composed of keys generated from the results of running each element of `collection` thru `iteratee`. The order of grouped values is determined by the order they occur in `collection`. The corresponding value of each key is an array of elements responsible for generating the key. The iteratee is invoked with one argument: (value).
---@param collection table @The collection to iterate over.
---@param iteratee function @The iteratee to transform keys.
---@return table @Returns the composed aggregate object.
function lodash.keyBy(collection, iteratee)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local key = iteratee(value, i, collection)
        result[key] = value
    end
    return result
end

---Create an array of values by running each element in `collection` thru `iteratee`. The iteratee is invoked with three arguments:
--- (value, index|key, collection).
---
---Many lodash methods are guarded to work as iteratees for methods like _.every, _.filter, _.map, _.mapValues, _.reject, and _.some.
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns the new mapped array.
function lodash.map(collection, iteratee)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local iterateeResult = iteratee(value, i, collection)
        if type(iterateeResult) == "table" then
            result = lodash.concat(result, lodash.map(iterateeResult, iteratee))
        else
            result[#result + 1] = iterateeResult
        end
    end
    return result
end

---This method is like `_.sortBy` except that it allows specifying the sort orders of the iteratees to sort by. If `orders` is unspecified, all values are sorted in ascending order. Otherwise, specify an order of "desc" for descending or "asc" for ascending sort order of corresponding values.
---@param collection table @The collection to iterate over.
---@param iteratees function
---@param orders table The iteratees to sort by.
---@return table @Returns the new sorted array.
function lodash.orderBy(collection, iteratees, orders)
    local result = {}
    local iteratees = lodash.castArray(iteratees)
    local orders = lodash.castArray(orders)
    for i = 1, #collection do
        local value = collection[i]
        local iterateeResults = {}
        for j = 1, #iteratees do
            local iteratee = iteratees[j]
            local order = orders[j]
            local iterateeResult = iteratee(value, i, collection)
            if type(iterateeResult) == "table" then
                iterateeResult = lodash.map(iterateeResult, iteratee)
            end
            iterateeResults[j] = iterateeResult
        end
        result[i] = {value, iterateeResults}
    end
    table.sort(result, function(a, b)
        for i = 1, #iteratees do
            local iteratee = iteratees[i]
            local order = orders[i]
            local aValue = a[2][i]
            local bValue = b[2][i]
            if type(aValue) == "table" then
                aValue = lodash.map(aValue, iteratee)
            end
            if type(bValue) == "table" then
                bValue = lodash.map(bValue, iteratee)
            end
            if aValue ~= bValue then
                if order == "asc" then
                    return aValue < bValue
                else
                    return aValue > bValue
                end
            end
        end
        return false
    end)
    return lodash.map(result, function(value)
        return value[1]
    end)
end


---Creates an array of elements split into two groups, the first of which contains elements `predicate` returns truthy for, the second of which contains elements `predicate` returns falsey for. The predicate is invoked with one argument: (value).
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@return table @Returns the array of grouped elements.
function lodash.partition(collection, predicate)
    local result = {lodash.filter(collection, predicate), lodash.reject(collection, predicate)}
    return result
end

---Reduce `collection` to a value which is the accumulated result of running each element in `collection` thru `iteratee`, where each successive invocation is supplied the return value of the previous. If `accumulator` is not given, the first element of `collection` is used as the initial `accumulator` value. The iteratee is invoked with four arguments: (accumulator, value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@param accumulator any @The initial value.
---@return any @Returns the accumulated value.
function lodash.reduce(collection, iteratee, accumulator)
    local result = accumulator
    for i = 1, #collection do
        local value = collection[i]
        if result == nil then
            result = value
        else
            result = iteratee(result, value, i, collection)
        end
    end
    return result
end

---This method is like `_.reduce` except that it iterates over elements of `collection` from right to left.
---@param collection table @The collection to iterate over.
---@param iteratee function @The function invoked per iteration.
---@param accumulator any @The initial value.
---@return any @Returns the accumulated value.
function lodash.reduceRight(collection, iteratee, accumulator)
    local result = accumulator
    for i = #collection, 1, -1 do
        local value = collection[i]
        if result == nil then
            result = value
        else
            result = iteratee(result, value, i, collection)
        end
    end
    return result
end

---The opposite of _.filter; this method returns the elements of `collection` that `predicate` does **not** return truthy for.
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@return table @Returns the new filtered array.
function lodash.reject(collection, predicate)
    return lodash.filter(collection, function(value, i, collection)
        return not predicate(value, i, collection)
    end)
end

---Gets a random element from `collection`.
---@param collection table @The collection to sample.
---@return any @Returns the random element.
function lodash.sample(collection)
    return collection[math.random(#collection)]
end

---Gets `n` random elements at unique keys from `collection` up to the size of `collection`.
---@param collection table @The collection to sample.
---@param n number @The number of elements to sample.
---@return table @Returns the random elements.
function lodash.sampleSize(collection, n)
    local result = {}
    local keys = {}
    for i = 1, #collection do
        local key = math.random(#keys + 1)
        keys[key] = i
        result[key] = collection[i]
    end
    return lodash.take(result, n)
end

---Create an array of shuffled values, using a version of the [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher-Yates_shuffle).
---@param collection table @The collection to shuffle.
---@return table @Returns the new shuffled array.
function lodash.shuffle(collection)
    local result = {}
    for i = 1, #collection do
        local j = math.random(i)
        result[i] = result[j]
        result[j] = collection[i]
    end
    return result
end

---Gets the size of `collection` by returning its length for array-like values or the number of own enumerable string keyed properties for objects.
---@param collection table @The collection to inspect.
---@return number @Returns the collection size.
function lodash.size(collection)
    if type(collection) == "table" then
        return #collection
    else
        return lodash.keys(collection).length
    end
end

---Checks if `predicate` returns truthy for **any** element of `collection`. Iteration is stopped once `predicate` returns truthy. The predicate is invoked with three arguments: (value, index|key, collection).
---@param collection table @The collection to iterate over.
---@param predicate function @The function invoked per iteration.
---@return boolean @Returns `true` if any element passes the predicate check, else `false`.
function lodash.some(collection, predicate)
    for i = 1, #collection do
        if predicate(collection[i], i, collection) then
            return true
        end
    end
    return false
end

---Creates an array of elements, sorted in ascending order by the results of running each element in a collection thru each iteratee. This method performs a stable sort, that is, it preserves the original sort order of equal elements. The iteratees are invoked with one argument: (value).
---@param collection table @The collection to iterate over.
---@param iteratees function @The iteratees to sort by, specified individually or in arrays.
---@return table @Returns the new sorted array.
function lodash.sortBy(collection, iteratees)
    local result = {}
    for i = 1, #collection do
        local value = collection[i]
        local resultValue = {}
        for j = 1, #iteratees do
            local resultValueItem = iteratees(value)
            resultValue[j] = resultValueItem
        end
        result[i] = {value, resultValue}
    end
    table.sort(result, function(a, b)
        for i = 1, #iteratees do
            local iteratee = iteratees[i]
            local aValue = a[2][i]
            local bValue = b[2][i]
            if aValue ~= bValue then
                if iteratee == "asc" then
                    return aValue < bValue
                else
                    return aValue > bValue
                end
            end
        end
        return false
    end)
    return lodash.map(result, function(value)
        return value[1]
    end)
end

-- “Date” Methods

---Gets the number of milliseconds that have elapsed since the Unix epoch (1 January 1970 00:00:00 UTC).
---@return number @Returns the timestamp.
function lodash.now()
    return os.time()
end

--- "Math" Methods

---Calculate the power of 
---@param n number @The base.
---@param power number @The exponent.
---@return number @Returns the result of `x` raised to the power of `y`.
function lodash.pow(n, power)
    local result = n
    for _ = 1, power do
        result = result * power
    end
    return result
end

---Adds two numbers.
---@param augend number @The first number to add.
---@param addend number @The second number to add.
---@return number @Returns the sum.
function lodash.add(augend, addend)
    return augend + addend
end

---Computes n rounded up to precision.
---@param n number @The number to round up.
---@param precision number @The precision to round up to.
---@return number @Returns the rounded up number.
function lodash.ceil(n, precision)
    return math.ceil(n * lodash.pow(10, precision)) / lodash.pow(10, precision)
end

---Divides two numbers.
---@param dividend number @The first number in a division.
---@param divisor number @The second number in a division.
---@return number @Returns the quotient.
function lodash.divide(dividend, divisor)
    return dividend / divisor
end

---Computes `number` rounded down to `precision`.
---@param number number @The number to round down.
---@param precision number @The precision to round down to.
---@return number @Returns the rounded down number.
function lodash.floor(number, precision)
    return math.floor(number * lodash.pow(10, precision)) / lodash.pow(10, precision)
end

---Computes the maximum value of `array`. If `array` is empty or falsey, returns `nil`.
---@param collection table @The array to iterate over.
---@return any @Returns the maximum value.
function lodash.max(collection)
    local result = nil
    for i = 1, #collection do
        local value = collection[i]
        if result == nil or value > result then
            result = value
        end
    end
    return result
end

---This method is like `max` except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which the value is ranked. The iteratee is invoked with one argument: (value).
---@param array table @The array to iterate over.
---@param iteratee function @The iteratee invoked per element.
---@return any @Returns the maximum value.
function lodash.maxBy(array, iteratee)
    local result = nil
    for i = 1, #array do
        local value = array[i]
        local computed = iteratee(value)
        if result == nil or computed > result then
            result = computed
        end
    end
    return result
end

---Computes the mean of the values in `array`.
---@param array table @The array to iterate over.
---@return number @Returns the mean.
function lodash.mean(array)
    local sum = 0
    for i = 1, #array do
        sum = sum + array[i]
    end
    return sum / #array
end

---This method is like `mean` except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which the value is ranked. The iteratee is invoked with one argument: (value).
---@param array table @The array to iterate over.
---@param iteratee function @The iteratee invoked per element.
---@return number @Returns the mean.
function lodash.meanBy(array, iteratee)
    local sum = 0
    for i = 1, #array do
        sum = sum + iteratee(array[i])
    end
    return sum / #array
end

---Computes the minimum value of `array`. If `array` is empty or falsey, returns `nil`.
---@param array table @The array to iterate over.
---@return any @Returns the minimum value.
function lodash.min(array)
    local result = nil
    for i = 1, #array do
        local value = array[i]
        if result == nil or value < result then
            result = value
        end
    end
    return result
end

---This method is like `min` except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which the value is ranked. The iteratee is invoked with one argument: (value).
---@param array table @The array to iterate over.
---@param iteratee function @The iteratee invoked per element.
---@return any @Returns the minimum value.
function lodash.minBy(array, iteratee)
    local result = nil
    for i = 1, #array do
        local value = array[i]
        local computed = iteratee(value)
        if result == nil or computed < result then
            result = computed
        end
    end
    return result
end

---Multiplies two numbers.
---@param multiplier number @The first number to multiply.
---@param multiplicand number @The second number to multiply.
---@return number @Returns the product.
function lodash.multiply(multiplier, multiplicand)
    return multiplier * multiplicand
end

---Computes the sum of the values in `array`.
---@param array table @The array to iterate over.
---@return number @Returns the sum.
function lodash.sum(array)
    local sum = 0
    for i = 1, #array do
        sum = sum + array[i]
    end
    return sum
end


---This method is like `sum` except that it accepts `iteratee` which is invoked for each element in `array` to generate the criterion by which the value is ranked. The iteratee is invoked with one argument: (value).
---@param array table @The array to iterate over.
---@param iteratee function @The iteratee invoked per element.
---@return number @Returns the sum.
function lodash.sumBy(array, iteratee)
    local sum = 0
    for i = 1, #array do
        sum = sum + iteratee(array[i])
    end
    return sum
end

---Computes the `number` rounded to `precision`.
---@param number number @The number to round.
---@param precision number @The precision to round to. Defaults to 0.
---@return number @Returns the rounded number.
function lodash.round(number, precision)
    precision = precision or 0
    return math.floor(number * lodash.pow(10, precision) + 0.5) / lodash.pow(10, precision)
end

---Substract two numbers.
---@param minuend number @The first number to substract.
---@param subtrahend number @The second number to substract.
---@return number @Returns the difference.
function lodash.subtract(minuend, subtrahend)
    return minuend - subtrahend
end

-- "Number" methods

---Clams `number` within the inclusive `lower` and `upper` bounds.
---@param number number @The number to clamp.
---@param lower number @The lower bound.
---@param upper number @The upper bound.
---@return number @Returns the clamped number.
function lodash.clamp(number, lower, upper)
    return math.min(math.max(number, lower), upper)
end

---Checks if `n` is between `start` and up to, but not including, `end`. If `end` is not specified, it's set to `start` with `start` then set to `0`. If `start` is greater than `end` the params are swapped to support negative ranges.
---@param n number @The number to check.
---@param start number @The start of the range.
---@param rangeEnd number @The end of the range.
---@return boolean @Returns `true` if `n` is in the range, else `false`.
function lodash.inRange(n, start, rangeEnd)
    if rangeEnd == nil then
        rangeEnd = start
        start = 0
    end
    if start > rangeEnd then
        start, rangeEnd = rangeEnd, start
    end
    return start <= n and n < rangeEnd
end

---Produces a random number between the inclusive `lower` and `upper` bounds. If only one argument is provided a number between `0` and the given number is returned. If `floating` is `true`, or either `lower` or `upper` are floats, a floating-point number is returned instead of an integer.
---@param lower number @The lower bound.
---@param upper number @The upper bound.
---@param floating boolean @Specify returning a floating-point number.
---@return number @Returns the random number.
function lodash.random(lower, upper, floating)
    if upper == nil then
        upper = lower
        lower = 0
    end
    if floating then
        return lower + math.random() * (upper - lower)
    end
    return math.floor(lower + math.random() * (upper - lower + 1))
end


-- "Object" methods

---Assings own enumerable string keyed properties of `source` to the destination object. Source objects are applied from left to right. Subsequent sources overwrite property assignments of previous sources.
---@param object table @The destination object.
---@param ... table @The source objects.
---@return table @Returns `object`.
function lodash.assign(object, ...)
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source ~= nil then
            for key, value in pairs(source) do
                object[key] = value
            end
        end
    end
    return object
end

---This method is like `assign` except that it iterates over own and inherited enumerable string keyed properties of `source` and assigns them to own string keyed properties of `object`.
---@param object table @The destination object.
---@param ... table @The source objects.
---@return table @Returns `object`.
function lodash.assignIn(object, ...)
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source ~= nil then
            for key, value in pairs(source) do
                object[key] = value
            end
        end
    end
    return object
end
lodash.extend = lodash.assignIn

---This method is like `assignIn` except that it accepts `customizer` which is invoked to produce the assigned values. If `customizer` returns `nil`, assignment is handled by the method instead. The `customizer` is invoked with five arguments: (objValue, srcValue, key, object, source).
---@param object table @The destination object.
---@param customizer function @The function to customize assigned values.
---@param ... table @The source objects.
---@return table @Returns `object`.
function lodash.assignInWith(object, customizer, ...)
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source ~= nil then
            for key, value in pairs(source) do
                local objValue = object[key]
                local newValue = customizer(objValue, value, key, object, source)
                if newValue ~= nil then
                    object[key] = newValue
                end
            end
        end
    end
    return object
end
lodash.extendWith = lodash.assignInWith

---This method is like `_.assign` except that it accepts `customizer` which is invoked to produce the assigned values. If `customizer` returns `undefined`, assignment is handled by the method instead. The `customizer` is invoked with five arguments: (objValue, srcValue, key, object, source).
---@param object table @The destination object.
---@param customizer function @The function to customize assigned values.
---@param ... table @The source objects.
---@return table @Returns `object`.
function lodash.assignWith(object, customizer, ...)
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source ~= nil then
            for key, value in pairs(source) do
                local objValue = object[key]
                local newValue = customizer(objValue, value, key, object, source)
                if newValue ~= nil then
                    object[key] = newValue
                end
            end
        end
    end
    return object
end

---Creates an array of values corresponding to `paths` of `object`.
---@param object table @The object to iterate over.
---@param ... string @The property paths to pick.
---@return table @Returns the picked values.
function lodash.at(object, ...)
    local result = {}
    for i = 1, select("#", ...) do
        local path = select(i, ...)
        local value = lodash.get(object, path)
        if value ~= nil then
            table.insert(result, value)
        end
    end
    return result
end

---Creates an object that inherits from the `prototype` object. If a `properties` object is given, its own enumerable string keyed properties are assigned to the created object.
---@param prototype table @The object to inherit from.
---@param properties table @The properties to assign to the object.
---@return table @Returns the new object.
function lodash.create(prototype, properties)
    local result = {}
    setmetatable(result, { __index = prototype })
    if properties then
        lodash.assign(result, properties)
    end
    return result
end

---Assigns own and inherited enumerable string keyed properties of source objects to the destination object for all destination properties that resolve to `undefined`. Source objects are applied from left to right. Once a property is set, additional values of the same property are ignored.
---@param object table @The destination object.
---@param ... table @The source objects.
---@return table @Returns `object`.
function lodash.defaults(object, ...)
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source ~= nil then
            for key, value in pairs(source) do
                if object[key] == nil then
                    object[key] = value
                end
            end
        end
    end
    return object
end

---This method is like `_.defaults` except that it recursively assigns default properties.
---@param object table @The destination object.
---@param ... table @The source objects.
---@return table @Returns `object`.
function lodash.defaultsDeep(object, ...)
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source ~= nil then
            for key, value in pairs(source) do
                if lodash.isNil(object[key]) then
                    object[key] = lodash.cloneDeep(value)
                end
            end
        end
    end
    return object
end

---This method is like `_.find` except that it returns the key of the first element `predicate` returns truthy for instead of the element itself.
---@param object table @The table to search.
---@param predicate function @The function invoked per iteration.
---@return any @Returns the key of the matched element, else `nil`.
function lodash.findKey(object, predicate)
    for key, value in pairs(object) do
        if predicate(value, key, object) then
            return key
        end
    end
end

---This method is like `_.findKey` except that it iterates over elements of a collection in the opposite order.
---@param object table @The table to search.
---@param predicate function @The function invoked per iteration.
---@return any @Returns the key of the matched element, else `nil`.
function lodash.findLastKey(object, predicate)
    local result
    for key, value in pairs(object) do
        if predicate(value, key, object) then
            result = key
        end
    end
    return result
end

---Iterates over own and inherited enumerable string keyed properties of an object invoking `iteratee` for each property. The iteratee is invoked with three arguments: (value, key, object). Iteratee functions may exit iteration early by explicitly returning `false`.
---@param object table @The object to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns `object`.
function lodash.forIn(object, iteratee)
    for key, value in pairs(object) do
        iteratee(value, key, object)
    end
    return object
end

---This method is like `_.forIn` except that it iterates over properties of `object` in the opposite order.
---@param object table @The object to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns `object`.
function lodash.forInRight(object, iteratee)
    local keys = lodash.keys(object)
    for i = #keys, 1, -1 do
        iteratee(object[keys[i]], keys[i], object)
    end
    return object
end

---Create an array of function property names from own enumerable properties of `object`.
---@param object table @The object to inspect.
---@return table @Returns the function names.
function lodash.functions(object)
    local result = {}
    for key in pairs(object) do
        if lodash.isFunction(object[key]) then
            table.insert(result, key)
        end
    end
    return result
end

---Create an array of function property names from own and inherited enumerable properties of `object`.
---@param object table @The object to inspect.
---@return table @Returns the function names.
function lodash.functionsIn(object)
    local result = {}
    for key, value in pairs(object) do
        if lodash.isFunction(value) then
            table.insert(result, key)
        end
    end
    return result
end

---Gets the value at `path` of `object`. If the resolved value is `nil`, the `defaultValue` is returned in its place.
---@param object table @The object to query.
---@param path string|table @The path of the property to get.
---@param defaultValue any @The value returned for `undefined` resolved values.
---@return any @Returns the resolved value.
function lodash.get(object, path, defaultValue)
    local result = object
    if path ~= nil then
        local pathType = type(path)
        if pathType == "string" then
            path = lodash.split(path, ".")
        elseif pathType ~= "table" then
            return defaultValue
        end
        for i = 1, #path do
            local key = path[i]
            if result ~= nil then
                result = result[key]
            end
        end
    end
    if result == nil then
        result = defaultValue
    end
    return result
end

---Checks if `path` is a direct property of `object`.
---@param object table @The object to query.
---@param path string|table @The path to check.
---@return boolean @Returns `true` if `path` exists, else `false`.
function lodash.has(object, path)
    local result = true
    if path ~= nil then
        local pathType = type(path)
        if pathType == "string" then
            path = lodash.split(path, ".")
        elseif pathType ~= "table" then
            return false
        end
        for i = 1, #path do
            local key = path[i]
            if result ~= nil then
                result = key and result[key] ~= nil
            end
        end
    end
    return result
end

---Check if `path` is a direct or inherited property of `object`.
---@param object table @The object to query.
---@param path string|table @The path to check.
---@return boolean @Returns `true` if `path` exists, else `false`.
function lodash.hasIn(object, path)
    local result = true
    if path ~= nil then
        local pathType = type(path)
        if pathType == "string" then
            path = lodash.split(path, ".")
        elseif pathType ~= "table" then
            return false
        end
        for i = 1, #path do
            local key = path[i]
            if result ~= nil then
                result = key and result[key] ~= nil
            end
        end
    end
    return result
end

---Creates an object composed of the inverted keys and values of `object`. If `object` contains duplicate values, subsequent values overwrite property assignments of previous values.
---@param object table @The object to invert.
---@return table @Returns the new inverted object.
function lodash.invert(object)
    local result = {}
    for key, value in pairs(object) do
        result[value] = key
    end
    return result
end

---This method is like `_.invert` except that the inverted object is generated from the results of running each element of `object` thru `iteratee`. The corresponding inverted value of each inverted key is an array of keys responsible for generating the inverted value. The iteratee is invoked with one argument: (value).
---@param object table @The object to invert.
---@param iteratee function @The iteratee invoked per element.
---@return table @Returns the new inverted object.
function lodash.invertBy(object, iteratee)
    local result = {}
    for key, value in pairs(object) do
        local resultKey = iteratee(value)
        result[resultKey] = result[resultKey] or {}
        table.insert(result[resultKey], key)
    end
    return result
end

---Invoke the method at `path` of each element in `object`.
---@param object table @The object to query.
---@param path string|table @The path of the method to invoke.
---@param ... any @The arguments to invoke the method with.
---@return any @Returns the result of the invoked method.
function lodash.invoke(object, path, ...)
    local result = {}
    for key, value in pairs(object) do
        local resultValue = lodash.get(value, path, ...)
        -- Invoke the method with the correct `this` binding
        if lodash.isFunction(resultValue) then
            resultValue = resultValue(value, ...)
            table.insert(result, resultValue)
        end
    end
    return result
end

---Creates an array of the own enumerable property names of `object`.
---@param object table @The object to query.
---@return table @Returns the array of property names.
function lodash.keys(object)
    local result = {}
    for key in pairs(object) do
        table.insert(result, key)
    end
    return result
end

---Creates an array of the own and inherited enumerable property names of `object`.
---
---**Note:** Non-object values are coerced to objects.
---@param object table @The object to query.
---@return table @Returns the array of property names.
function lodash.keysIn(object)
    local result = {}
    for key, value in pairs(object) do
        table.insert(result, key)
    end
    return result
end

---The opposite of `_.mapValues`; this method creates an object with the same values as `object` and keys generated by running each own enumerable string keyed property of `object` thru `iteratee`. The iteratee is invoked with three arguments: (value, key, object).
---@param object table @The object to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns the new mapped object.
function lodash.mapKeys(object, iteratee)
    local result = {}
    for key, value in pairs(object) do
        local resultKey = iteratee(value, key, object)
        result[resultKey] = value
    end
    return result
end

---Creates an object with the same keys as `object` and values generated by running each own enumerable string keyed property of `object` thru `iteratee`. The iteratee is invoked with three arguments: (value, key, object).
---@param object table @The object to iterate over.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns the new mapped object.
function lodash.mapValues(object, iteratee)
    local result = {}
    for key, value in pairs(object) do
        local resultValue = iteratee(value, key, object)
        result[key] = resultValue
    end
    return result
end

---This method is like `_.assign` except that it recursively merges own and inherited enumerable string keyed properties of source objects into the destination object. Source properties that resolve to `undefined` are skipped if a destination value exists. Array and plain object properties are merged recursively. Other objects and value types are overridden by assignment.
---@param object table @The destination object.
---@param ... table @... The source objects.
---@return table @Returns the destination object.
function lodash.merge(object, ...)
    local others = {...}
    for i = 1, #others do
        local other = others[i]
        if other ~= nil then
            for key, value in pairs(other) do
                object[key] = value
            end
        end
    end
    return object
end

---This method is like `_.merge` except that it accepts `customizer` which is invoked to produce the merged values of the destination and source properties. If `customizer` returns `undefined`, merging is handled by the method instead. The `customizer` is invoked with six arguments: (objValue, srcValue, key, object, source, stack).
---@param object table @The destination object.
---@param customizer function @The function to customize assigned values.
---@param ...table @... The source objects.
---@return table @Returns the destination object.
function lodash.mergeWith(object, customizer, ...)
    local others = {...}
    for i = 1, #others do
        local other = others[i]
        if other ~= nil then
            for key, value in pairs(other) do
                local result = customizer(object[key], value, key, object, other, {})
                if result ~= nil then
                    object[key] = result
                end
            end
        end
    end
    return object
end

---The opposite of `_.pick`; this method creates an object composed of the own and inherited enumerable string keyed properties of `object` that are not omitted.
---
---**Note:** This method is considerably slower than `_.pick`.
---@param object table @The source object.
---@param ... string|table @... The property paths to omit.
---@return table @Returns the new object.
function lodash.omit(object, ...)
    local others = {...}
    local result = {}
    for key, value in pairs(object) do
        local shouldOmit = false
        for i = 1, #others do
            local other = others[i]
            if lodash.isEqual(other, key) then
                shouldOmit = true
                break
            end
        end
        if not shouldOmit then
            result[key] = value
        end
    end
    return result
end

---The opposite of `_.pickBy`; this method creates an object composed of the own and inherited enumerable string keyed properties of `object` that `predicate` doesn't return truthy for. The predicate is invoked with two arguments: (value, key).
---@param object table @The source object.
---@param predicate function @The function invoked per property.
---@return table @Returns the new object.
function lodash.omitBy(object, predicate)
    local result = {}
    for key, value in pairs(object) do
        if not predicate(value, key) then
            result[key] = value
        end
    end
    return result
end

---Create an object composed of the picked `object` properties.
---@param object table @The source object.
---@param ... string|table @... The property paths to pick.
---@return table @Returns the new object.
function lodash.pick(object, ...)
    local others = {...}
    others = lodash.flatten(others)
    local result = {}
    for i = 1, #others do
        local other = others[i]
        if object[other] ~= nil then
            result[other] = object[other]
        end
    end
    return result
end

---Create an object composed of the `object` properties `predicate` returns truthy for. The predicate is invoked with two arguments: (value, key).
---@param object table @The source object.
---@param predicate function @The function invoked per property.
---@return table @Returns the new object.
function lodash.pickBy(object, predicate)
    local result = {}
    for key, value in pairs(object) do
        if predicate(value, key) then
            result[key] = value
        end
    end
    return result
end

---This method is like `_.get` except that if the resolved value is a function it's invoked with the `this` binding of `object` and its result is returned.
---@param object table @The object to query.
---@param path string|table @The path of the property to resolve.
---@param defaultValue any @The default value.
---@return any @Returns the resolved value.
function lodash.result(object, path, defaultValue)
    local value = lodash.get(object, path)
    if lodash.isFunction(value) then
        return value(object)
    else
        return value or defaultValue
    end
end

---Sets the value at `path` of `object`. If a portion of `path` doesn't exist it's created. Arrays are created for missing index properties while objects are created for all other missing properties. Use `_.setWith` to customize `path` creation.
---@param object table @The object to modify.
---@param path string|table @The path of the property to set.
---@param value any @The value to set.
---@return table @Returns `object`.
function lodash.set(object, path, value)
    local pathArray = lodash.toPath(path)
    local length = #pathArray
    local index = 1
    while index <= length do
        local key = pathArray[index]
        if index == length then
            object[key] = value
        else
            local value = object[key]
            if value == nil then
                local isIndex = lodash.isInteger(key)
                if isIndex then
                    value = {}
                else
                    value = {}
                end
                object[key] = value
            end
            object = value
        end
        index = index + 1
    end
    return object
end

--This method is like `_.set` except that it accepts `customizer` which is invoked to produce the objects of `path`. If `customizer` returns `undefined` path creation is handled by the method instead. The `customizer` is invoked with three arguments: (nsValue, key, nsObject).
---@param object table @The object to modify.
---@param path string|table @The path of the property to set.
---@param value any @The value to set.
---@param customizer function @The function to customize assigned values.
---@return table @Returns `object`.
function lodash.setWith(object, path, value, customizer)
    local pathArray = lodash.toPath(path)
    local length = #pathArray
    local index = 1
    while index <= length do
        local key = pathArray[index]
        if index == length then
            object[key] = customizer(object[key], key, object) or value
        else
            local value = object[key]
            if value == nil then
                local isIndex = lodash.isInteger(key)
                if isIndex then
                    value = {}
                else
                    value = {}
                end
                object[key] = value
            end
            object = value
        end
        index = index + 1
    end
    return object
end

---Creates an array of own enumerable string keyed-value pairs for `object` which can be consumed by `_.fromPairs`. If `object` is a map or set, its entries are returned.
---@param object table @The object to query.
---@return table @Returns the key-value pairs.
function lodash.toPairs(object)
    local result = {}
    for key, value in pairs(object) do
        result[#result + 1] = {key, value}
    end
    return result
end
lodash.entries = lodash.toPairs

---Create an array of own enumerable keyed-value pairs for `object` which can be consumed by `_.fromPairs`. If  `object` is a map or set, its entries are returned.
---@param object table @The object to query.
---@return table @Returns the key-value pairs.
function lodash.toPairsIn(object)
    local result = {}
    for key, value in pairs(object) do
        result[#result + 1] = {key, value}
    end
    return result
end
lodash.entriesIn = lodash.toPairsIn

--An alternative to `_.reduce`; this method transforms `object` to a new `accumulator` object which is the result of running each of its own enumerable string keyed properties thru `iteratee`, with each invocation potentially mutating the `accumulator` object. If `accumulator` is not provided, a new object with the same `[[Prototype]]` will be used. The iteratee is invoked with four arguments: (accumulator, value, key, object). Iteratee functions may exit iteration early by explicitly returning `false`.
---@param object table @The object to iterate over.
---@param iteratee function @The function invoked per iteration.
---@param accumulator any @The custom accumulator value.
---@return any @Returns the accumulated value.
function lodash.transform(object, iteratee, accumulator)
    if accumulator == nil then
        accumulator = {}
    end
    for key, value in pairs(object) do
        accumulator = iteratee(accumulator, value, key, object)
    end
    return accumulator
end

---Removes the property at `path` of `object`.
---@param object table @The object to modify.
---@param path string|table @The path of the property to unset.
---@return boolean, table  @Returns `true` if the property is deleted, else `false` and returns the deleted property.
function lodash.unset(object, path)
    local pathArray = lodash.toPath(path)
    local length = #pathArray
    local index = 1
    while index <= length do
        local key = pathArray[index]
        if index == length then
            if object[key] ~= nil then
                object[key] = nil
                return true, object
            end
        else
            local value = object[key]
            if value == nil then
                return false, object
            end
            object = value
        end
        index = index + 1
    end
    return false, object
end

---This method is like `_.set` except that accepts `updater` to produce the objects of `path`. Use `_.updateWith` to customize `path` creation. The `updater` is invoked with one argument: (value).
---@param object table @The object to modify.
---@param path string|table @The path of the property to set.
---@param updater function @The function to produce the value for `path`.
---@return table @Returns `object`.
function lodash.update(object, path, updater)
    local pathArray = lodash.toPath(path)
    local length = #pathArray
    local index = 1
    while index <= length do
        local key = pathArray[index]
        if index == length then
            object[key] = updater(object[key])
        else
            local value = object[key]
            if value == nil then
                local isIndex = lodash.isInteger(key)
                if isIndex then
                    value = {}
                else
                    value = {}
                end
                object[key] = value
            end
            object = value
        end
        index = index + 1
    end
    return object
end

---This method is like `_.update` except that it accepts `customizer` which is invoked to produce the objects of `path`. If `customizer` returns `undefined` path creation is handled by the method instead. The `customizer` is invoked with three arguments: (nsValue, key, nsObject).
---@param object table @The object to modify.
---@param path string|table @The path of the property to set.
---@param updater function @The function to produce the value for `path`.
---@param customizer function @The function to customize assigned values.
---@return table @Returns `object`.
function lodash.updateWith(object, path, updater, customizer)
    local pathArray = lodash.toPath(path)
    local length = #pathArray
    local index = 1
    while index <= length do
        local key = pathArray[index]
        if index == length then
            object[key] = customizer(object[key], key, object) or updater(object[key])
        else
            local value = object[key]
            if value == nil then
                local isIndex = lodash.isInteger(key)
                if isIndex then
                    value = {}
                else
                    value = {}
                end
                object[key] = value
            end
            object = value
        end
        index = index + 1
    end
    return object
end

---Creates an array of the own enumerable string keyed property values of `object`.
---
---**Note:** Non-object values are coerced to objects.
---@param object table @The object to query.
---@return table @Returns the array of property values.
function lodash.values(object)
    local result = {}
    for key, value in pairs(object) do
        result[#result + 1] = value
    end
    return result
end

---Creates an array of the own and inherited enumerable string keyed property values of `object`.
---
---**Note:** Non-object values are coerced to objects.
---@param object table @The object to query.
---@return table @Returns the array of property values.
function lodash.valuesIn(object)
    local result = {}
    for key, value in pairs(object) do
        result[#result + 1] = value
    end
    return result
end

-- "Seq" methods

---Create a `lodash` wrapper instance that wrap `value` with explicit method `chain`. The result of `chain` is then passed to the `lodash` constructor to create the wrapped value.
---@param value any @The value to wrap.
---@return table @Returns the new `lodash` wrapper instance.
---@example 
---```lua
---local users = {
---    { users = 'barney', age = 36 },
---    { users = 'fred', age = 40 }
---    { users = 'pebbles', age = 1 }
---}
---
---local youngest = _.chain(users)
---    :sortBy('age')
---    :map(function(o) return o.users end)
---    :head()
---    :value()
---
---print(youngest)
---```
function lodash.chain(value)
    local unchainableFuncs = lodash.split("add, attempt, camelCase, capitalize, ceil, clamp, clone, cloneDeep, cloneDeepWith, cloneWith, conformsTo, deburr, defaultTo, divide, each, eachRight, endsWith, eq, escape, escapeRegExp, every, find, findIndex, findKey, findLast, findLastIndex, findLastKey, first, floor, forEach, forEachRight, forIn, forInRight, forOwn, forOwnRight, get, gt, gte, has, hasIn, head, identity, includes, indexOf, inRange, invoke, isArguments, isArray, isArrayBuffer, isArrayLike, isArrayLikeObject, isBoolean, isBuffer, isDate, isElement, isEmpty, isEqual, isEqualWith, isError, isFinite, isFunction, isInteger, isLength, isMap, isMatch, isMatchWith, isNaN, isNative, isNil, isNull, isNumber, isObject, isObjectLike, isPlainObject, isRegExp, isSafeInteger, isSet, isString, isUndefined, isTypedArray, isWeakMap, isWeakSet, join, kebabCase, last, lastIndexOf, lowerCase, lowerFirst, lt, lte, max, maxBy, mean, meanBy, min, minBy, multiply, noConflict, noop, now, nth, pad, padEnd, padStart, parseInt, pop, random, reduce, reduceRight, repeat, result, round, runInContext, sample, shift, size, snakeCase, some, sortedIndex, sortedIndexBy, sortedLastIndex, sortedLastIndexBy, startCase, startsWith, stubArray, stubFalse, stubObject, stubString, stubTrue, subtract, sum, sumBy, template, times, toFinite, toInteger, toJSON, toLength, toLower, toNumber, toSafeInteger, toString, toUpper, trim, trimEnd, trimStart, truncate, unescape, uniqueId, upperCase, upperFirst, value, words", ",")


    local t = {
        _value = value;
        value = function (self)
            return self._value
        end
    }
    -- merge methods in t
    for k, v in next, lodash do
        if type(v) == "function" and not lodash.includes(unchainableFuncs, k) then
            t[k] = function (self, ...)
                -- throw a error if function is called without :
                if not self._value then
                    error("chain value is nil, you must call with a `:'")
                end

                local result = v(self._value, ...)
                if result ~= self._value then
                    self._value = result
                end
                return self
            end
        end
    end
    -- transfer all the lua standard string methods to t
    for k, v in next, string do
        if type(v) == "function" then
            t[k] = function (self, ...)
                if not self._value then
                    error("chain value is nil, you must call with a `:'")
                end
                local result = v(self._value, ...)
                if result ~= self._value then
                    self._value = result
                end
                return self
            end
        end
    end
    -- transfer all the lua standard table methods to t
    for k, v in next, table do
        if type(v) == "function" then
            t[k] = function (self, ...)
                if not self._value then
                    error("chain value is nil, you must call with a `:'")
                end

                local result = v(self._value, ...)
                if result ~= self._value then
                    self._value = result
                end
                return self
            end
        end
    end
    return t
end

lodash = setmetatable(lodash, {
    --- Creates a `lodash` wrapper instance with explicit method chain sequences enabled.
    ---@param value any @The value to wrap.
    ---@return table @Returns the new `lodash` wrapper instance.
    ---@meta __call @See lodash.chain.
    __call = function (self, value)
        return lodash.chain(value)
    end
})

---This method invoke `interceptor` function with one argument `value`. The purpose of this method is to "tap into" a method chain in order to perform operations on intermediate results within the chain.
---@param value any @The value to provide to `interceptor`.
---@param interceptor function @The function to invoke.
---@return any @Returns `value`.
---@example
---```lua
---_({1, 2, 3})
---    :tap(function(array)
---        array[3] = nil
---    end)
---    :reverse()
---    :value()
---    -- => {1, 2}
---```
function lodash.tap(value, interceptor)
    interceptor(value)
    return value
end

---This method is like `_.tap` except that it returns the result of `interceptor` instead of the original `value`. The purpose of this method is to "pass thru" values replacing intermediate results in a method chain.
---@param value any @The value to provide to `interceptor`.
---@param interceptor function @The function to invoke.
---@return any @Returns the result of `interceptor`.
---@example
---```lua
---_({'  abc  '})
---    :chain()
---    :trim()
---    :thru(function(value)
---        return _.map(value, _.trim)
---    end)
---    :value()
---    -- => {'abc'}
---```
function lodash.thru(value, interceptor)
    return interceptor(value)
end

-- "Strings" methods

---Converts `str` to [camel case](https://en.wikipedia.org/wiki/CamelCase).
---@param str string @The string to convert.
---@return string @Returns the camel cased string.
function lodash.camelCase(str)
    return lodash.trim(str):gsub("%s", " "):gsub("%s(%w)", function (s)
        return s:upper()
    end):gsub("(%w)(%w+)", function (s1, s2)
        return s1:upper() .. s2
    end)
end

---Converts the first character of `str` to upper case and the remaining to lower case.
---@param str string @The string to capitalize.
---@return string @Returns the capitalized string.
function lodash.capitalize(str)
    return (str:sub(1, 1):upper() .. str:sub(2):lower())
end

---Deburrs `str` by converting [Latin-1 Supplement](https://en.wikipedia.org/wiki/Latin-1_Supplement_(Unicode_block)#Character_table) and [Latin Extended-A](https://en.wikipedia.org/wiki/Latin_Extended-A) to basic Latin letters, removing [combining diacritical marks](https://en.wikipedia.org/wiki/Combining_Diacritical_Marks) and [combining diacritical marks for symbols](https://en.wikipedia.org/wiki/Combining_Diacritical_Marks_for_Symbols).
---@param str string @The string to deburr.
---@return string @Returns the deburred string.
function lodash.deburr(str)
    return str:gsub("[\128-\255]", ""):gsub("[\194-\223][\128-\191]", function (s)
        return s:sub(1, 1):lower() .. s:sub(2):upper()
    end)
end

---Check if `str` ends with the given target string.
---@param str string @The string to search.
---@param target string @The string to search for.
---@param position number @The position to search up to. *(optional)* The default is `str:len()`.
---@return boolean @Returns `true` if `str` ends with `target`, else `false`.
function lodash.endsWith(str, target, position)
    local len = str:len()
    local pos = position or len
    local startPos = math.min(math.max(pos, 0), len)
    return startPos + target:len() <= len and str:sub(startPos) == target
end

---Convers the characters "&", "<", ">", '"', "'", and "`" in `str` to their corresponding HTML entities.
---
---Though the ">" character is escaped for symmetry, characters like "<" and "/" don't need escaping in HTML and have no special meaning to HTML. See Mathias Bynens's [article](https://mathiasbynens.be/notes/ambiguous-ampersands) (under "semi-related fun fact") for more details.
---
---When working with HTML you should always [quote attribute values](http://wonko.com/post/html-escaping) to reduce XSS vectors.
---@param str string @The string to escape.
---@return string @Returns the escaped string.
function lodash.escape(str)
    return str:gsub("[&<>\"']", function (s)
        return s
    end)
end

---Escapes the `RegExp` special characters "^", "$", "\", ".", "*", "+", "-", "?", "(", ")", "[", "]", "{" and "}" in `str`.
---@param str string @The string to escape.
---@return string @Returns the escaped string.
function lodash.escapeRegExp(str)
    return str:gsub("[%^%$%(%)%%%.%*%+%-%?]", function (s)
        return "%" .. s
    end)
end

---Escape the lua string matching pattern special characters.
---@param str string @The string to escape.
---@return string @Returns the escaped string.
function lodash.escapeString(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function (s)
        return "%" .. s
    end)
end

---Convert `str` to [kebab case](https://en.wikipedia.org/wiki/Letter_case#Special_case_styles).
---@param str string @The string to convert.
---@return string @Returns the kebab cased string.
function lodash.kebabCase(str)
    return lodash.trim(str):gsub("%s", " "):gsub("%s(%w)", function (s)
        return s:lower()
    end):gsub("(%w)(%w+)", function (s1, s2)
        return s1:lower() .. "-" .. s2
    end)
end

---Converts `str`, as space separated words, to lower case.
---@param str string @The string to convert.
---@return string @Returns the lower cased string.
function lodash.lowerCase(str)
    return lodash.trim(str):gsub("%s", " "):gsub("%s(%w)", function (s)
        return s:lower()
    end)
end

---Converts the first character of `str` to lower case.
---@param str string @The string to convert.
---@return string @Returns the lower cased string.
function lodash.lowerFirst(str)
    return (str:sub(1, 1):lower() .. str:sub(2))
end

---Pads `str` on the left and right sides if it's shorter than `length`. Padding characters are truncated if they can't be evenly divided by `length`.
---@param str string @The string to pad.
---@param length number @The padding length.
---@param chars string @The string used as padding. *(optional)* The default is `" "`.
---@return string @Returns the padded string.
---@example 
---```lua
---_.pad('abc', 8) -- => ' abc   '
---_.pad('abc', 8, '_-') -- => '_-abc_-_'
---```
function lodash.pad(str, length, chars)
    chars = chars or " "
    local padLength = length - str:len()
    if padLength > 0 then
        local padString = chars:rep(math.floor(padLength / chars:len()) + 1)
        return padString:sub(1, padLength) .. str .. padString:sub(1, padLength)
    end
    return str
end

---Pads `str` on the right side if it's shorter than `length`. Padding characters are truncated if they can't be evenly divided by `length`.
---@param str string @The string to pad.
---@param length number @The padding length.
---@param chars string @The string used as padding. *(optional)* The default is `" "`.
---@return string @Returns the padded string.
function lodash.padEnd(str, length, chars)
    chars = chars or " "
    local padLength = length - str:len()
    if padLength > 0 then
        local padString = chars:rep(math.floor(padLength / chars:len()) + 1)
        return str .. padString:sub(1, padLength)
    end
    return str
end

---Pads `str` on the left side if it's shorter than `length`. Padding characters are truncated if they can't be evenly divided by `length`.
---@param str string @The string to pad.
---@param length number @The padding length.
---@param chars string @The string used as padding. *(optional)* The default is `" "`.
---@return string @Returns the padded string.
function lodash.padStart(str, length, chars)
    chars = chars or " "
    local padLength = length - str:len()
    if padLength > 0 then
        local padString = chars:rep(math.floor(padLength / chars:len()) + 1)
        return padString:sub(1, padLength) .. str
    end
    return str
end

---Concvert `str` to an integer of the specified radix. If `radix` is `nil` or `0`, a radix of `10` is assumed unless `value` is a hexadecimal, in which case a radix of `16` is assumed.
---@param str string @The string to convert.
---@param radix number @The radix to interpret `value` in. *(optional)* The default is `10`.
---@return number @Returns the converted number.
function lodash.parseInt(str, radix)
    radix = radix or 10
    return tonumber(str, radix)
end

---Replaces the matches for `pattern` in `str` with the replacement string `replacement`.
---@param str string @The string to modify.
---@param pattern string @The pattern to replace.
---@param replacement string @The match replacement.
---@return string @Returns the modified string.
function lodash.replace(str, pattern, replacement)
    return str:gsub(pattern, replacement)
end

---Converts `str` to [snake case](https://en.wikipedia.org/wiki/Letter_case#Special_case_styles).
---@param str string @The string to convert.
---@return string @Returns the snake cased string.
function lodash.snakeCase(str)
    return lodash.trim(str):gsub("%s", " "):gsub("%s(%w)", function (s)
        return s:lower()
    end):gsub("(%w)(%w+)", function (s1, s2)
        return s1:lower() .. "_" .. s2
    end)
end

---Splits `str` by `separator`.
---@param str string @The string to split.
---@param separator string @The separator pattern to split by.
---@param limit number @The maximum number of splits to make. *(optional)* The default is `0`.
---@return table @Returns the split string as a table.
function lodash.split(str, separator, limit)
    local result = {}
    local index = 1
    local pattern = "([^" .. separator .. "]+)"
    if limit then
        pattern = pattern .. "{" .. limit .. "}"
    end
    for match in str:gmatch(pattern) do
        result[index] = match
        index = index + 1
    end
    return result
end

---Converts `str` to [start case](https://en.wikipedia.org/wiki/Letter_case#Special_case_styles).
---@param str string @The string to convert.
---@return string @Returns the start cased string.
function lodash.startCase(str)
    return lodash.trim(str):gsub("%s", " "):gsub("%s(%w)", function (s)
        return s:upper()
    end)
end

---Checks if `str` starts with the given target string.
---@param str string @The string to check.
---@param target string @The target string to search for.
---@param pos number @The position to search from. *(optional)* The default is `1`.
---@return boolean @Returns `true` if `str` starts with `target`, else `false`.
function lodash.startsWith(str, target, pos)
    pos = pos or 1
    return str:sub(pos, pos + target:len() - 1) == target
end

---Converts `str` as a whole, to lower case.
---@param str string @The string to convert.
---@return string @Returns the lower cased string.
function lodash.toLower(str)
    return str:lower()
end

---Concerts `str` as a whole, to upper case.
---@param str string @The string to convert.
---@return string @Returns the upper cased string.
function lodash.toUpper(str)
    return str:upper()
end

---Removes leading and trailing whitespace or specified characters from `str`.
---@param str string @The string to trim.
---@param chars string @The characters to trim. *(optional)* The default is `" "`.
---@return string @Returns the trimmed string.
function lodash.trim(str, chars)
    chars = chars or " "
    return str:gsub("^[" .. chars .. "]+", ""):gsub("[" .. chars .. "]+$", "")
end

--Removes leading and trailing whitespace or specified characters from `str`.
---@param str string @The string to trim.
---@param chars string @The characters to trim. *(optional)* The default is `" "`.
---@return string @Returns the trimmed string.
function lodash.trimEnd(str, chars)
    chars = chars or " "
    return str:gsub("[" .. chars .. "]+$", "")
end

---Removes leading or specified characters from `str`.
---@param str string @The string to trim.
---@param chars string @The characters to trim. *(optional)* The default is `" "`.
---@return string @Returns the trimmed string.
function lodash.trimStart(str, chars)
    chars = chars or " "
    return str:gsub("^[" .. chars .. "]+", "")
end

---Truncates `str` if it's longer than the maximum given string length. The last characters of the truncated string are replaced with the omission string which defaults to "...".
---@param str string @The string to truncate.
---@param length number @The maximum string length.
---@param omission string @The string to indicate text has been omitted. *(optional)* The default is `"..."`.
---@param separator string The separator pattern to truncate to. *(optional)* The default is `" "`.
---@return string @Returns the truncated string.
function lodash.truncate(str, length, omission, separator)
    omission = omission or "..."
    separator = separator or " "
    if str:len() > length then
        local words = lodash.split(str, separator)
        local result = ""
        local index = 1
        while index <= length do
            result = result .. words[index]
            index = index + 1
        end
        return result .. omission
    end
    return str
end

---The inverse of `_.escape` this method converts the HTML entities `&amp;`, `&lt;`, `&gt;`, `&quot;`, and `&#39;` in `str` to their corresponding characters.
---@param str string @The string to unescape.
---@return string @Returns the unescaped string.
function lodash.unescape(str)
    return str:gsub("&amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", "\""):gsub("&#39;", "'")
end

---Converts `str`, as space separated words, to upper case.
---@param str string @The string to convert.
---@return string @Returns the upper cased string.
function lodash.upperCase(str)
    return lodash.trim(str):gsub("%s", " "):gsub("%s(%w)", function (s)
        return s:upper()
    end)
end

---Converts the first character of `str` to upper case.
---@param str string @The string to convert.
---@return string @Returns the converted string.
function lodash.upperFirst(str)
    return str:gsub("^%l", function (s)
        return s:upper()
    end)
end

---Split `str` into an array of its words.
---@param str string @The string to split.
---@param pattern string @The pattern to split by. *(optional)* The default is `%s+`.
---@return table @Returns the split string as a table.
function lodash.words(str, pattern)
    pattern = pattern or "%s+"
    return lodash.split(str, pattern)
end

-- "Util" methods.

---Attempt to invoke `func` with `args` and return either the result or the caught error object. Any additional arguments will be passed to `func`.
---@param func function @The function to attempt.
---@param ... any @The arguments to pass to `func`.
---@return any @Returns the result of the function or the error object.
function lodash.attempt(func, ...)
    local args = {...}
    local success, result = pcall(function ()
        return func(table.unpack(args))
    end)
    if success then
        return result
    else
        return result
    end
end

---Bind methods of an object to the object itself, overwriting the existing method.
---@param obj table @The object to bind the methods to.
---@param ... string @The methods to bind.
---@return table @Returns the object.
function lodash.bindAll(obj, ...)
    local methods = {...}
    for i = 1, #methods do
        local method = methods[i]
        obj[method] = lodash.bind(obj[method], obj)
    end
    return obj
end

---Create a function that iterates over `pairs` and invokes the corresponding function of the first predicate to return truthy. The predicate function are invokes with the `self` binding and arguments of the created function.
---@param pairs table @The predicate-function pair.
---@return function @Returns the new function.
function lodash.cond(pairs)
    return function (...)
        for i = 1, #pairs do
            local pair = pairs[i]
            if pair[1](...) then
                return pair[2](...)
            end
        end
    end
end

---Create a function that invokes the predicate properties of `source` with the corresponding property values of a given object, returning `true` if all predicate return truthy, else `false`.
---@param source table The object of the properties to conform to.
---@return function @Returns the new function.
function lodash.conforms(source)
    return function (obj)
        for key, value in pairs(source) do
            if type(value) == "function" then
                if not value(obj[key]) then
                    return false
                end
            else
                if obj[key] ~= value then
                    return false
                end
            end
        end
        return true
    end
end

---Creates a function that return `value`.
---@param value any @The value to return from the new function.
---@return function @Returns the new constant function.
function lodash.constant(value)
    return function ()
        return value
    end
end

---Checks `value` to determine whether a default value should be returned in its place. The `defaultValue` is returned if `value` is `nil` or `false`, else the `value` is returned.
---@param value any @The value to check.
---@param defaultValue any @The default value.
---@return any @Returns the resolved value.
function lodash.defaultTo(value, defaultValue)
    if value == nil or value == false then
        return defaultValue
    else
        return value
    end
end

---Creates a function that returns the result of invoking the given functions with the `self` binding of the created function, where each successive invocation is supplied the return value of the previous.
---@param funcs table @The functions to invoke.
---@return function @Returns the new composite function.
function lodash.flow(funcs)
    return function (...)
        local result = {...}
        for i = 1, #funcs do
            result = {funcs[i](table.unpack(result))}
        end
        return table.unpack(result)
    end
end

---This method is like `_.flow` except that it creates a function that invokes the given functions from right to left.
---@param funcs table @The functions to invoke.
---@return function @Returns the new composite function.
function lodash.flowRight(funcs)
    return function (...)
        local result = {...}
        for i = #funcs, 1, -1 do
            result = {funcs[i](table.unpack(result))}
        end
        return table.unpack(result)
    end
end

---This method return the first argument it receives.
---@param value any @Any value.
---@return any @Returns `value`.
function lodash.identity(value)
    return value
end

---Create a function that invokes `func` with the arguments of the created function. If `func` is a property name, the created function returns the property value for a given element. If `func` is an array or object, the created function returns `true` for elements that contain the equivalent source properties, otherwise it returns `false`.
---@param func any @The value to convert to a callback.
---@return function @Returns the new callback.
function lodash.iteratee(func)
    if type(func) == "string" then
        return function (obj)
            return obj[func]
        end
    elseif type(func) == "table" then
        return function (obj)
            for key, value in pairs(func) do
                if obj[key] ~= value then
                    return false
                end
            end
            return true
        end
    else
        return func
    end
end

---Create a function that performs a partial deep comparison between a given object and `source`, returning `true` if the given object has equivalent property values, else `false`.
---
---**Note:** The created function is equivalent to `_.isMatch` with a `source` partially applied.
---
---Partial comparisons will match empty array and empty object `source` values against any array or object value, respectively. See `_.isEqual` for a list of supported value comparisons.
---@param source table @The object of property values to match.
---@return function @Returns the new spec function.
function lodash.matches(source)
    return function (obj)
        for key, value in pairs(source) do
            if type(value) == "function" then
                if not value(obj[key]) then
                    return false
                end
            else
                if obj[key] ~= value then
                    return false
                end
            end
        end
        return true
    end
end

---Creates a function that performs a partial deep comparison between the value at `path` of a given object to `srcValue`, returning `true` if the object value is equivalent, else `false`.
---
---**Note:** Partial comparisons will match empty array and empty object `srcValue` values against any array or object value, respectively. See `_.isEqual` for a list of supported value comparisons.
---@param path string|table @The path of the property to get.
---@param srcValue any @The value to match.
---@return function @Returns the new spec function.
function lodash.matchesProperty(path, srcValue)
    if type(path) == "string" then
        return function (obj)
            return obj[path] == srcValue
        end
    elseif type(path) == "table" then
        return function (obj)
            for key, value in pairs(path) do
                if obj[key] ~= value then
                    return false
                end
            end
            return true
        end
    else
        return function (obj)
            return obj[path] == srcValue
        end
    end
end

---Create a function that invokes the method at `path` of a given object. Any additional arguments are provided to the invoked method.
---@param path string|table @The path of the method to invoke.
---@param ... any @The arguments to invoke the method with.
---@return function @Returns the new inoker function.
function lodash.method(path, ...)
    local args = {...}
    if type(path) == "string" then
        return function (obj)
            return obj[path](obj, table.unpack(args))
        end
    elseif type(path) == "table" then
        -- call method with arguments
        return function (obj)
            local result = {}
            for key, value in pairs(path) do
                result[key] = obj[value](obj, table.unpack(args))
            end
            return table.unpack(result)
        end
    else
        return function (obj)
            return path(obj, table.unpack(args))
        end
    end
end

---The opposite of `_.method`; this method creates a function that invokes the method at a given path of `object`. Any additional arguments are provided to the invoked method.
---@param object table @The object to query.
---@param ... any @The arguments to invoke the method with.
---@return function @Returns the new invoker function.
function lodash.methodOf(object, ...)
    local args = {...}
    return function (path)
        return object[path](object, table.unpack(args))
    end
end

---Adds all own enumerable string keyed function properties of a source object to the destination object. If `object` is a function, then methods are added to its prototype as well.
---@param object table @The destination object.
---@param source table @The object of functions to add.
---@param options table @The options object: `chain`: Specify whether mixins are chainable.
---@return table @Returns `object`.
function lodash.mixin(object, source, options)
    for key, value in pairs(source) do
        if type(value) == "function" then
            if options and options.chain then
                object[key] = lodash.wrap(value, function (func, ...)
                    local result = {func(...)}
                    for i = 1, #object do
                        table.insert(result, object[i](...))
                    end
                    return table.unpack(result)
                end)
            else
                object[key] = function (...)
                    local result = {value(...)}
                    for i = 1, #object do
                        table.insert(result, object[i](...))
                    end
                    return table.unpack(result)
                end
            end
        else
            object[key] = value
        end
    end
    return object
end


---This method returns `nil`.
---@return nil
function lodash.noop()
    return nil
end

---Creates a function that returns the argument at index `n`. If `n` is negative, the nth argument from the end is returned.
---@param n number @The index of the argument to return.
---@return function @Returns the new function.
function lodash.nthArg(n)
    return function (...)
        local args = {...}
        if n < 0 then
            return args[#args + n + 1]
        else
            return args[n]
        end
    end
end

---Create s a function that invokes `iteratees` with the arguments it receives and returns their results.
---@param iteratees function|function[] @The iteratees to invoke.
---@return function @Returns the new function.
function lodash.over(iteratees)
    if type(iteratees) == "function" then
        return function (...)
            local result = iteratees(...)
            return table.unpack(result)
        end
    elseif type(iteratees) == "table" then
        return function (...)
            local result = {}
            for i = 1, #iteratees do
                table.insert(result, iteratees[i](...))
            end
            return table.unpack(result)
        end
    end
end

---Create a function that checks if **all** of the `predicates` return truthy when invoked with the arguments it receives.
---@param predicates function[]|function @The predicates to check.
---@return function @Returns the new function.
function lodash.overEvery(predicates)
    if type(predicates) == "function" then
        return function (...)
            return predicates(...) and true or false
        end
    elseif type(predicates) == "table" then
        return function (...)
            for i = 1, #predicates do
                if not predicates[i](...) then
                    return false
                end
            end
            return true
        end
    end
end

---Creates a function that checks if **any** of the `predicates` return truthy when invoked with the arguments it receives.
---@param predicates function[]|function @The predicates to check.
---@return function @Returns the new function.
function lodash.overSome(predicates)
    if type(predicates) == "function" then
        return function (...)
            return predicates(...) and true or false
        end
    elseif type(predicates) == "table" then
        return function (...)
            for i = 1, #predicates do
                if predicates[i](...) then
                    return true
                end
            end
            return false
        end
    end
end

---Create a function that returns the value at `path` of a given object.
---@param path string|table @The path of the property to get.
---@return function @Returns the new accessor function.
function lodash.property(path)
    if type(path) == "string" then
        return function (obj)
            return obj[path]
        end
    elseif type(path) == "table" then
        return function (obj)
            local result = {}
            for key, value in pairs(path) do
                result[key] = obj[value]
            end
            return table.unpack(result)
        end
    else
        return function (obj)
            return obj[path]
        end
    end
end

---The opposite of `_.property`; this method creates a function that returns the value at a given path of `object`.
---@param object table @The object to query.
function lodash.propertyOf(object)
    return function (path)
        return object[path]
    end
end

---Creates an array of numbers (positive and/or negative) progressing from `start` up to, but not including, `end`. A step of `-1` is used if a negative `start` is specified without an `end` or `step`. If `end` is not specified, it's set to `start` with `start` then set to `0`.
---@param start number @The start of the range.
---@param rangeEnd number @The end of the range.
---@param step number @The value to increment or decrement by.
---@return number[] @Returns the new range.
function lodash.range(start, rangeEnd, step)
    local result = {}
    if step == nil then
        step = 1
    end
    if rangeEnd == nil then
        rangeEnd = start
        start = 0
    end
    if step > 0 then
        for i = start, rangeEnd, step do
            table.insert(result, i)
        end
    else
        for i = start, rangeEnd, step do
            table.insert(result, i)
        end
    end
    return result
end

---This method is like `_.range` except that it populates values in order.
---@param start number @The start of the range.
---@param rangeEnd number @The end of the range.
---@param step number @The value to increment or decrement by.
---@return number[] @Returns the new range.
function lodash.rangeRight(start, rangeEnd, step)
    local result = {}
    if step == nil then
        step = 1
    end
    if rangeEnd == nil then
        rangeEnd = start
        start = 0
    end
    if step > 0 then
        for i = rangeEnd, start, -step do
            table.insert(result, i)
        end
    else
        for i = rangeEnd, start, -step do
            table.insert(result, i)
        end
    end
    return result
end

---This method returns a new empty array.
---@return any[] @Returns the new array.
function lodash.stubArray()
    return {}
end

---This method returns `false`.
---@return boolean @Returns `false`.
function lodash.stubFalse()
    return false
end

---This method returns a new empty object.
---@return table @Returns the new empty object.
function lodash.stubObject()
    return {}
end

---This method returns an empty string.
---@return string @Returns the empty string.
function lodash.stubString()
    return ""
end

---This method returns `true`.
---@return boolean @Returns `true`.
function lodash.stubTrue()
    return true
end

---Invokes the iteratee `n` times, returning an array of the results of each invocation. The iteratee is invoked with one argument; (index).
---@param n number @The number of times to invoke `iteratee`.
---@param iteratee function @The function invoked per iteration.
---@return table @Returns the array of results.
function lodash.times(n, iteratee)
    local result = {}
    for i = 1, n do
        table.insert(result, iteratee(i))
    end
    return result
end

---Converts `value` to a property path array.
---@param value any @The value to convert.
---@return string[] @Returns the new property path array.
---@example _.toPath('a.b.c')
---@example _.toPath("a['b'].c[2]")
function lodash.toPath(value)
    if type(value) == "string" then
        local result = {}
        local start = 1
        local index = 1
        local length = #value
        while index <= length do
            local char = string.sub(value, index, index)
            if char == "." or char == "[" then
                local part = string.sub(value, start, index - 1)
                table.insert(result, part)
                start = index + 1
            end
            if char == "[" then
                local endIndex = string.find(value, "]", index + 1)
                if endIndex == nil then
                    error("Expected closing ']' in path.")
                end
                local part = string.sub(value, index + 1, endIndex - 1)
                table.insert(result, part)
                index = endIndex + 1
            end

            index = index + 1
        end
        local part = string.sub(value, start)
        table.insert(result, part)
        return result
    else
        return value
    end
end

---Generate a unique ID. If `prefix` is provided the ID is appended to it.
---@param prefix string @The value to prefix the ID with.
---@return string @The unique ID.
function lodash.uniqueId(prefix)
    local id = tostring(lodash.now())
    if prefix then
        id = prefix .. id
    end
    return id
end

return lodash