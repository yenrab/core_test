# Core Erlang Language Semantics

## Overview

Core Erlang is a functional intermediate language with strict evaluation semantics. This document describes the operational semantics, evaluation rules, and behavioral characteristics of Core Erlang constructs.

## Evaluation Model

### Strict Evaluation
Core Erlang uses strict (eager) evaluation semantics. All function arguments are evaluated before the function is called, and all subexpressions are evaluated before the containing expression.

### Single Assignment
Variables in Core Erlang are single-assignment. Once a variable is bound to a value, it cannot be reassigned.

### Pattern Matching
Pattern matching is the primary control flow mechanism. It determines which branch of execution to take based on the structure and values of data.

## Expression Evaluation

### Literal Values
Literal values evaluate to themselves:
- `42` → `42`
- `'hello'` → `'hello'`
- `[1, 2, 3]` → `[1, 2, 3]`
- `{a, b}` → `{a, b}`

### Variables
Variables evaluate to their bound values. Unbound variables cause evaluation errors.

### Function Application
Function application follows these steps:
1. Evaluate all arguments
2. Look up the function definition
3. Bind parameters to argument values
4. Evaluate the function body

### Let Expressions
Let expressions introduce local bindings:
```
let <vars> = <expr1> in <expr2>
```

Evaluation:
1. Evaluate `expr1`
2. Bind `vars` to the result
3. Evaluate `expr2` with the new bindings

### Case Expressions
Case expressions provide pattern matching:
```
case <expr> of
    <pattern1> when <guard1> -> <body1>
    <pattern2> when <guard2> -> <body2>
    ...
end
```

Evaluation:
1. Evaluate `expr`
2. Try each clause in order:
   - Match pattern against the value
   - If pattern matches, evaluate guard
   - If guard evaluates to `'true'`, evaluate body
3. If no clause matches, raise `function_clause` error

## Pattern Matching Semantics

### Atomic Patterns
- Literal values match only themselves
- Variables match any value and bind to it
- Wildcard `_` matches any value but doesn't bind

### Tuple Patterns
Tuple patterns match tuples with the same arity:
- `{a, b}` matches `{a, b}` but not `{a, b, c}`
- `{X, Y}` matches any two-tuple and binds `X` and `Y`

### List Patterns
List patterns match lists with compatible structure:
- `[H|T]` matches non-empty lists, binding `H` to head and `T` to tail
- `[a, b, c]` matches the list `[a, b, c]`
- `[X|Y]` matches any non-empty list

### Map Patterns
Map patterns match maps with compatible key-value pairs:
- `#{key := value}` matches maps with exact key-value pairs
- `#{key => value}` matches maps with key-value associations
- `#{K := V}` matches any map and binds `K` and `V`

### Binary Patterns
Binary patterns match binary data with specified structure:
- `<<X:8>>` matches 8-bit binaries and binds `X`
- `<<H:8, T/binary>>` matches binaries with at least 8 bits

## Guard Semantics

Guards are boolean expressions that must evaluate to `'true'` for a clause to be selected. Guards have restrictions:

### Allowed in Guards
- Literal values
- Variables
- Function calls to BIFs (Built-in Functions)
- Arithmetic operations
- Comparison operations
- Boolean operations
- Type tests (`is_atom/1`, `is_integer/1`, etc.)

### Not Allowed in Guards
- User-defined function calls
- Complex data structure construction
- Side effects
- Exception handling

### Guard Evaluation
Guards are evaluated in a restricted environment:
1. Only BIFs are available
2. No side effects are allowed
3. Must terminate (no infinite loops)
4. Must evaluate to `'true'` or `'false'`

## Exception Handling

### Try-Catch Semantics
```
try <expr> of
    <pattern> -> <body>
catch
    <exception_pattern> -> <handler>
end
```

Evaluation:
1. Evaluate `expr`
2. If successful, match result against pattern and evaluate body
3. If exception occurs, match against exception pattern and evaluate handler

### Exception Types
- `throw(Term)` - Explicit throws
- `error(Reason)` - Runtime errors
- `exit(Reason)` - Process exits

### Exception Propagation
Exceptions propagate up the call stack until caught by a try-catch or the process terminates.

## Message Passing Semantics

### Receive Expression
```
receive
    <pattern1> when <guard1> -> <body1>
    <pattern2> when <guard2> -> <body2>
    ...
after <timeout> ->
    <timeout_body>
end
```

Evaluation:
1. Check mailbox for messages
2. Try each clause in order:
   - Match pattern against message
   - If pattern matches, evaluate guard
   - If guard succeeds, evaluate body
