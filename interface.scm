(load "compiler.scm")
(import (rnrs io ports (6)))

(define *regexp* "\\%\\{([^}]*)\\}\\%")

(define (find-scheme-expr str)
  (let ((expr (match:substring (string-match *regexp* str))))
    (read (open-input-string (substring expr 2 (- (string-length expr) 2))))))

(define (replace str rx item)
  (let ((interval (vector-ref (string-match rx str) 1)))
    (string-append (substring str 0 (car interval))
                   item
                   (substring str (cdr interval) (string-length str)))))

(define (replace-global str rx proc)
  (let loop ((s str))
    (if (string-contains s "%{")
        (loop (replace s rx (proc s))) s)))

(define (compile-string str) 
  (replace-global str *regexp* 
                  (lambda (x) (compile-template (find-scheme-expr x)))))

(define (compile-file file) 
  (replace-global (get-string-all (open-input-file file)) *regexp* 
                  (lambda (x) (compile-template (find-scheme-expr x)))))

(define (generate-html input output)
  (display (compile-file input) (open-output-file output)))
