# Stem, a Semantic Templating Engine

What do I mean by a *semantic* templating engine? In most templating engines
you usually write code something like this:
```
# Hi
% # This is a comment
% if user == "Bruno"
  {{user}} rhymes with Piano
% elsif user == "Brutus"
  {{user}} rhymes with Opus
% end

<?
  # Multiline code evaluation
  lucky = [1, 3, 7, 9, 13, 15]
  prime = [2, 3, 5, 7, 11, 13]
?>

{{ lucky & prime }}
```
In here the code to be placed inside the file is represented with *strings*, and
strings are rather hard to work with. XML is a tree, and strings are 
one-dimensional arrays, not a perfect match. Stem instead uses scheme s-exprs
(which are trees) to represent and generate xml code. As such it preserves the
meaning of the xml and gives you full power to do any sort of code generation
that you want. This is a short example:
```
# Hi
%{
(let loop ((table '()) (v '("hello" (b "hi") (i "sup"))) (row 1))
  (if (null? v) table
      (loop (append table (list `(tr (td ,row)
                                     (td ,row)
                                     (td ,(car v)))))
            (cdr v) (+ 1 row)))))
%}
```

Did I do a good job at making it sound pretentious? Well in reality this isn't 
really that much better than the snippet I showed you above. That's from
[mote](https://github.com/soveran/mote) which is a nice templating engine 
that's a whole (infurating) 10 lines shorter than stem, mostly because stem 
compiles [sxml](https://www.gnu.org/software/guile/manual/html_node/SXML.html)
into xml while mote doesn't. Regardless I still think stem is easier to reason 
about but it's not really *that* much better.

**Supported implementations.** For now only guile, but I'll eventually make it
R6RS compatible. The only part that isn't as of now is the regex part but 
that'll probably devolve into it's own project of making a fast implementation
of [SRFI 115](https://srfi.schemers.org/srfi-115/srfi-115.html) by using Ken 
Thompson's technique as described in 
[Russ Cox's nice article](https://swtch.com/~rsc/regexp/regexp1.html)
