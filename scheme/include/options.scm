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
    (h help) #:none "Display this text"
    (usage))))


(define color-defs
  '((:esc "\x1b[0")
    (:sep ";")
    (:tail "m")
    (:staged "33m")
    (:deleted "31m")
    (:modified "32m")
    (:untracked "36m")
    (:modified-after-staging "35m")))

(define status-msg-list
  '(("??" :untracked)
    (" M" :modified :unstaged)
    ("M " :modified :staged)
    ("MM" :modified-after-staging "<= commit or stage it again.")))

(define (find-msg-list status)
  (find (lambda (id) (member status id)) status-msg-list))

(define (get-status-msg status-pair number)
  (let [[status (car status-pair)] [file (cdr status-pair)]]
    (let [[msg-list (find-msg-list status)]]
      (cond
       ((list? msg-list) (list number msg-list file))
       (else (list status number file))))))

;;TODO show staged file
;; Seperate status as separate staged, unstaged and untracked files. with
;; colored outputs. as Folows :
;; # Changes to be committed
;; # Changes Not Staged for commit.
;; # Untracked files
;; Ability to specify files status in range 1-4 2-3 4-6
;; Git branch using gb, Git checkout using gco 1, 2 3
;; Git branch gb shows all numbered branches and if given a
;; option i.e 'gb new_branch' should create a new branch.
;; Git checkout/switch to a  branch gcb using [branch number] i.e 1 , 2 ...
;; make rm a general purpose command not just git status
;; and make rm work with ls (File list) not gs (Git file list)
;; Add a grm (git rm functionality.
