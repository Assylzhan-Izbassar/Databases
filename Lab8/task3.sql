/* Task 3. What is the difference between procedure and function? */

/*
    A function deals with as an expression. Function is used to calculate something from a given input.
Hence it got its name from Mathematics. The function can be called by a procedure.
In sql, inside the function we can not use the DML(Data manipulation language)
commands such as Insert, Delete, Update. Functions can be called through sql queries.
Each time functions are compiled when they are called. 	The return statement of a function
returns the control and function’s result value to the calling program. Function doesn't support try-catch blocks.
Function can be operated in the SELECT statement. Function does not support explicit transaction handles.
    Whereas a procedure does not deal with as an expression. While procedure is the set of commands,
which are executed in a order. But a procedure can not be called by a function. Here, in sql,
inside the procedure we can use DML commands. However, the procedure can’t be called through a sql query.
Whereas, procedures are compiled only once and can be called again and again as needed without being compiled each time.
While the return statement of the procedure returns control to the calling program, it can not return the result value.
While it supports try-catch blocks. While it can’t be operated in the SELECT statement.
While procedure supports explicit transaction handles.
*/