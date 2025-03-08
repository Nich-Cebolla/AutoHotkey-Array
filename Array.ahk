/*
   Github: https://github.com/Nich-Cebolla/AutoHotkey-Array/edit/main/Array.ahk
    Author: Nich-Cebolla
    Version: 1.0.0
    License: MIT
*/

Array.Prototype.DefineProp('Concat', { Call: ARRAY_CONCAT })
Array.Prototype.DefineProp('IsConcatSpreadable', { Value: true })
Object.Prototype.DefineProp('IsConcatSpreadable', { Value: false })
/**
 * @description - Implements Javascript's `array.prototype.concat` method in AutoHotkey. To mirror
 * Javascript's implementation, this library adds on the property `IsConcatSpreadable` to all objects.
 * For all objects except arrays, the value is `false`. For arrays, the value is `true`. When
 * `Concat` is called, if an item is an object, `Concat` will check the value of `IsConcatSpreadable`.
 * When true, it spreads the values of the item into the target array using variadic syntax.
 * {@link https://www.autohotkey.com/docs/v2/Functions.htm#Variadic}. When false, the object is
 * appended to the array as-is. However, just because an object's `IsConcatSpreadable` is `true`
 * does not necessarily make the object spreadable. This is only an indicator to `Concat` that it
 * should attempt to spread the object. AutoHotkey will attempt to spread the object as described by
 * the above link. To put in other words, the object must have an `__Enum` method that returns the
 * values to the first parameter, as it is called in its 1-parameter mode. The following built-in
 * classes fulfill this condition by default:
 * - Array
 * - Map
 * - Gui
 * - Enumerator
 * - RegExMatchInfo
 * All other classes and all custom classes which do not inherit from one of these must define an
 * `__Enum` method for it to be spreadable.
 * `Concat` will only spread items up to the first depth level. Any further nested objects will be
 * added as-is (more specifically, a reference to the object is added).
 * @param {Array} Arr - The target array. If calling this method from an array instance, skip this
 * parameter completely, don't leave a space for it.
 * @param {Any:Variadic} Items - The items to add to the array.
 * @returns {Array} - A new array containing the values of the target array and the input items.
 * `Concat` does not mutate the original array.
    @example
        class MyClass {
            __New(Items*) {
                this.__Item := Array(Items*)
                this.IsConcatSpreadable := true
            }
            __Enum(VarCount) {
                i := 0
                if VarCount == 1
                    return _Enum1
                else
                    return _Enum2
                _Enum1(&a) {
                    if ++i > this.__Item.Length
                        return false
                    a := this.__Item[i]
                    return true
                }
                _Enum2(&a, &b) {
                    if ++i > this.__Item.Length
                        return false
                    a := this.__Item[i]
                    b := i
                    return true
                }
            }
        }

        MyMyClass := MyClass(1, 2, 3, 4, 5)
        MyArr := [6,7,8,9,10]
        OutputDebug(MyArr.Concat(MyMyClass).Join(', ')) ; 6, 7, 8, 9, 10, 1, 2, 3, 4, 5
        MyMyClass.IsConcatSpreadable := false
        OutputDebug(MyArr.Concat(MyMyClass).Join(', ')) ; 6, 7, 8, 9, 10, {MyClass}
    @
 */
ARRAY_CONCAT(Arr, Items*) {
    Arr := Arr.Clone()
    if !Items.Length
        return Arr
    for Item in Items {
        if IsObject(Item) {
            if Item.IsConcatSpreadable
                Arr.Push(Item*)
            else
                Arr.Push(Item)
        } else
            Arr.Push(Item)
    }
    return Arr
}

Array.Prototype.DefineProp('Every', { Call: ARRAY_EVERY })
/**
 * @description - Implements Javascript's `array.prototype.every` method in AutoHotkey.
 * `Array.Prototype.Every` is used to check if all elements in an array pass a certain condition.
 * @param {Array} Arr - The array to iterate. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Func|BoundFunc|Closure} Callback - The function to execute on each element in the array.
 * The function should return a nonzero value when the condition is met. The function can accept
 * one to three parameters:
 * - The current element being processed in the array.
 * - [Optional] The index of the current element being processed in the array.
 * - [Optional] The array every was called upon.
 * @param {Any} [ThisArg] - The value to pass as `this` when executing the callback. For a detailed
 * description, see the document `ThisArg-Example.ahk` in the repository.
 * @returns {Boolean} - True if all elements pass the condition, false otherwise.
    @example
        OutputDebug([1,2,,4,5].Every((Item?, *) => IsSet(Item) ? Item < 6 : true)) ; 1
    @
 */
