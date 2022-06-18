(define (block? expr) (symbol? (car expr)))
(define (tagged-block? expr)
  (and (block? expr) (if (list? (cadr expr)) (eq? (caadr expr) '@) #f)))

(define (compile expr)
  (cond ((string? expr) expr)
        ((tagged-block? expr) (compile-block (car expr) (cadr expr) (cddr expr)))
        ((block? expr) (compile-block (car expr) '(@) (cdr expr)))
        (else (compile-sentence expr))))

(define (compile-tag tag-info)
  (if (null? tag-info) ""
      (let ((var (symbol->string (caar tag-info))) 
            (val (string-append "\"" (cadar tag-info) "\"")))
        (string-append " " var "=" val (compile-tag (cdr tag-info))))))

(define (compile-block block tag body)
  (let* ((tag-data (compile-tag (cdr tag)))
         (tag-begin (string-append "<" (symbol->string block) tag-data ">"))
         (tag-end (string-append "</" (symbol->string block) ">")))
    (string-append tag-begin (compile-sentence body) tag-end)))

(define (compile-sentence expr)
  (let loop ((acc "") (e expr))
    (cond ((null? e) acc)
          ((= 1 (length e))
           (loop (string-append acc (compile (car e))) (cdr e)))
          (else (loop (string-append acc (compile (car e)) " ") (cdr e))))))

(define (compile-template expr)
  (compile (eval expr (interaction-environment))))
