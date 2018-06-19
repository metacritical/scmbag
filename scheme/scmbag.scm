(require-library extras ports data-structures srfi-13 files)
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
   (args:make-option
    (s status) #:none "Show Status"
    (show-status))

   (args:make-option
    (a add) (required: "NUMBERS ") "Add Files 1 2 3 .."
    (add-files (cdr (command-line-arguments))))

   (args:make-option
    (i install) #:none "Create aliases and source into ~/.bash_profile"
    (init-aliases))

   (args:make-option
    (d diff) #:none "Git diff 1 3 4 .."
    (git-diff (cdr (command-line-arguments))))

   (args:make-option
    (c commit-msg) #:none "Commit with message."
    (commit))

   (args:make-option
    (r reset) #:none "Git reset 1 3 4 .."
    (git-reset (cdr (command-line-arguments))))

   (args:make-option
    (o checkout) (required: "NUMBERS")     "Git checkout .."
    (git-checkout (cdr (command-line-arguments))))

   (args:make-option
    (x rm) (required: "NUMBERS")      "Delete (rm) files 1 2 3 .."
    (rm-files (cdr (command-line-arguments))))

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
;; Ability to specify files status in range 1-4 2-3 4-6
;; Git branch using gb, Git checkout using gco 1, 2 3
;; Git branch gb shows all numbered branches and if given a
;; option i.e 'gb new_branch' should create a new branch.
;; Git checkout/switch to a  branch gcb using [branch number] i.e 1 , 2 ...