ARRAY_EVERY(Arr, Callback, ThisArg?) {
    if IsSet(ThisArg) {
        for Item in Arr {
            if !Callback(ThisArg, Item ?? unset, A_Index, Arr)
                return false
        }
    } else {
        for Item in Arr {
            if !Callback(Item ?? unset, A_Index, Arr)
                return false
        }
    }
    return true
}

Array.Prototype.DefineProp('Find', { Call: ARRAY_FIND })
/**
 * @description - Implements Javascript's `array.prototype.find` method in AutoHotkey.
 * @param {Array} Arr - The array to search. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Func|BoundFunc|Closure} Callback - The function to execute on each element in the array.
 * The function should return a nonzero value when the condition is met. The function can accept
 * one to three parameters:
 * - The current element being processed in the array.
 * - [Optional] The index of the current element being processed in the array.
 * - [Optional] The array find was called upon.
 * @returns {Any} - The first element in the array that satisfies the condition.
    @example
        OutputDebug([1,2,3,4,5].Find((Item, *) => Item > 3)) ; 4
    @
 */
ARRAY_FIND(Arr, Callback) {
    for Item in Arr {
        if IsSet(Item) && Callback(Item, A_Index, Arr)
            return Item
    }
}

Array.Prototype.DefineProp('FindAll', { Call: ARRAY_FIND_ALL })
/**
 * @description - Iterates an array passing each set value to a callback function. If the callback
 * function returns nonzero, the item and/or its index are adday to a separate array.
 * @param {Array} Arr - The array to search. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Func|BoundFunc|Closure} Callback - The function to execute on each element in the array.
 * The function should return a nonzero value when the condition is met. The function can accept
 * one to three parameters:
 * - The current element being processed in the array.
 * - [Optional] The index of the current element being processed in the array.
 * - [Optional] The array find was called upon.
 * @param {Boolean} [IncludeIndices=false] - If true, the index of the element is included in the
 * result array.
 * @param {Boolean} [IncludeItems=true] - If true, the element is included in the result array.
 * @returns {Array} - An array containing the items and/or indices that satisfy the condition.
 * If both `IncludeIndices` and `IncludeItems` are true, the items in the array are objects with
 * properties { Index, Item }.
 */
ARRAY_FIND_ALL(Arr, Callback, IncludeIndices := false, IncludeItems := true) {
    Result := []
    Result.Capacity := Arr.Length
    if IncludeIndices {
        if IncludeItems
            Set := (Item) => Result.Push({ Index: A_Index, Item: Item })
        else
            Set := (*) => Result.Push(A_Index)
    } else if IncludeItems
        Set := (Item) => Result.Push(Item)
    else
        throw Error('At least one or both of ``IncludeIndices`` and ``IncludeItems`` must be set.', -1)
    for Item in Arr{
        if IsSet(Item) && Callback(Item, A_Index, Arr)
            Set(Item)
    }
    Result.Capacity := Result.Length
    return Result.Length ? Result : ''
}

Array.Prototype.DefineProp('Flat', { Call: ARRAY_FLAT })
/**
 * @description - Implements Javascript's `array.prototype.flat` method in AutoHotkey.
 * `Array.Prototype.Flat` iterates the items in the array. If an item is unset, it is skipped. If
 * an item is an array and the current depth is less than or equal to the indicated `Depth`,
 * it's values are concatenated to the result array. For all other items, the item is added to
 * the result array as-is.
 * @param {Array} Arr - The array to flatten. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Integer} [Depth=1] - The maximum depth to recurse into nested arrays.
 * @returns {Array} - A new array containing the flattened elements.
 */
ARRAY_FLAT(Arr, Depth := 1) {
    Result := []
    Result.Capacity := Arr.Length
    i := 0
    _Flat(Arr)
    return Result

    _Flat(Source) {
        i++
        for Item in Source {
            if !IsSet(Item)
                continue
            if Item is Array {
                if i < Depth
                    _Flat(Item)
                else
                    Result.Push(Item*)
            } else
                Result.Push(Item)
        }
        i--
    }
}

