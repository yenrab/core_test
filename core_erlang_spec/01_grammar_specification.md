# Core Erlang Grammar Specification

## Overview

Core Erlang is a functional intermediate language used by the Erlang/OTP compiler. It serves as an intermediate representation between Erlang source code and BEAM bytecode. This document provides a comprehensive grammar specification for Core Erlang.

## Lexical Structure

### Character Set
Core Erlang uses the Unicode character set with UTF-8 encoding. The scanner handles ISO 8859-1 (Latin-1) characters and Unicode characters.

### Tokens

#### Keywords
```
module, attributes, do, let, in, letrec, apply, call, primop, case, of, end, 
when, fun, try, catch, receive, after
```

#### Separators
```
( ) { } [ ] | , -> = / < > : -| # ~ => :=
```

#### Literal Tokens
- `char` - Character literals (e.g., `$a`, `$\n`)
- `integer` - Integer literals (e.g., `42`, `16#FF`)
- `float` - Floating point literals (e.g., `3.14`, `1.0e-5`)
- `atom` - Atom literals (always single-quoted, e.g., `'hello'`)
- `string` - String literals (double-quoted, e.g., `"hello"`)
- `var` - Variable names (e.g., `X`, `_Var`)

#### Special Tokens
- `nil` - Empty list literal `[]`

## Grammar Rules

### Module Definition
```
module_definition ->
    'module' atom module_export module_attribute module_defs 'end'
    | '(' 'module' atom module_export module_attribute module_defs 'end' '-|' annotation ')'

module_export ->
    '[' ']'
    | '[' exported_names ']'

exported_names ->
    exported_name ',' exported_names
    | exported_name

exported_name ->
    anno_function_name

module_attribute ->
    'attributes' '[' ']'
    | 'attributes' '[' attribute_list ']'

attribute_list ->
    attribute ',' attribute_list
    | attribute

attribute ->
    anno_atom '=' anno_literal
```

### Function Definitions
```
module_defs ->
    function_definitions

function_definitions ->
    function_definition function_definitions
    | '$empty'

function_definition ->
    anno_function_name '=' anno_fun

anno_fun ->
    '(' fun_expr '-|' annotation ')'
    | fun_expr
```

### Expressions

#### Basic Expressions
```
expression ->
    '<' '>'
    | '<' anno_expressions '>'
    | single_expression

single_expression ->
    atomic_literal
    | tuple
    | cons
    | binary
    | variable
    | function_name
    | fun_literal
    | fun_expr
    | let_expr
    | letrec_expr
    | case_expr
    | receive_expr
    | application_expr
    | call_expr
    | primop_expr
    | try_expr
    | sequence
    | catch_expr
    | map_expr
```

#### Literals
```
literal ->
    atomic_literal
    | tuple_literal
    | cons_literal

atomic_literal ->
    char
    | integer
    | float
    | atom
    | string
    | nil

tuple_literal ->
    '{' '}'
    | '{' literals '}'

cons_literal ->
    '[' literal tail_literal

tail_literal ->
    ']'
    | '|' literal ']'
    | ',' literal tail_literal

fun_literal ->
    'fun' atom ':' atom '/' integer
```

#### Data Structures
```
tuple ->
    '{' '}'
    | '{' anno_expressions '}'

cons ->
    '[' anno_expression tail

tail ->
    ']'
    | '|' anno_expression ']'
    | ',' anno_expression tail

binary ->
    '#' '{' '}' '#'
    | '#' '{' segments '}' '#'

segments ->
    anno_segment ',' segments
    | anno_segment

segment ->
    '#' '<' anno_expression '>' '(' anno_expressions ')'
```

#### Maps
```
map_expr ->
    '~' '{' '}' '~'
    | '~' '{' map_pairs '}' '~'
    | '~' '{' map_pairs '|' anno_variable '}' '~'
    | '~' '{' map_pairs '|' anno_map_expr '}' '~'

map_pairs ->
    anno_map_pair
    | anno_map_pair ',' map_pairs

anno_map_pair ->
    map_pair
    | '(' map_pair '-|' annotation ')'

map_pair ->
    map_pair_assoc
    | map_pair_exact

map_pair_assoc ->
    anno_expression '=>' anno_expression

map_pair_exact ->
    anno_expression ':=' anno_expression
```

#### Control Structures
```
let_expr ->
    'let' let_vars '=' anno_expression 'in' anno_expression

letrec_expr ->
    'letrec' function_definitions 'in' anno_expression

case_expr ->
    'case' anno_expression 'of' anno_clauses 'end'

try_expr ->
    'try' anno_expression 'of' let_vars '->' anno_expression
    'catch' let_vars '->' anno_expression

sequence ->
    'do' anno_expression anno_expression

catch_expr ->
    'catch' anno_expression
```

