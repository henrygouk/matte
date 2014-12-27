module app;

import std.stdio;

import matte.matrix;

void main()
{
	writeln("app for debugging matte");

	writeln(identity(3));
	writeln(zeros(3, 3));
	writeln(ones(3, 3));
	writeln(identity(5).trace);
}
