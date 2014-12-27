module matte.matrix;

import std.conv;

/**
 * Creates a matrix of the given dimensions.
 */
Matrix!T matrix(T = float)(size_t numRows, size_t numColumns)
{
	return Matrix!T(numRows, numColumns);
}

/**
 * Creates a vector with the given number of dimensions.
 */
Matrix!T vector(T = float)(size_t dims)
{
	return Matrix!T(dims, 1);
}

/**
 * Creates an identity matrix of the given size.
 */
Matrix!T identity(T = float)(size_t size)
{
	auto mat = matrix(size, size);

	for(size_t i = 0; i < size; i++)
	{
		mat[i, i] = 1;
	}

	return mat;
}

/**
 * Creates a matrix full of zeros.
 */
Matrix!T zeros(T = float)(size_t numRows, size_t numColumns)
{
	return matrix!T(numRows, numColumns);
}

/**
 * Creates a matrix full of ones.
 */
Matrix!T ones(T = float)(size_t numRows, size_t numColumns)
{
	auto mat = matrix!T(numRows, numColumns);
	mat.elements[] = 1;

	return mat;
}

struct Matrix(T)
{
	public
	{
		this(size_t numRows, size_t numColumns)
		in
		{
			assert(numRows > 0);
			assert(numColumns > 0);
		}
		body
		{
			this.numRows = numRows;
			this.numColumns = numColumns;
			elements = new T[numRows * numColumns];
			elements[] = 0;
		}

		Matrix!T opBinary(string op)(Matrix!T rhs)
		{
			static if(op == "+" || op == "-")
			{
				assert(rhs.rows == numRows);
				assert(rhs.columns == numColumns);

				Matrix!T result = Matrix!T(numRows, numColumns);
				mixin("result.elements[] = elements[] " ~ op ~ "rhs.elements[];");

				return result;
			}
			else static if(op == "*")
			{
				assert(numColumns == rhs.rows);

				Matrix!T result = Matrix!T(numRows, rhs.columns);

				for(size_t j = 0; j < result.rows; j++)
				{
					for(size_t i = 0; i < result.columns; i++)
					{
						result[j, i] = 0;

						for(size_t k = 0; k < numColumns; k++)
						{
							result[j, i] = result[j, i] + this[j, k] * rhs[k, i];
						}
					}
				}

				return result;
			}
			else
			{
				static assert(0);
			}
		}

		Matrix!T opBinary(string op)(T scalar)
		{
			static if(op == "*")
			{
				Matrix!T result = Matrix!T(numRows, numColumns);
				result.elements[] = elements[] * scalar;

				return result;
			}
			else
			{
				static assert(0);
			}
		}

		Matrix!T opBinaryRight(string op)(T scalar)
		{
			static if(op == "*")
			{
				return this * scalar;
			}
			else
			{
				static assert(0);
			}
		}

		T opIndex(size_t j, size_t i)
		in
		{
			assert(j < numRows);
			assert(i < numColumns);
		}
		body
		{
			return elements[j * numColumns + i];
		}

		T opIndexAssign(T value, size_t j, size_t i)
		in
		{
			assert(j < numRows);
			assert(i < numColumns);
		}
		body
		{
			return elements[j * numColumns + i] = value;
		}

		string toString()
		{
			string result;

			for(size_t j = 0; j < numRows; j++)
			{
				for(size_t i = 0; i < numColumns; i++)
				{
					result ~= this[j, i].to!string;

					if(i == (numColumns - 1))
					{
						result ~= "\n";
					}
					else
					{
						result ~= "\t";
					}
				}
			}

			return result;
		}

		@property size_t rows()
		{
			return numRows;
		}

		@property size_t columns()
		{
			return numColumns;
		}

		@property float[] data()
		{
			return elements;
		}

		@property bool isSquare()
		{
			return numRows == numColumns;
		}

		@property Matrix!T transpose()
		{
			auto t = Matrix!T(numColumns, numRows);

			for(size_t j = 0; j < numRows; j++)
			{
				for(size_t i = 0; i < numColumns; i++)
				{
					t[i, j] = this[j, i];
				}
			}

			return t;
		}

		@property T trace()
		{
			assert(numRows == numColumns);

			T result = 0;

			for(size_t i = 0; i < numRows; i++)
			{
				result += this[i, i];
			}

			return result;
		}
	}

	private
	{
		size_t numColumns;
		size_t numRows;
		T[] elements;
	}
}