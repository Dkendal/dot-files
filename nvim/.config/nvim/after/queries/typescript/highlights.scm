("delete") @keyword

((call_expression
    function: (_) @keyword
    arguments: (arguments ((string) @GruvBoxGreenSign)))
  (#eq? @keyword "describe"))

((call_expression
    function: (_) @keyword
    arguments: (arguments ((string) @GruvBoxGreenSign)))
  (#eq? @keyword "test"))

((call_expression
    function: (member_expression
               object: _ @keyword
               property: _ @GruvBoxBlueSign) @call
    arguments: (arguments ((string) @GruvBoxGreenSign)))
  (#eq? @call "test.todo"))

((call_expression
    function: (member_expression
               object: _ @keyword
               property: _ @GruvBoxBlueSign) @call
    arguments: (arguments ((string) @GruvBoxGreenSign)))
  (#eq? @call "test.skip"))

((call_expression
    function: (member_expression
               object: _ @keyword
               property: _ @GruvBoxOrangeSign) @call
    arguments: (arguments ((string) @GruvBoxGreenSign)))
  (#eq? @call "test.only"))

; (
;   (call_expression
;       function:
;         [
;           (identifier) @keyword
;           (member_expression
;             object: (identifier) @keyword
;             property: (property_identifier) @capture)
;         ]
;       arguments: (arguments ((string) @GruvBoxGreenSign)))
;     (#eq? @keyword "test")
; )
