(define range
  (lambda (n m)
    (cond
      ((= n m) (list n))
        (else (cons n (range ((if (< n m) + -) n 1) m))))))