Array.Prototype.DefineProp('ForEach', { Call: ARRAY_FOR_EACH })
/**
 * @description - Implements Javascript's `array.prototype.forEach` method in AutoHotkey.
 * `Array.Prototype.ForEach` is used to do an action on every value in an array.
 * @param {Array} Arr - The array to iterate. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Func|BoundFunc|Closure} Callback - The function to call for each element in the array.
 * If using `ThisArg`, this can accept two to four parameters. If not, it can accept one to three:
 * - The value passed to `ThisArg`. (This is only when `ThisArg` is set).
 * - The current element being processed in the array.
 * - [Optional] The index of the current element being processed in the array.
 * - [Optional] The array `ForEach` was called upon.
 * The function does not need a return value, and if one exists it is ignored.
 * @param {Any} [Default] - The value to use when an array index is unset. If `Default` is unset
 * and `ForEach` encounters an unset index, that index is skipped.
 * @param {Object} [ThisArg] - The object to use as `this` when executing the callback.
 */
ARRAY_FOR_EACH(Arr, Callback, Default?, ThisArg?) {
    if IsSet(ThisArg) {
        if IsSet(Default) {
            for Item in Arr
                Callback(ThisArg, Item??Default, A_Index, Arr)
        } else {
            for Item in Arr {
                if IsSet(Item)
                    Callback(ThisArg, Item, A_Index, Arr)
            }
        }
    } else {
        if IsSet(Default) {
            for Item in Arr
                Callback(Item??Default, A_Index, Arr)
        } else {
            for Item in Arr {
                if IsSet(Item)
                    Callback(Item, A_Index, Arr)
            }
        }
    }
}

Array.Prototype.DefineProp('IndexOf', { Call: ARRAY_INDEX_OF })
/**
 * @description - Searches an array for the input value.
 * @param {Array} Arr - The array to search. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Number|String} Item - The value to search for.
 * @param {Integer} [Start=1] - The index to start the search from.
 * @param {Integer} [Length] - The number of elements to search. If unset, the search will continue
 * until the end of the array.
 * @param {Boolean} [StrictType=true] - If true, the search will only return a match if the type of
 * the value in the array matches the type of the input value.
 * @param {Boolean} [CaseSense=true] - If true, the search will be case-sensitive.
 * @returns {Integer} - The index of the first occurrence of the input value in the array. If the
 * value is not found, an empty string is returned.
 */
ARRAY_INDEX_OF(Arr, Item, Start := 1, Length?, StrictType := true, CaseSense := true) {
    if IsObject(Item)
        throw TypeError('Objects cannot be compared by value. Define a hashing function to compare'
        ' objects, or use ``Find`` which searches an array using a callback function.', -1)
    End := IsSet(Length) && Start + Length < Arr.Length ?  Start + Length : Arr.Length
    i := Start - 1
    if CaseSense {
        if StrictType {
            while ++i <= End {
                if Arr.Has(i) && Arr[i] == Item && Type(Arr[i]) == Type(Item)
                    return i
            }
        } else {
            while ++i <= End {
                if Arr.Has(i) && Arr[i] == Item
                    return i
            }
        }
    } else {
        if StrictType {
            while ++i <= End {
                if Arr.Has(i) && Arr[i] = Item && Type(Arr[i]) == Type(Item)
                    return i
            }
        } else {
            while ++i <= End {
                if Arr.Has(i) && Arr[i] = Item
                    return i
            }
        }
    }
}

Array.Prototype.DefineProp('Join', { Call: ARRAY_JOIN })
/**
 * @description - Joins all elements of an array into a string. Note that unset indices are
 * represented as "" in the resulting string, and objects are represented as '{' Type(Object) '}'.
 * @param {Array} Arr - The array to join. If calling this method from an array instance, skip this
 * parameter completely, don't leave a space for it.
 * @param {String} [Delimiter=', '] - The string to separate each element of the array. If unset,
 * the default delimiter is a comma followed by a space.
 * @param {VarRef} [OutVar] - The variable to store the result in. This can be slightly faster for
 * very large strings, compared to getting the string as a return value.
 * @param {Integer} [Start=1] - The index to start the join from.
 * @param {Integer} [Length] - The number of elements to join. If unset, the join will continue until
 * the end of the array.
 * @returns {String} - The joined string.
 */