#### Function Calls
```
application_expr ->
    'apply' anno_expression arg_list

call_expr ->
    'call' anno_expression ':' anno_expression arg_list

primop_expr ->
    'primop' anno_expression arg_list

arg_list ->
    '(' ')'
    | '(' anno_expressions ')'
```

#### Receive Expression
```
receive_expr ->
    'receive' timeout
    | 'receive' anno_clauses timeout

timeout ->
    'after' anno_expression '->' anno_expression
```

#### Function Definitions
```
fun_expr ->
    'fun' '(' ')' '->' anno_expression
    | 'fun' '(' anno_variables ')' '->' anno_expression
```

### Patterns

#### Pattern Matching
```
anno_pattern ->
    '(' other_pattern '-|' annotation ')'
    | other_pattern
    | anno_variable

other_pattern ->
    atomic_pattern
    | tuple_pattern
    | map_pattern
    | cons_pattern
    | binary_pattern
    | anno_variable '=' anno_pattern

atomic_pattern ->
    atomic_literal

tuple_pattern ->
    '{' '}'
    | '{' anno_patterns '}'

cons_pattern ->
    '[' anno_pattern tail_pattern

tail_pattern ->
    ']'
    | '|' anno_pattern ']'
    | ',' anno_pattern tail_pattern

binary_pattern ->
    '#' '{' '}' '#'
    | '#' '{' segment_patterns '}' '#'
```

#### Map Patterns
```
map_pattern ->
    '~' '{' '}' '~'
    | '~' '{' map_pair_patterns '}' '~'
    | '~' '{' map_pair_patterns '|' anno_map_expr '}' '~'

map_pair_patterns ->
    map_pair_pattern
    | map_pair_pattern ',' map_pair_patterns

map_pair_pattern ->
    anno_expression ':=' anno_pattern
    | '(' anno_expression ':=' anno_pattern '-|' annotation ')'
```

### Clauses
```
anno_clauses ->
    anno_clause anno_clauses
    | anno_clause

anno_clause ->
    clause
    | '(' clause '-|' annotation ')'

clause ->
    clause_pattern 'when' anno_expression '->' anno_expression

clause_pattern ->
    anno_pattern
    | '<' '>'
    | '<' anno_patterns '>'
```

### Variables and Annotations
```
variable ->
    var

anno_variable ->
    variable
    | '(' variable '-|' annotation ')'

anno_variables ->
    anno_variable ',' anno_variables
    | anno_variable

anno_expression ->
    expression
    | '(' expression '-|' annotation ')'

anno_expressions ->
    anno_expression ',' anno_expressions
    | anno_expression

anno_function_name ->
    function_name
    | '(' function_name '-|' annotation ')'

function_name ->
    atom '/' integer

annotation ->
    '[' ']'
    | '[' constants ']'

constants ->
    constant ',' constants
    | constant

constant ->
    atomic_constant
    | tuple_constant
    | cons_constant

atomic_constant ->
    char
    | integer
    | float
    | atom
    | string
    | nil

tuple_constant ->
    '{' '}'
    | '{' constants '}'

cons_constant ->
    '[' constant tail_constant

tail_constant ->
    ']'
    | '|' constant ']'
    | ',' constant tail_constant
```

## Grammar Notes

### Annotation System
Core Erlang supports annotations on most constructs using the `-|` syntax:
```
( expression -| annotation )
```

Annotations are lists of constants that provide metadata about the construct.

### Pattern Matching
Core Erlang uses pattern matching extensively. Patterns can be:
- Literal values
- Variables (which bind to values)
- Structured patterns (tuples, lists, maps)
- Aliases (variable = pattern)

### Guards
Guards are boolean expressions that must evaluate to `'true'` for a clause to match. They use the `when` keyword.

### Binary Syntax
Binary data is represented using the `#{}` syntax with segments that specify:
- Value
- Size
- Unit
- Type
- Flags

### Map Syntax
Maps use the `~{}` syntax with key-value pairs:
- `=>` for association (key => value)
- `:=` for exact match (key := value)

## Examples

### Simple Function
```
'factorial'/1 =
    fun (N) ->
        case N of
            <0> when 'true' -> 1
            <N> when 'true' -> 
                call 'erlang':'*'
                    (N, apply 'factorial'/1 (call 'erlang':'-' (N, 1)))
        end
```

### Message Passing
```
'receive_example'/0 =
    fun () ->
        receive
            <{Pid, Msg}> when 'true' ->
                call 'erlang':'!'
                    (Pid, {reply, Msg})
        after 5000 ->
            timeout
        end
```

### Map Operations
```
'map_example'/1 =
    fun (M) ->
        let <NewMap> = ~{M | key => value}~
        in NewMap
```

This grammar specification provides the complete syntactic structure of Core Erlang, enabling accurate parsing and generation of Core Erlang programs.
