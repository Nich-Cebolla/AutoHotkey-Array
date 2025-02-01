# AutoHotkey-Array
An AutoHotkey (AHK) library implementing common array methods.

Contents:

- **Array.Prototype.Concat** - Creates a new array by combining an array with any number of additional elements.
- **Array.Prototype.Every** - Iterates an array passing every value to a callback function (including unset indices), and returns false if the callback returns false once; true otherwise.
- **Array.Prototype.Find** - Iterates an array passing every value to a callback function (except for unset indices), and returns the item when the function returns true.
- **Array.Prototype.ForEach** - Iterates an array passing every value to a callback function (except unset indices).
- **Array.Prototype.IndexOf** - Iterates an array comparing every value (except unset indices) to an input value, and returns the index of the first item that matches the input value.
- **Array.Prototype.Join** - Iterates an array (including unset indices) adding each value to a string joined by a delimiter substring.
- **Array.Prototype.JoinA** - The same as `Join`, except `JoinA` also exposes `[UnsetItemString = ""]` as an input parameter, and exposes `[ObjectCallback = (Item) => '{' Type(Item) '}"]` as an input parameter.
- **Array.Prototype.Map** - Creates a new array then iterates the original array (including unset indices), adding the results from a callback function to the new array.
- **Array.Prototype.PushA** - The same as `Array.Prototype.Push` except this returns the array, allowing it to be chained with other array methods.
- **Array.Prototype.Reduce** - Iterates an array (excluding unset indices) passing each item to a callback function. The callback function must accept a VarRef parameter, and the callback function should cumulatively modify the VarRef. Returns the VarRef when `Reduce` ends.
- **Array.Prototype.Reverse** - Creates a new array with the values from the original array in reverse order.
- **Array.Prototype.Slice** - Creates a new array as a segment of an original array.
- **Array.Prototype.Splice** - Mutates the original array, optionally removing some elements, and optionally adding some elements. The removed elements are returned as a new array.
