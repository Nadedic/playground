(require rackunit rackunit/text-ui)
(load-relative "../../support/eopl.scm")
(load-relative "../41.scm")
(load-relative "helpers/nameless.scm")

(define eopl-3.41-tests
  (test-suite
    "Tests for EOPL exercise 3.41"

    (check-equal? (run "42") 42)

    (check-equal? (run "% Comment\n 1") 1)

    (check-equal? (run "zero?(0)") #t)
    (check-equal? (run "zero?(1)") #f)

    (check-equal? (run "if zero?(0) then 1 else 2") 1)
    (check-equal? (run "if zero?(3) then 1 else 2") 2)

    (check-equal? (run "let x = 1 in x") 1)
    (check-equal? (run "let x = 1 in let x = 2 in x") 2)
    (check-equal? (run "let x = 1 in let y = 2 in x") 1)

    (check-equal? (run "let x = 7                  % This is a comment
                        in let y = 2               % This is another comment
                           in let y = let x = -(x, 1) in -(x, y)
                              in -(-(x, 8),y)")
                  -5)

    (check-equal? (run "let f = proc (x) -(x, 11)
                        in (f (f 77))")
                  55)

    (check-equal? (run "(proc (f) (f (f 77))
                         proc (x) -(x, 11))")
                  55)

    (check-equal? (run "let x = 200
                        in let f = proc (z) -(z, x)
                           in let x = 100
                              in let g = proc (z) -(z, x)
                                 in -((f 1), (g 1))")
                  -100)

    (check-equal? (run "let one = 1
                            six = 6
                        in -(six, one)")
                  5)
    (check-equal? (run "let one = proc () 1
                            in (one)")
                  1)
    (check-equal? (run "let minus = proc (x y) -(x, y)
                            in (minus 7 2)")
                  5)
))

(exit (run-tests eopl-3.41-tests))