ARRAY_JOIN(Arr, Delimiter := ', ', &OutVar?, Start := 1, Length?) {
    OutVar := '', Start--
    while ++Start <= (IsSet(Length) && Start + Length < Arr.Length ?  Start + Length : Arr.Length) {
        if Arr.Has(Start) {
            if IsObject(Item := Arr[Start])
                OutVar .= '{' Type(Item) '}' Delimiter
            else
                OutVar .= String(Item) Delimiter
        } else
            OutVar .= '""' Delimiter
    }
    return Trim(OutVar, Delimiter)
}

Array.Prototype.DefineProp('Join2', { Call: ARRAY_JOIN2 })
/**
 * @description - Joins all elements of an array into a string.
 * @param {Array} Arr - The array to join. If calling this method from an array instance, skip this
 * parameter completely, don't leave a space for it.
 * @param {String} [Delimiter=', '] - The string to separate each element of the array. If unset,
 * the default delimiter is a comma followed by a space.
 * @param {VarRef} [OutVar] - The variable to store the result in. This can be slightly faster for
 * very large strings, compared to getting the string as a return value.
 * @param {Integer} [Start=1] - The index to start the join from.
 * @param {Integer} [Length] - The number of elements to join. If unset, the join will continue until
 * the end of the array.
 * @param {String} [UnsetItemString='""'] - The string to represent unset indices.
 * @param {Func|BoundFunc|Closure} [ObjectCallback=(Item) => '{' Type(Item) '}] - A fuction which
 * accepts the object as an argument and returns the string to add to the result string.
 * @returns {String} - The joined string.
 */
ARRAY_JOIN2(Arr, Delimiter := ', ', &OutVar?, Start := 1, Length?, UnsetItemString := '""', ObjectCallback := (Item) => '{' Type(Item) '}') {
    OutVar := '', Start--
    while ++Start <= (IsSet(Length) && Start + Length < Arr.Length ?  Start + Length : Arr.Length) {
        if Arr.Has(Start) {
            if IsObject(Item := Arr[Start])
                OutVar .= ObjectCallback(Item) Delimiter
            else
                OutVar .= String(Item) Delimiter
        } else
            OutVar .= UnsetItemString Delimiter
    }
    return Trim(OutVar, Delimiter)
}

Array.Prototype.DefineProp('LazySort', { Call: ARRAY_LAZY_SORT })
/**
 * @description - Utilizes AutoHotkey's built-in Sort function to sort an array. Does not mutate the
 * original array. Unset indices are not represented in the resulting array. This only sorts primitive
 * values.
 * @param {Array} Arr - The array to sort. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {String} [Options] - The options to pass to the Sort
 * function. {@link https://www.autohotkey.com/docs/v2/lib/Sort.htm}.
 * @param {Func|BoundFunc|Closure} [Callback] - The callback function to use for sorting.
 * @returns {Array} - The sorted array.
 */
ARRAY_LAZY_SORT(Arr, Options?, Callback?) {
    return StrSplit(Sort(Arr.JoinA('`n',,,,''), Options ?? unset, Callback ?? unset), '`n')
}

Array.Prototype.DefineProp('Map', { Call: ARRAY_MAP })
/**
 * @description - Implements Javascript's `array.prototype.map` method in AutoHotkey.
 * `Array.Prototype.Map` creates a new array with the results of the callback function. Each item
 * in the array is passed to the function, including unset indices. The function should return
 * the value that is to be addded to the array.
 * @param {Array} Arr - The array to iterate. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Func|BoundFunc|Closure} Callback - The function to execute on each element in the array.
 * When `ThisArg` is used, the callback can accept two to four arguments. Else, it can accept one
 * to three:
 * - The value passed to `ThisArg`. (This is only when `ThisArg` is set).
 * - The current element being processed in the array. Remember to allow this to be unset, either
 * by defining a default value or simply using the `?` operator.
 * - [Optional] The index of the current element being processed in the array.
 * - [Optional] The array map was called upon.
 * @param {Any} [ThisArg] - The value to pass as `this` when executing the callback. For a detailed
 * description, see the document `ThisArg-Example.ahk` in the repository.
 * @returns {Array} - A new array containing the values returned by the callback function.
    @example
        arr := [1,2,,4,,6,,,9]
        Callback := (Item?, *) => IsSet(Item) ? Item * 2 : 'Not found!'
        OutputDebug(arr.Map(Callback).Join(', ')) ; 2, 4, Not found!, 8, Not found!, 12, Not
        ; found!, Not found!, 18
    @
 */
