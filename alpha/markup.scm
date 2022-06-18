(define *tags*
  '(h1 h2 h3 h4 h5 h6 b i u html p table caption
    tr th td q blockquote details summary head body code pre))

(define (atom? x) (or (string? x) (symbol? x) (number? x)))
(define (block? expr) (member (car expr) *tags*))
(define (template? expr) (equal? (car expr) '%))

(define (compile expr)
  (cond ((atom? expr) (compile-atom expr))
        ((block? expr) (compile-block (car expr) (cdr expr)))
        ((template? expr) (compile-template (cadr expr)))
        (else (compile-sentence expr))))

(define (compile-atom expr)
  (cond ((symbol? expr) (symbol->string expr))
        ((number? expr) (number->string expr))
        ((string? expr) expr)
        (else (error "Wrong kind of atom"))))

(define (compile-block tag body)
  (let ((tag-begin (string-append "<" (symbol->string tag) ">"))
        (tag-end (string-append "</" (symbol->string tag) ">")))
    (string-append tag-begin (compile-sentence body) tag-end)))

(define (compile-sentence expr)
  (let loop ((acc "") (e expr))
    (cond ((null? e) acc)
          ((= 1 (length e))
           (loop (string-append acc (compile (car e))) (cdr e)))
          (else (loop (string-append acc (compile (car e)) " ") (cdr e))))))

(define (compile-template expr)
  (compile (eval expr (interaction-environment))))

