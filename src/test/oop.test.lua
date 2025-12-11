function class__test()
    return {
        name = "class",
        class__given_nil_parent__returns_new_base_class = function ()
            local TestClass = class()
            assert(TestClass ~= nil)
            assert(TestClass._super == Object)
        end,
        class__given_nonnil_parent__returns_new_subclass = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class({_super = TestBaseClass})
            assert(TestSubclass ~= nil)
            assert(TestSubclass._super == TestBaseClass)
        end
    }
end

function is__test()
    return {
        name = "is",
        is__given_direct_class_instance__returns_true_or_else_false = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class({_super = TestBaseClass})
            local TestLeafClass   = class({_super = TestSubclass})
            
            local base_instance = TestBaseClass({})

            assert(    base_instance:_is(TestBaseClass))
            assert(not base_instance:_is(TestSubclass))
            assert(not base_instance:_is(TestLeafClass))
        end,
        is__given_direct_subclass_instance__returns_true_or_else_false = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class({_super = TestBaseClass})
            local TestLeafClass   = class({_super = TestSubclass})
            
            local  sub_instance =  TestSubclass:_new()
            
            assert(    sub_instance:_is(TestBaseClass))
            assert(    sub_instance:_is(TestSubclass))
            assert(not sub_instance:_is(TestLeafClass))
        end,
        is__given_descendant_class_instance__returns_true_or_else_false = function ()
            local TestBaseClass   = class()
            local TestSubclass    = class({_super = TestBaseClass})
            local TestLeafClass   = class({_super = TestSubclass})
            
            local leaf_instance = TestLeafClass:_new()

            assert(leaf_instance:_is(TestBaseClass))
            assert(leaf_instance:_is(TestSubclass))
            assert(leaf_instance:_is(TestLeafClass))
        end
    }
end
