# Core Erlang AST Node Specifications

## Overview

Core Erlang uses a record-based Abstract Syntax Tree (AST) representation. Each node type is defined as an Erlang record with specific fields. All nodes share a common annotation field as the first element.

## Common Structure

All AST nodes follow this pattern:
```erlang
-record(node_type, {anno=[] :: list(), field1 :: type1, field2 :: type2, ...}).
```

The `anno` field contains metadata annotations and is always the first field in every node type.

## Node Types

### 1. Module Definition

#### c_module
```erlang
-record(c_module, {
    anno=[] :: list(),
    name :: cerl:cerl(),
    exports :: [cerl:cerl()],
    attrs :: [{cerl:cerl(), cerl:cerl()}],
    defs :: [{cerl:cerl(), cerl:cerl()}]
}).
```

**Fields:**
- `name`: Module name (atom literal)
- `exports`: List of exported function names
- `attrs`: Module attributes as key-value pairs
- `defs`: Function definitions as name-function pairs

**Example:**
```erlang
#c_module{
    name = #c_literal{val = 'my_module'},
    exports = [#c_var{name = {'factorial', 1}}],
    attrs = [],
    defs = [{{#c_var{name = {'factorial', 1}}, #c_fun{...}}]
}
```

### 2. Literal Values

#### c_literal
```erlang
-record(c_literal, {
    anno=[] :: list(),
    val :: any()
}).
```

**Fields:**
- `val`: The literal value (atom, integer, float, string, list, tuple, etc.)

**Example:**
```erlang
#c_literal{val = 42}
#c_literal{val = 'hello'}
#c_literal{val = [1, 2, 3]}
```

### 3. Variables

#### c_var
```erlang
-record(c_var, {
    anno=[] :: list(),
    name :: cerl:var_name()
}).
```

**Fields:**
- `name`: Variable name (atom or integer)

**Example:**
```erlang
#c_var{name = 'X'}
#c_var{name = 0}  % Generated variable
```

### 4. Data Structures

#### c_tuple
```erlang
-record(c_tuple, {
    anno=[] :: list(),
    es :: [cerl:cerl()]
}).
```

**Fields:**
- `es`: List of expressions forming the tuple elements

**Example:**
```erlang
#c_tuple{es = [#c_literal{val = 1}, #c_literal{val = 2}]}
```

#### c_cons
```erlang
-record(c_cons, {
    anno=[] :: list(),
    hd :: cerl:cerl(),
    tl :: cerl:cerl()
}).
```

**Fields:**
- `hd`: Head element
- `tl`: Tail (rest of the list)

**Example:**
```erlang
#c_cons{
    hd = #c_literal{val = 1},
    tl = #c_literal{val = [2, 3]}
}
```

#### c_binary
```erlang
-record(c_binary, {
    anno=[] :: list(),
    segments :: [cerl:c_bitstr()]
}).
```

**Fields:**
- `segments`: List of binary segments

**Example:**
```erlang
#c_binary{
    segments = [
        #c_bitstr{
            val = #c_literal{val = 65},
            size = #c_literal{val = 8},
            unit = #c_literal{val = 1},
            type = #c_literal{val = integer},
            flags = #c_literal{val = [unsigned, big]}
        }
    ]
}
```

#### c_bitstr
```erlang
-record(c_bitstr, {
    anno=[] :: list(),
    val :: cerl:cerl(),
    size :: cerl:cerl(),
    unit :: cerl:cerl(),
    type :: cerl:cerl(),
    flags :: cerl:cerl()
}).
```

**Fields:**
- `val`: Value to be stored in the segment
- `size`: Size in units
- `unit`: Unit size in bits
- `type`: Data type (integer, float, binary, etc.)
- `flags`: Endianness and signedness flags

### 5. Maps

#### c_map
```erlang
-record(c_map, {
    anno=[] :: list(),
    arg=#c_literal{val=#{}} :: cerl:c_var() | cerl:c_literal(),
    es :: [cerl:c_map_pair()],
    is_pat=false :: boolean()
}).
```

**Fields:**
- `arg`: Base map (for updates) or empty map literal
- `es`: List of map pairs
- `is_pat`: Whether this is a pattern (for matching)

