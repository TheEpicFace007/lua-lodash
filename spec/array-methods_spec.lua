--[[
  These units tests are based off of the tests of javascript lodash:
  https://github.com/lodash/lodash/blob/master/test/Arrays-category-methods.js
]]

local _ = require'lodash'
describe('"Arrays" category methods', function ()
  local args = { 1, nil, { 3 }, nil, 5 }
  local sortedArgs = { 1, { 3 }, 5, nil, nil }
  local array = { 1, 2, 3, 4, 5, 6 }

  it("#difference", function ()
    assert.is.equal(_.difference(args, { nil }), { 1, { 3 },  5 })
  end)
  it("#union", function ()
    assert.are.same(_.union(args, { nil, 6 }),
      { 1, { 3 }, 5 })
  end)
  it("#compact", function ()
    assert.are.same(_.compact(args), { 1, { 3 }, 5 })
  end)
  it("#drop", function ()
    assert.are.same(_.drop(array, 2), { 3, 4, 5, 6 })
  end)
  it("#dropRight", function ()
    assert.are.same(_.dropRight(array, 2), { 1, 2, 3, 4 })
  end)
  it("#dropRightWhile", function ()
    assert.are.same(_.dropRightWhile(array, function (n) return n % 2 == 0 end), { 5, 3, 1 })
  end)
  it("#findIndex", function ()
    assert.are.same(_.findIndex(array, function (n) return n % 2 == 0 end), 2)
  end)
  it("#findLastIndex", function ()
    assert.are.same(_.findLastIndex(array, function (n) return n % 2 == 0 end), 6)
  end)
  it("#flatten", function ()
    assert.are.same(_.flatten(sortedArgs), { 1, 3, 5, nil, nil })
  end)
  it("#head", function ()
    assert.is.equal(_.head(array), 1)
  end)
  it("#indexOf", function ()
    assert.is.equal(_.indexOf(array, 3), 3)
  end)
  it("#initial", function ()
    assert.are.same(_.initial(array), { 1, 2, 3, 4, 5 })
  end)
  it("#intersection", function ()
    assert.are.same(_.intersection(args, { 1 }, { 1 }), { 1 });
  end)
  it("#last", function ()
    assert.is.equal(_.last(array), 6)
  end)
  it("#lastIndexOf", function ()
    assert.is.equal(_.lastIndexOf(array, 3), 3)
  end)
  it("#sortedIndex", function ()
    assert.is.equal(_.sortedIndex(sortedArgs, { 3 }), 2)
  end)
  it("#sortedIndexOf", function ()
    assert.is.equal(_.sortedIndexOf(sortedArgs, { 3 }), 2)
  end)
  it("#sortedLastIndex", function ()
    assert.is.equal(_.sortedLastIndex(sortedArgs, { 3 }), 4)
  end)
  it("#sortedLastIndexOf", function ()
    assert.is.equal(_.sortedLastIndexOf(sortedArgs, { 3 }), 4)
  end)
  it("#tail", function ()
    assert.are.same(_.tail(array), { 2, 3, 4, 5, 6 })
  end)
  it("#take", function ()
    assert.are.same(_.take(array, 2), { 1, 2 })
  end)
  it("#takeRight", function ()
    assert.are.same(_.takeRight(array, 2), { 5, 6 })
  end)
  it("#takeRightWhile", function ()
    assert.are.same(
      _.takeRightWhile(array, function (n) return n % 2 == 0 end),
      { 5 }
    )
  end)
  it("#takeWhile", function ()
    assert.are.same(_.takeWhile(array, function (n) return n % 2 == 0 end), { 1 })
  end)
  it("#uniq", function ()
    assert.are.same(_.uniq(array), { 1, 2, 3, 4, 5, 6 })
  end)
  it("#without", function ()
    assert.are.same(_.without(array, 3), { 1, 2, 4, 5, 6 })
  end)
  it("#zip", function ()
    assert.are.same(_.zip(array, { 1, 2, 3, 4, 5, 6 }), { {1,2,3,4,5,6}, {1,2,3,4,5,6} })
  end)
end)