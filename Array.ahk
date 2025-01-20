Array.Prototype.DefineProp('Find', {Call: ARRAY_FIND})
/**
 * @description - Implements Javascript's `array.find` method in AutoHotkey.
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

Array.Prototype.DefineProp('ForEach', {Call: ARRAY_FOR_EACH})
/**
 * @description - Implements Javascript's `array.forEach` method in AutoHotkey.
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

Array.Prototype.DefineProp('IndexOf', {Call: ARRAY_INDEX_OF})
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

Array.Prototype.DefineProp('Join', {Call: ARRAY_JOIN})
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

Array.Prototype.DefineProp('Reduce', {Call: ARRAY_REDUCE})
/**
 * @description - Implements Javascript's `array.reduce` in AutoHotkey. `Array.Prototype.Reduce` is
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

Array.Prototype.DefineProp('Reverse', {Call: ARRAY_REVERSE})
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

Array.Prototype.DefineProp('Slice', {Call: ARRAY_SLICE})
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

Array.Prototype.DefineProp('Splice', {Call: ARRAY_SPLICE})
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
ARRAY_SPLICE(Arr, Start, Length?, Items*) {
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