ARRAY_MAP(Arr, Callback, ThisArg?) {
    Result := []
    Result.Length := Arr.Length
    if IsSet(ThisArg) {
        for Item in Arr
            Result[A_Index] := Callback(ThisArg, Item ?? unset, A_Index, Arr)
    } else {
        for Item in Arr
            Result[A_Index] := Callback(Item ?? unset, A_Index, Arr)
    }
    return Result
}

Array.Prototype.DefineProp('Purge', { Call: ARRAY_PURGE })
/**
 * @description - Iterates the items in an array and removes items that match the input values.
 * Mutates the original array.
 * @param {Array} Arr - The array to purge. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Boolean} [UnsetIndices=false] - If true, unset indices are also removed.
 * @param {String|Number:Variadic} Items - The items to remove from the array.
 * @returns {Array} - The purged array.
 */
ARRAY_PURGE(Arr, UnsetIndices := false, Items*) {
    if Items.Length {
        for Item in Items {
            if IsObject(Item)
                throw TypeError('Objects are not comparable by value. ``Purge`` accepts only primitive values.', -1)
        }
        if UnsetIndices
            _LoopItemsUnset()
        else
            _LoopItems()
    } else if UnsetIndices
        _LoopUnset()
    return Arr

    _LoopItems() {
        Indices := [], i := 0
        while ++i <= Arr.Length {
            if Arr.Has(i) {
                for PurgeItem in Items {
                    if Arr[i] == PurgeItem {
                        Indices.Push(i)
                        break
                    }
                }
            }
        }
        for Index in Indices
            Arr.RemoveAt(Index - A_Index + 1)
    }
    _LoopItemsUnset() {
        Indices := [], i := 0
        while ++i <= Arr.Length {
            if Arr.Has(i) {
                for PurgeItem in Items {
                    if Arr[i] == PurgeItem {
                        Indices.Push(i)
                        break
                    }
                }
            } else
                Indices.Push(i)
        }
        for Index in Indices
            Arr.RemoveAt(Index - A_Index + 1)
    }
    _LoopUnset() {
        Indices := []
        loop Arr.Length {
            if !Arr.Has(A_Index)
                Indices.Push(A_Index)
        }
        for Index in Indices
            Arr.RemoveAt(Index - A_Index + 1)
    }
}

Array.Prototype.DefineProp('Push2', { Call: ARRAY_PUSH2 })
/**
 * @description - This is the same as `Array.Prototype.Push`, except it also returns the array,
 * allowing this method to be chained with others.
 * @param {Array} Arr - The target array. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Any:Variadic} Item - The items to add to the array.
    @example
        OutputDebug([1,2,3,4].Push2(5,6,7,8).Join(', ')) ; 1, 2, 3, 4, 5, 6, 7, 8
    @
 */
ARRAY_PUSH2(Arr, Item*) {
    static ARRAY_PROTOTYPE_PUSH := Array.Prototype.Push
    ARRAY_PROTOTYPE_PUSH(Arr, Item*)
    return Arr
}

Array.Prototype.DefineProp('Reduce', { Call: ARRAY_REDUCE })
/**
 * @description - Implements Javascript's `array.prototype.reduce` in AutoHotkey. `Array.Prototype.Reduce` is
 * used to iterate upon the values in an array, using a VarRef parameter to generate a cumulative
 * result.
 * @param {Array} Arr - The array to iterate. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Func|BoundFunc|Closure} Callback - The function to execute on each element in the array.
 * The callback can accept two to four parameters:
 * - The accumulator. This must be VarRef.
 * - The current value being processed in the array.
 * - [Optional] The index of the current element being processed in the array.
 * - [Optional] The array reduce was called upon.
 * The function does not need a return value, and if it exists it is ignored.
 * @param {Any} [InitialValue] - The initial value of the accumulator. If not set, the first element
 * of the array will be used and iteration begins from the second element.
 * @param {Any} [Default] - The value to use when an array index is unset. If unset, that index
 * is skipped.
 * @returns {Any} - The value that results from the reduction.
 * @example
    arr := [1,2,,3,4,,,5]
    Callback := (&Accumulator, Value, *) => Accumulator += Value
    OutputDebug(arr.Reduce(Callback, , 1)) ; 18
   @
*/
ARRAY_REDUCE(Arr, Callback, InitialValue?, Default?) {
    i := 0
    while !Arr.Has(++i)
        continue
    if IsSet(InitialValue)
        Accumulator := InitialValue, i--
    else
        Accumulator := Arr[i]
    if IsSet(Default)
        _LoopWithDefault()
    else
        _Loop()
    return Accumulator

    _Loop() {
        while ++i <= Arr.Length {
            if !Arr.Has(i)
                continue
            Callback(&Accumulator, Arr[i], i, Arr)
        }
    }
    _LoopWithDefault() {
        while ++i <= Arr.Length
            Callback(&Accumulator, Arr.Has(i) ? Arr[i] : Default, i, Arr)
    }
}

