(define (ascending? s)
  (cond 
    ((or (null? s) (null? (cdr s))) #t)
    ((> (car s) (car (cdr s))) #f)
    (else (ascending? (cdr s)))))

(define (my-filter pred s)
  (cond 
    ((null? s) '())
    ((pred (car s)) (cons (car s) (my-filter pred (cdr s))))
    (else (my-filter pred (cdr s)))))

(define (interleave lst1 lst2)
  (cond 
    ((null? lst1) lst2)
    ((null? lst2) lst1)
    (else (cons (car lst1)
                (cons (car lst2)
                      (interleave (cdr lst1) (cdr lst2)))))))

; filepath: /d:/cs61a/hw/hw08/hw08.scm
(define (no-repeats s)
  (if (null? s) 
      '()
      (cons (car s)
            (no-repeats (my-filter (lambda (x) (not (= x (car s))))
                                  (cdr s))))))