3. If no message matches, wait for timeout
4. If timeout expires, evaluate timeout body

### Message Ordering
Messages are processed in FIFO order within the mailbox.

### Timeout Values
- `0` - Non-blocking (check mailbox and return immediately)
- `infinity` - Wait indefinitely
- Positive integer - Wait for specified milliseconds

## Data Structure Semantics

### Lists
Lists are implemented as linked lists:
- `[H|T]` - Head and tail
- `[]` - Empty list
- List construction is right-associative: `[1|[2|[3|[]]]]`

### Tuples
Tuples are fixed-size collections:
- `{a, b, c}` - Three-element tuple
- Elements are accessed by position (1-indexed)
- Tuples are immutable

### Maps
Maps are key-value associations:
- `#{key => value}` - Association
- `#{key := value}` - Exact match
- Maps are mutable (in Core Erlang context)

### Binaries
Binaries are sequences of bits:
- `<<Data/binary>>` - Binary data
- `<<Value:Size/Type>>` - Bitstring with specified size and type
- Endianness and signedness are specified by flags

## Function Semantics

### Function Definition
Functions are first-class values that can be:
- Passed as arguments
- Returned from other functions
- Stored in data structures

### Recursion
Core Erlang supports recursion through:
- Direct recursion (function calls itself)
- Mutual recursion (functions call each other)
- Tail recursion (optimized for constant stack space)

### Closures
Functions capture their lexical environment:
- Free variables are bound at function creation time
- Nested functions have access to outer scope variables

## Primitive Operations

### Arithmetic Operations
- `+`, `-`, `*`, `/` - Basic arithmetic
- `div`, `rem` - Integer division and remainder
- `band`, `bor`, `bxor`, `bnot` - Bitwise operations

### Comparison Operations
- `==`, `/=` - Equality and inequality
- `=:=`, `=/=` - Exact equality and inequality
- `<`, `>`, `=<`, `>=` - Ordering comparisons

### Type Tests
- `is_atom/1`, `is_integer/1`, `is_float/1` - Type checking
- `is_list/1`, `is_tuple/1`, `is_binary/1` - Structure checking

### List Operations
- `hd/1`, `tl/1` - Head and tail
- `length/1` - List length
- `++/2` - List concatenation

### Tuple Operations
- `element/2` - Extract element by position
- `setelement/3` - Create new tuple with modified element
- `tuple_size/1` - Tuple size

### Binary Operations
- `binary_to_list/1` - Convert binary to list
- `list_to_binary/1` - Convert list to binary
- `bit_size/1` - Binary size in bits
- `byte_size/1` - Binary size in bytes

## Memory Management

### Garbage Collection
Core Erlang uses automatic garbage collection:
- Reference counting for immediate cleanup
- Generational garbage collection for long-term cleanup
- Process-local heaps with global shared heap

### Memory Layout
- Process heap - Local data
- Shared heap - Shared data (atoms, modules, etc.)
- Stack - Function call frames
- Message queue - Incoming messages

## Concurrency Model

### Process Model
- Lightweight processes (actors)
- No shared mutable state
- Message passing for communication
- Process isolation

### Process Lifecycle
1. Creation - `spawn/1`, `spawn_link/1`
2. Execution - Function evaluation
3. Communication - Message passing
4. Termination - Normal exit or exception

### Process Links
- Links create bidirectional relationships
- If one process dies, linked processes receive exit signals
- Used for supervision and fault tolerance

## Error Handling

### Error Types
- `function_clause` - No matching function clause
- `case_clause` - No matching case clause
- `if_clause` - No matching if clause
- `badmatch` - Pattern match failure
- `badarg` - Invalid argument to BIF
- `badarith` - Arithmetic error

### Error Propagation
- Errors propagate up the call stack
- Can be caught with try-catch
- Uncaught errors terminate the process

## Optimization Semantics

### Tail Call Optimization
- Tail-recursive calls use constant stack space
- Last expression in function body is optimized
- Enables infinite loops without stack overflow

### Inlining
- Small functions may be inlined
- Reduces function call overhead
- Improves performance for hot code paths

### Constant Folding
- Compile-time evaluation of constant expressions
- `1 + 2` becomes `3`
- Reduces runtime computation

## Type System

### Dynamic Typing
- Types are determined at runtime
- No compile-time type checking
- Pattern matching provides type safety

### Type Inference
- Compiler infers types for optimization
- Helps with code generation
- Not exposed to the programmer

### Type Annotations
- Annotations can contain type information
- Used by compiler for optimization
- Not enforced at runtime

This semantics specification provides the complete operational behavior of Core Erlang, enabling accurate implementation and understanding of the language.
