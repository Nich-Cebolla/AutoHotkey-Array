
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
