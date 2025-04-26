; procedures
(procedure_declaration
  (_
    (block
      .
      "{"
      .
      (_) @_start @_end
      (_)? @_end
      .
      "}"
      (#make-range! "function.inner" @_start @_end)))) @function.outer

; returns
(return_statement
  (_)? @return.inner) @return.outer

; call function in module
(member_expression
  (call_expression)) @call.outer

; plain call
((_
  (call_expression) @call.outer) @_parent
  (#not-kind-eq? @_parent "member_expression"))

; call arguments
((call_expression
  function: (_)
  .
  argument: (_) @_first
  argument: (_) @_last .)
  (#make-range! "call.inner" @_first @_last))

; block
(block
  .
  "{"
  .
  (_) @_start @_end
  (_)? @_end
  .
  "}"
  (#make-range! "block.inner" @_start @_end)) @block.outer

; classes
(struct_declaration
  .
  (identifier)
  .
  (tag)*
  .
  "{"
  .
  (_) @_first @_last
  (_)?
  "," @_last
  .
  "}"
  (#make-range! "class.inner" @_first @_last)) @class.outer

(union_declaration
  .
  (identifier)
  .
  (tag)*
  .
  "{"
  .
  (_) @_first @_last
  (_)?
  "," @_last
  .
  "}"
  (#make-range! "class.inner" @_first @_last)) @class.outer

(enum_declaration
  .
  (identifier)
  .
  (tag)*
  .
  "{"
  .
  (_) @_first @_last
  (_)?
  "," @_last
  .
  "}"
  (#make-range! "class.inner" @_first @_last)) @class.outer

; comments
(comment) @comment.outer

(block_comment) @comment.outer

; assignment
; works also for multiple targets in lhs. ex. 'res, ok := get_res()'

(assignment_statement
  . (_) @_first @assignment.lhs
   (_)? @_prelast .
  (_) @assignment.rhs @assignment.inner 
  .
  (#make-range! "assignment.lhs" @_first @_prelast)) @assignment.outer

;
; ((assignment_statement
;   .
;   (_) @_first @assignment.lhs
;   (_)? @_prelast
;   .
;   (expression (_)) @assignment.rhs @assignment.inner )
;
;   (#make-range! "assignment.lhs" @_first @_prelast)) @assignment.outer
;
; attribute
(attribute
  (_) @attribute.inner) @attribute.outer



((enum_declaration 
   . 
   (identifier) ;@name
   .
   (identifier) @assignment.lhs
   [(number) (float) (string) (character) (boolean)( escape_sequence)] @val @assignment.rhs @assignment.inner
   )
 )


((variable_declaration 
   .
   (identifier) @_first
   (identifier)? @_last
   .
   [(number) (float) (string) (character) (boolean)( escape_sequence)] @first @assignment.rhs  @assignment.inner
   [(number) (float) (string) (character) (boolean)( escape_sequence)]? @last
   .
   ) 
 (#make-range! "assignment.lhs" @_first @_last)
 (#make-range! "assignment.rhs" @first @last)
 (#make-range! "assignment.inner" @first @last)
 ) @assignment.outer




((var_declaration 
   . 
   (_) @_first
   (_)? @_last
   .
   (type) @type
   .
   (_) @first  @assignment.rhs  @assignment.inner
   (_)? @last
   .
   ) 
 (#make-range! "assignment.lhs" @_first @type)
 (#make-range! "assignment.rhs" @first @last)
 (#make-range! "assignment.inner" @first @last)
 ) @assignment.outer

; number
(number) @number.inner

; parameters
((parameters
  "," @_start
  .
  (parameter) @parameter.inner)
  (#make-range! "parameter.outer" @_start @parameter.inner))

((parameters
  .
  (parameter) @parameter.inner
  .
  ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

((call_expression
  function: (_)
  "," @_start
  .
  argument: (_) @parameter.inner)
  (#make-range! "parameter.outer" @_start @parameter.inner))

((call_expression
  function: (_)
  .
  argument: (_) @parameter.inner
  .
  ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))
