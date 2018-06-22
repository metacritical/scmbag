(define cli-opts
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
    (m commit-all) #:none "Adds all commit all files including untracked."
    (commit-all))

   (args:make-option
    (h help) #:none "Display this text"
    (usage))))

(define (find-alist sym alist)
  (find (lambda (id) (member sym id)) alist))

(define color-defs
  '((:esc "\x1b[0")
   (:sep ";")
   (:tail "m")
   (:staged "33m")
   (:deleted "31m")
   (:changes "\x1b[38;5;93m")
   (:line-sep "37m")
   (:unstaged "32m")
   (:untracked "36m")
   (:mod-staged "35m")))

(define (get-color sym)
  (last (find-alist sym color-defs)))

(define (color name msg)
  (string-append (get-color ':esc)(get-color ':sep)(get-color name) msg
   (get-color ':esc)(get-color ':tail)))

(define line-seperator "#       ")

(define header-msg
  '((:staged "➤ Changes to be committed")
    (:unstaged "➤ Changes not staged for commit")
    (:untracked "➤ Untracked files")))

(define (get-header-msg sym)
  (let [[header (find-alist sym header-msg)]]
    (last header)))

(define (mod-stat status)
  (cond
   ((string=? "mod-staged" status) " <= Re-stage or commit this file")
   (else "")))

(define (colorify stat sym)
  (cond
   ((string=? "   deleted" stat) (color ':deleted stat))
   (else (color sym stat))))

(define status-list
  '(("??" \ untracked :untracked)
    (" M" \ \ modified :unstaged)
    ("M " \ \ modified :staged)
    (" D" \ \ \ deleted :unstaged)
    ("D " \ \ \ deleted :staged)
    ("R " \ \ renamed :staged)
    ("MM" mod-staged :mod-staged)))

;;TODO 
;; Ability to specify files status in range 1-4 2-3 4-6
;; Git branch using gb
;; Git branch gb shows all numbered branches and if given a
;; option i.e 'gb new_branch' should create a new branch.
;; Git checkout/switch to a  branch gcb using [branch number] i.e 1 , 2 ...
;; make rm a general purpose command not just git status
;; and make rm work with ls (File list) not gs (Git file list)
;; Add a grm (git rm functionality.
;; rm should be configurable through RM_CONFIRM=true or false or 0 /1 
;; if yes only then the confirm dialogue should appear other wise it
;; it shuould directly delete the specified file.