Array.Prototype.DefineProp('Reverse', { Call: ARRAY_REVERSE })
/**
 * @description - Reverses the order of the elements in an array.
 * @param {Array} Arr - The array to reverse. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Integer} [Start=1] - The index to start the reverse from.
 * @param {Integer} [Length] - The number of elements to reverse. If unset, the reverse will continue
 * until the end of the array.
 * @returns {Array} - The reversed array.
 */
ARRAY_REVERSE(Arr, Start := 1, Length?) {
    Result := []
    if !IsSet(Length)
        Length := Arr.Length - Start + 1
    Result.Length := Length, End := Start + Length
    while --End >= Start {
        if Arr.Has(End)
            Result[A_Index] := Arr[End]
    }
    return Result
}

Array.Prototype.DefineProp('Slice', { Call: ARRAY_SLICE })
/**
 * @description - Extracts a section of an array and returns a new array. Does not mutate the
 * original array.
 * @param {Array} Arr - The array to slice. If calling this method from an array instance, skip this
 * parameter completely, don't leave a space for it.
 * @param {Integer} Start - The index to start the slice from.
 * @param {Integer} [Length] - The number of elements to include in the slice. If unset, the slice
 * will continue until the end of the array.
 * @returns {Array} - A new array containing the sliced elements.
 */
ARRAY_SLICE(Arr, Start := 1, Length?) {
    End := IsSet(Length) && Start + Length < Arr.Length ?  Start + Length : Arr.Length
    Result := [], Result.Length := End - Start + 1, Start--
    while ++Start <= End {
        if Arr.Has(Start)
            Result[A_Index] := Arr[Start]
    }
    return Result
}

Array.Prototype.DefineProp('Splice', { Call: ARRAY_SPLICE })
/**
 * @description - Adds and/or removes elements from an array. Mutates the original array and returns
 * the removed values.
 * @param {Array} Arr - The array to splice. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Integer} Start - The index to start the splicing from.
 * @param {Integer} [Length] - The number of elements to remove. If unset, all elements from the
 * start index to the end of the array will be removed.
 * @param {Any:Variadic} [Items] - The elements to add to the array. If unset, no elements will be
 * added.
 * @returns {Array} - An array containing the removed elements.
 */
ARRAY_SPLICE(Arr, Start := 1, Length?, Items*) {
    Result := []
    if Items.Length {
        i := 0
        if IsSet(Length) {
            Result.Length := Length
            if Items.Length >= Length {
                while ++i <= Min(Items.Length, Length) {
                    if Arr.Has(z := Start + i - 1)
                        Result[i] := Arr[z]
                    if Items.Has(i)
                        Arr[z] := Items[i]
                }
                if Items.Length > Length
                    Items.RemoveAt(1, --i), Arr.InsertAt(i+Start, Items*)
            } else {
                End := Start + Length - 1, Start--
                for Item in Items {
                    ++i, ++Start
                    if Arr.Has(Start)
                        Result[i] := Arr[Start]
                    if IsSet(Item)
                        Arr[Start] := Item
                    else
                        Arr[Start] := unset
                }
                s := Start
                while ++Start <= End
                    Arr.Has(Start) ? Result[++i] := Arr[Start] : ++i
                Arr.RemoveAt(s+1, End-s)
            }
        } else
            Arr.InsertAt(Start, Items*)
    } else {
        Result.Length := Length??(Arr.Length - Start + 1)
        End := Start + Result.Length - 1, Start--
        while ++Start <= End {
            if Arr.Has(Start)
                Result[A_Index] := Arr[Start]
        }
        Arr.RemoveAt(Start, Length??unset)
    }
    return Result
}

