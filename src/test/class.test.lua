function class__test()
    return {
        name = "class",
        class__given_nil_parent__returns_new_base_class = function ()
            local TestClass = class()
            assert(not (TestClass == nil))
            assert(getmetatable(TestClass).__index == nil)
        end,
        class__given_nonnil_parent__returns_new_subclass = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class(TestBaseClass)
            assert(not (TestSubclass == nil))
            assert(getmetatable(TestSubclass).__index == TestBaseClass)
        end
    }
end

function is__test()
    return {
        name = "is",
        is__given_direct_class_instance__returns_true_or_else_false = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class(TestBaseClass)
            local TestLeafClass   = class(TestSubclass)
            
            local base_instance = TestBaseClass:new()

            assert(    base_instance:is(TestBaseClass))
            assert(not base_instance:is(TestSubclass))
            assert(not base_instance:is(TestLeafClass))
        end,
        is__given_direct_subclass_instance__returns_true_or_else_false = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class(TestBaseClass)
            local TestLeafClass   = class(TestSubclass)
            
            local  sub_instance =  TestSubclass:new()
            
            assert(    sub_instance:is(TestBaseClass))
            assert(    sub_instance:is(TestSubclass))
            assert(not sub_instance:is(TestLeafClass))
        end,
        is__given_descendant_class_instance__returns_true_or_else_false = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class(TestBaseClass)
            local TestLeafClass   = class(TestSubclass)
            
            local leaf_instance = TestLeafClass:new()

            assert(leaf_instance:is(TestBaseClass))
            assert(leaf_instance:is(TestSubclass))
            assert(leaf_instance:is(TestLeafClass))
        end
    }
end
