(require-library extras ports data-structures srfi-13)
(import (only extras printf))
(import (only ports with-output-to-port))
(import (only data-structures alist-ref))
(use posix)
(use args)
(use scsh-process)
(include "include/git-commands.scm")


(define opts
 (list (args:make-option (s status)    #:none     "Show Status"
         (process-statuses (string-split (git-status) "\n")))
       (args:make-option (h help)      #:none     "Display this text"
         (usage))))

(define (usage)
  (with-output-to-port (current-error-port)
    (lambda ()
      (print "Usage: " (car (argv)) " [options...] [files...]")
      (newline)
      (print (args:usage opts))))
  (exit 1))


(receive (options operands)
    (args:parse (command-line-arguments) opts) "")