Array.Prototype.DefineProp('Unique', { Call: ARRAY_UNIQUE })
/**
 * @description - Returns an array of each unique value contained in the input array.
 * @param {Array} Arr - The array to iterate. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Integer} [Start=1] - The index to start the iteration from.
 * @param {Integer} [End] - The index to end the iteration. If unset, the iteration will continue
 * until the end of the array.
 * @param {Boolean} [StrictType=true] - If true, the comparison will only return true if the type
 * of the value in the array matches the type of the value being compared.
 * @param {Boolean} [CaseSense=true] - If true, the comparison will be case-sensitive.
 * @param {Func|BoundFunc|Closure} [Callback] - The callback function to use for comparison. The
 * callback function should accept the item as its only parameter and return the value to compare.
 * @returns {Array} - A new array containing each unique value from the input array.
 */
ARRAY_UNIQUE(Arr, Start := 1, Length?, StrictType := true, CaseSense := true, Callback?) {
    local Item
    Values := Map()
    Values.CaseSense := CaseSense
    Result := []
    if IsSet(Callback)
        Compare := StrictType ? _CompareCallback : _CompareAnyTypeCallback
    else
        Compare := StrictType ? _Compare : _CompareAnyType
    i := Start - 1
    if !IsSet(End)
        End := Arr.Length
    loop End - i {
        if Arr.Has(++i) {
            Item := Arr[i]
            Compare()
        }
    }
    return Result

    _Compare() => __Compare(Item)
    _CompareAnyType() => __Compare(String(Item))
    _CompareCallback() => __Compare(Callback(Item))
    _CompareAnyTypeCallback() => __Compare(String(Callback(Item)))
    __Compare(_Item) {
        if !Values.Has(_Item) {
            Values.Set(_Item, 1)
            Result.Push(Item)
        }
    }
}

Array.Prototype.DefineProp('Unique2', { Call: ARRAY_UNIQUE2 })
/**
 * @description - Iterates the input array, and for each unique value adds an object to an array
 * then returns the resulting array.
 * @param {Array} Arr - The array to iterate. If calling this method from an array instance, skip
 * this parameter completely, don't leave a space for it.
 * @param {Integer} [Start=1] - The index to start the iteration from.
 * @param {Integer} [End] - The index to end the iteration. If unset, the iteration will continue
 * until the end of the array.
 * @param {Boolean} [StrictType=true] - If true, the comparison will only return true if the type
 * of the value in the array matches the type of the value being compared.
 * @param {Boolean} [CaseSense=true] - If true, the comparison will be case-sensitive.
 * @param {Func|BoundFunc|Closure} [Callback] - The callback function to use for comparison. The
 * callback function should accept the item as its only parameter and return the value to compare.
 * @returns {Array} - A new array containing an object for each unique value. Each object has these
 * properties:
 * - Index: An array of indices at which the value was located.
 * - Count: The number of instances of the value in the array.
 * - Value: The unmodified first occurrence of the value in the array.
 */
ARRAY_UNIQUE2(Arr, Start := 1, Length?, StrictType := true, CaseSense := true, Callback?) {
    local Item
    Values := Map()
    Values.CaseSense := CaseSense
    Result := []
    if IsSet(Callback)
        Compare := StrictType ? _CompareCallback : _CompareAnyTypeCallback
    else
        Compare := StrictType ? _Compare : _CompareAnyType
    i := Start - 1
    if !IsSet(End)
        End := Arr.Length
    loop End - i {
        if Arr.Has(++i) {
            Item := Arr[i]
            Compare()
        }
    }
    return Result

    _Compare() => __Compare(Item)
    _CompareAnyType() => __Compare(String(Item))
    _CompareCallback() => __Compare(Callback(Item))
    _CompareAnyTypeCallback() => __Compare(String(Callback(Item)))
    __Compare(_Item) {
        if Values.Has(_Item) {
            Values.Get(_Item).Count++
            Values.Get(_Item).Index.Push(A_Index)
        } else {
            Values.Set(_Item, { Index: [A_Index], Count: 1, Value: Item })
            Result.Push(Values.Get(_Item))
        }
    }
}
