(import (rnrs hashtables (6)))

;; General procedures for dealing with counters. Inspired by LaTeX.
(define *counters* (make-eq-hashtable))
(define (make-counter! name start) (hashtable-set! *counters* name start))
(define (counter-ref counter) 
  (hashtable-ref *counters* counter "COUNTER-REF: counter not found."))

(define (reset-counter! counter) (hashtable-set! *counters* counter 0))

(define (step-counter! counter) 
  (hashtable-set! *counters* counter (1+ (counter-ref counter))))

; Example definition counter.
(make-counter! 'Definition  0)
(define (Definition body) 
  (step-counter! 'Definition)
  `(p (b ,(string-append 
            "Definition " 
            (number->string (counter-ref 'Definition)) "."))
      ,body))
