(require-library extras ports data-structures srfi-13)
(import (only extras printf))
(import (only ports with-output-to-port))
(import (only data-structures alist-ref string-split))
(use posix)
(use args)
(use scsh-process)
(include "include/git.scm")
(include "include/init.scm")

(define opts
  (list
   (args:make-option (s status) #:none "Show Status" (show-status))

   (args:make-option
    (a add) (required: "STAT_NUMBERS ") "Add Files 1 2 3 .."
    (add-files (cdr (command-line-arguments))))

   (args:make-option
    (i install) #:none "Create aliases and source into ~/.bash_profile"
    (init-aliases))

   (args:make-option
    (d diff) #:none "Code diff 1 3 4 .."
    (git-diff (cdr (command-line-arguments))))

   (args:make-option
    (c commit-message) #:none "Commit with message."
    (commit))

   (args:make-option
    (h help) #:none "Display this text"
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

;;TODO show staged file
;; git reset 'grs 1 2 3' or 'grs' for complete reset. Also diff of staged files
;; Add gcm (Git commit Message)
