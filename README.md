matte
=====

A linear algebra library for the D programming language
-------------------------------------------------------

Currently still in early development, and the speed is not very good, but it should be useful to anyone wanting to implement algorithms that rely on matrix operations.

Examples
--------

This example shows that matrix multiplication is non-commutative.

```
import std.stdio;
import matte.matrix;

void main() {
    auto A = matrix([
        [1.0f, 2.0f],
        [3.0f, 4.0f]
    ]);

    auto B = matrix([
        [5.0f, 6.0f],
        [7.0f, 8.0f]
    ]);

    writeln(A * B);
    writeln(B * A);
}
```
