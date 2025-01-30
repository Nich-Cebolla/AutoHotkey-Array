
/*
The following methods have a parameter `ThisArg`:
- Array.Prototype.ForEach
- Array.Prototype.Map
To use these effectively, you should understand AutoHokey's implementation of `this`, when `ThisArg`
should be used with these methods, and when it should be excluded. Here is the main considerations,
and some examples. The examples use `ForEach` for demonstration, but the same principles apply to
`Map`. Note, however, that `Map` does not use a default parameter, and unset indices within `Map`
are passed to the callback as `unset`.

When to leave `ThisArg` unset:
- If iterating over an array using a callback that is NOT a class method.
- If iterating over an array using a callback that is a BoundFunc created using `ObjBindMethod`.

When to set `ThisArg`:
If iterating over an array using a callback that is a class method, you need to pass something to
`ThisArg`. This does not necessarily need to be the instance object or the class object, but it could
be. These are the scenarios to consider when defining the parameter:
- It could be any type of value that is referenced within the method using the `this` keyword.
Typically, this is the class object or instance object itself.
- If the callback method does not refer to `this` at all, just pass any value, `0` is fine, to
`ThisArg`. This is necessary to tell the function to use the correct loop.
- If you want to modify what `this` refers to within the function's scope (for example, during
testing), pass an object to `ThisArg` that has the same properties as the object that is referenced
within the function. This allows you to test different values without modifying the class object or
making other changes. See example 7 for an example of this usage.
*/

#Include <Array>

; Example 1: Standard usage.

MyFunc(Item, *) {
    OutputDebug('`nItem: ' Item)
}
Arr := [1,2,,4,,6,,,9]
Callback := MyFunc
Arr.ForEach(Callback) ; Leave `ThisArg` unset.

; ~~~~~

; Exampe 2: Using a default value.

MyFunc2(Item, *) {
    OutputDebug('`nItem: ' Item)
}
Arr := [1,2,,4,,6,,,9]
Callback := MyFunc2
Arr.ForEach(Callback, 'Not found!') ; Set a default value to be used for unset indices. Leave `ThisArg` unset.

; ~~~~~

; Example 3: Using an anonymous function.

; For anonymous functions, also leave `ThisArg` unset.
Arr := [1,2,,4,,6,,,9]
Arr.ForEach((Item, Index, *) => OutputDebug('`nIndex: ' Index '`tItem: ' Item))

; Example 4: Using `ObjBindMethod` on a class object.

class Test4 {
    static Call(Item, *) {
        OutputDebug('`nItem: ' Item * 2)
    }
}

Arr := [1,2,,4,,6,,,9]
Callback := ObjBindMethod(Test4, 'Call')
Arr.ForEach(Callback) ; Leave `ThisArg` unset because it is already bound to the function object.

; ~~~~~

; Example 5: Using a class method that is not bound, and the method does not refer to `this`.

class Test5 {
    static Call(Item, Index, Arr?) {
        OutputDebug('`n`nItem: ' Item '`tIndex: ' Index '`t``this``: ' this '`tArray:`n' Arr.Join())
    }
}

Arr := ['a', 'b', 'c', 'd', 'e']
Callback := Test5.Call
; `ThisArg` requires a value because the first parameter in a class method is the hidden `this`, so
; when `Array.Prototype.ForEach` calls the function object, the first parameter which it passes
; to the callback is going to be consumed by `this`. A good way to visualize this is to open this
; in a debugger and see which values are passed to `Test.Call`. Try one without the 0 in the
; `ThisArg` parameter, and see how it works. What you will see is that the first parameter
; is consumed by `this`, which in a typical function call, you wouldn't notice this, but within an
; external function call, it becomes apparent.
Arr.ForEach(Callback,, 0)

; ~~~~~

; Example 6: Using a class method that is not bound, and the method refers to `this`, and `this`
; refers to the class.

class Test6 {
    static Call(Item, *) {
        OutputDebug('`nItem: ' Item * this.factor)
    }
    static factor := 2
}

Arr := [1,2,,4,,6,,,9]
Callback := Test6.Call
; We must pass the object `Test` because `this` is referenced within the function, and that
; reference is intended to refer to `Test`.
Arr.ForEach(Callback,, Test6)

; ~~~~~

; Example 7: Using a class method with a value that we want to override within our callback function.

class Test7 {
    static Call(Item, *) {
        OutputDebug('`nItem: ' Item * this.factor)
    }
    static factor := 2
}
Multiplier := { factor: 3 }
Arr := [1,2,,4,,6,,,9]
Callback  := Test7.Call
; We pass `Multiplier` as `ThisArg` to modify what `this` refers to within the function.
; This allows us to test a new value against the function, without needing to modify our class object
; or make other changes, simplifying the testing process.
Arr.ForEach(Callback,, Multiplier)
