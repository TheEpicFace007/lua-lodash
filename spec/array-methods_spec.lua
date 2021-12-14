local _ = require'lodash'
describe('"Arrays" category methods', function ()
  local args = { 1, nil, { 3 }, nil, 5 }
  local sortedArgs = { 1, { 3 }, 5, nil, nil }
  local array = { 1, 2, 3, 4, 5, 6 }

  it("#difference", function ()
    assert.are.same(_.difference(args, { nil }), { 1, { 3 },  5 })
  end)
  it("#union", function () 
    assert.are.same( { 1, nil, { 3 }, 5, 6 }, _.union(args, { nil, 6 }))
      
  end)
  it("#compact", function ()
    assert.are.same(_.compact(args), { 1, { 3 }, 5 })
  end)
  it("#drop", function ()
    assert.are.same(_.drop(array, 2), { 3, 4, 5, 6 })
  end)
  it("#dropRight", function ()
    assert.are.same(_.dropRight(array, 2), { 1, nil })
  end)
  it("#dropRightWhile", function ()
    assert.are.same({ 1, nil, 3, 4, 5 }, _.dropRightWhile(array, function (n) return n % 2 == 0 end))
  end)
  it("#findIndex", function ()
    assert.are.same(2, _.findIndex(array, function (n) return n % 2 == 0 end))
  end)
  it("#findLastIndex", function ()
    assert.is.equal(5, _.findLastIndex(array, function (n) return n % 2 == 0 end))
  end)
  it("#flatten", function ()
    assert.are.same({ 1, nil, 3, nil, 5 }, _.flatten(args))
  end)
  it("#head", function ()
    assert.is.equal(1, _.head(array))
  end)
  it("#indexOf", function ()
    assert.is.equal(2, _.indexOf(array, 3))
  end)
  it("#initial", function ()
    assert.are.same({ 1, 2, 3, 4, 5 }, _.initial(array))
  end)
  it("#intersection", function ()
    assert.are.same({ 1, { 3 }, 5 }, _.intersection(args))
  end)
  it("#last", function ()
    assert.is.equal(6, _.last(array))
  end)
  it("#lastIndexOf", function ()
    assert.is.equal(2, _.lastIndexOf(array, 3))
  end)
  it("#sortedIndex", function ()
    assert.is.equal(2, _.sortedIndex(sortedArgs, { 3 }, function (a, b) return a[1] < b[1] end))
  end)
  it("#sortedIndexOf", function ()
    assert.is.equal(2, _.sortedIndexOf(sortedArgs, { 3 }, function (a, b) return a[1] < b[1] end))
  end)
  it("#sortedLastIndex", function ()
    assert.is.equal(4, _.sortedLastIndex(sortedArgs, { 3 }, function (a, b) return a[1] < b[1] end))
  end)
  it("#sortedLastIndexOf", function ()
    assert.is.equal(4, _.sortedLastIndexOf(sortedArgs, { 3 }, function (a, b) return a[1] < b[1] end))
  end)
  it("#tail", function ()
    assert.are.same({ 2, 3, 4, 5, 6 }, _.tail(array), )
  end)
  it("#take", function ()
    assert.are.same({ 1, 2 }, _.take(array, 2))
  end)
  it("#takeRight", function ()
    assert.are.same({ 5, 6 }, _.takeRight(array, 2))
  end)
  it("#takeRightWhile", function ()
    assert.are.same({ 6 }, _.takeRightWhile(array, function (n) return n % 2 == 0 end))
  end)
  it("#takeWhile", function ()
    assert.are.same({ 1, 2 }, _.takeWhile(array, function (n) return n % 2 == 0 end))
  end)
  it("#uniq", function ()
    assert.are.same({ 1, 2, 3, 4, 5, 6 }, _.uniq(array))
  end)
  it("#without", function ()
    assert.are.same({ 1, 2, 4, 5, 6 }, _.without(array, 3))
  end)
  it("#zip", function ()
    assert.are.same({ { 1, 1 }, { 2, 2 }, { 3, 3 }, { 4, 4 }, { 5, 5 }, { 6, 6 } }, _.zip(array, { 1, 2, 3, 4, 5, 6 }))
  end)
end)