**Example:**
```erlang
#c_map{
    arg = #c_literal{val = #{}},
    es = [
        #c_map_pair{
            op = #c_literal{val = assoc},
            key = #c_literal{val = 'key'},
            val = #c_literal{val = 'value'}
        }
    ]
}
```

#### c_map_pair
```erlang
-record(c_map_pair, {
    anno=[] :: list(),
    op :: #c_literal{val::'assoc'} | #c_literal{val::'exact'},
    key :: any(),
    val :: any()
}).
```

**Fields:**
- `op`: Operation type (assoc for association, exact for exact match)
- `key`: Map key
- `val`: Map value

### 6. Functions

#### c_fun
```erlang
-record(c_fun, {
    anno=[] :: list(),
    vars :: [cerl:cerl()],
    body :: cerl:cerl()
}).
```

**Fields:**
- `vars`: Function parameters
- `body`: Function body expression

**Example:**
```erlang
#c_fun{
    vars = [#c_var{name = 'X'}],
    body = #c_case{
        arg = #c_var{name = 'X'},
        clauses = [
            #c_clause{
                pats = [#c_literal{val = 0}],
                guard = #c_literal{val = 'true'},
                body = #c_literal{val = 1}
            }
        ]
    }
}
```

### 7. Control Structures

#### c_case
```erlang
-record(c_case, {
    anno=[] :: list(),
    arg :: cerl:cerl(),
    clauses :: [cerl:cerl()]
}).
```

**Fields:**
- `arg`: Expression to match against
- `clauses`: List of case clauses

#### c_clause
```erlang
-record(c_clause, {
    anno=[] :: list(),
    pats :: [cerl:cerl()],
    guard :: cerl:cerl(),
    body :: cerl:cerl()
}).
```

**Fields:**
- `pats`: Pattern list to match
- `guard`: Guard expression (must evaluate to 'true')
- `body`: Expression to execute if pattern matches and guard succeeds

#### c_let
```erlang
-record(c_let, {
    anno=[] :: list(),
    vars :: [cerl:cerl()],
    arg :: cerl:cerl(),
    body :: cerl:cerl()
}).
```

**Fields:**
- `vars`: Variables to bind
- `arg`: Expression to evaluate
- `body`: Expression to evaluate with bound variables

#### c_letrec
```erlang
-record(c_letrec, {
    anno=[] :: list(),
    defs :: [{cerl:cerl(), cerl:cerl()}],
    body :: cerl:cerl()
}).
```

**Fields:**
- `defs`: Recursive function definitions
- `body`: Expression to evaluate with recursive functions in scope

#### c_seq
```erlang
-record(c_seq, {
    anno=[] :: list(),
    arg :: cerl:cerl(),
    body :: cerl:cerl()
}).
```

**Fields:**
- `arg`: First expression to evaluate
- `body`: Second expression to evaluate

### 8. Function Calls

#### c_apply
```erlang
-record(c_apply, {
    anno=[] :: list(),
    op :: cerl:cerl(),
    args :: [cerl:cerl()]
}).
```

**Fields:**
- `op`: Function to apply
- `args`: Arguments to the function

#### c_call
```erlang
-record(c_call, {
    anno=[] :: list(),
    module :: cerl:cerl(),
    name :: cerl:cerl(),
    args :: [cerl:cerl()]
}).
```

**Fields:**
- `module`: Module name
- `name`: Function name
- `args`: Function arguments

#### c_primop
```erlang
-record(c_primop, {
    anno=[] :: list(),
    name :: cerl:cerl(),
    args :: [cerl:cerl()]
}).
```

**Fields:**
- `name`: Primitive operation name
- `args`: Operation arguments

### 9. Exception Handling

#### c_try
```erlang
-record(c_try, {
    anno=[] :: list(),
    arg :: cerl:cerl(),
    vars :: [cerl:cerl()],
    body :: cerl:cerl(),
    evars :: [cerl:cerl()],
    handler :: cerl:cerl()
}).
```

**Fields:**
- `arg`: Expression to try
- `vars`: Variables to bind on success
- `body`: Expression to evaluate on success
- `evars`: Exception variables to bind on failure
- `handler`: Exception handler expression

#### c_catch
```erlang
-record(c_catch, {
    anno=[] :: list(),
    body :: cerl:cerl()
}).
```

**Fields:**
- `body`: Expression to catch exceptions from

### 10. Message Passing

#### c_receive
```erlang
-record(c_receive, {
    anno=[] :: list(),
    clauses :: [cerl:cerl()],
    timeout :: cerl:cerl(),
    action :: cerl:cerl()
}).
```

**Fields:**
- `clauses`: Message pattern clauses
- `timeout`: Timeout expression
- `action`: Action to take on timeout

### 11. Pattern Matching

#### c_alias
```erlang
-record(c_alias, {
    anno=[] :: list(),
    var :: cerl:cerl(),
    pat :: cerl:cerl()
}).
```

**Fields:**
- `var`: Variable to bind
- `pat`: Pattern to match against

### 12. Multiple Values

#### c_values
```erlang
-record(c_values, {
    anno=[] :: list(),
    es :: [cerl:cerl()]
}).
```

**Fields:**
- `es`: List of expressions to return as multiple values

### 13. Opaque Values

#### c_opaque
```erlang
-record(c_opaque, {
    anno=[] :: list(),
    val :: any()
}).
```

**Fields:**
- `val`: Opaque value (implementation-specific)

## Type Definitions

### cerl() Union Type
```erlang
-type cerl() :: c_alias()  | c_apply()  | c_binary()  | c_bitstr()
              | c_call()   | c_case()   | c_catch()   | c_clause()  | c_cons()
              | c_fun()    | c_let()    | c_letrec()  | c_literal()
              | c_map()    | c_map_pair()
              | c_module() | c_opaque()
              | c_primop() | c_receive() | c_seq()
              | c_try()    | c_tuple()  | c_values()  | c_var().
```

### Variable Name Type
```erlang
-type var_name() :: integer() | atom() | {atom(), integer()}.
```

## Annotation System

Annotations are lists that can contain:
- Line numbers (integers)
- File information (tuples)
- Compiler-generated markers (atoms)
- Custom metadata (any term)

**Example annotations:**
```erlang
[42]  % Line number
[{file, "module.erl"}]  % File information
['compiler_generated']  % Compiler marker
[42, {file, "module.erl"}, 'compiler_generated']  % Combined
```

## Node Construction Helpers

The `cerl` module provides helper functions for constructing nodes:

```erlang
% Create literal
cerl:c_literal(42)

% Create variable
cerl:c_var('X')

% Create tuple
cerl:c_tuple([cerl:c_literal(1), cerl:c_literal(2)])

% Create function call
cerl:c_call(cerl:c_literal('erlang'), cerl:c_literal('+'), 
           [cerl:c_literal(1), cerl:c_literal(2)])

% Add annotations
cerl:set_ann(Node, [42, {file, "test.erl"}])
```

## Pattern Matching Examples

### Simple Pattern
```erlang
#c_clause{
    pats = [#c_literal{val = 0}],
    guard = #c_literal{val = 'true'},
    body = #c_literal{val = 1}
}
```

### Tuple Pattern
```erlang
#c_clause{
    pats = [#c_tuple{es = [#c_literal{val = 'ok'}, #c_var{name = 'Result'}]}],
    guard = #c_literal{val = 'true'},
    body = #c_var{name = 'Result'}
}
```

### List Pattern
```erlang
#c_clause{
    pats = [#c_cons{
        hd = #c_var{name = 'H'},
        tl = #c_var{name = 'T'}
    }],
    guard = #c_literal{val = 'true'},
    body = #c_var{name = 'H'}
}
```

### Map Pattern
```erlang
#c_clause{
    pats = [#c_map{
        es = [#c_map_pair{
            op = #c_literal{val = exact},
            key = #c_literal{val = 'status'},
            val = #c_literal{val = 'ok'}
        }]
    }],
    guard = #c_literal{val = 'true'},
    body = #c_literal{val = 'success'}
}
```

This specification provides complete details about all Core Erlang AST node types, their fields, and usage patterns.
