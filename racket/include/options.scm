(define link-numb (make-parameter null))

(define cli-opts
  (command-line
   #:program "SCMBAG"
   #:once-each 
    [("-s" "--status") "Show Status"
     (show-status)]
  
    [("-a" "--add") numb "Add Files 1 2 3 .."
     (add-files (cons numb (link-numb)))]

   ;; (args:make-option
   ;;  (i install) #:none "Create aliases and source into ~/.bash_profile"
   ;;  (init-aliases))

   ;; (args:make-option
   ;;  (d diff) #:none "Git diff 1 3 4 .."
   ;;  (git-diff (cdr (command-line-arguments))))

   ;; (args:make-option
   ;;  (c commit-msg) #:none "Commit with message."
   ;;  (commit))

   ;; (args:make-option
   ;;  (r reset) #:none "Git reset 1 3 4 .."
   ;;  (git-reset (cdr (command-line-arguments))))

   ;; (args:make-option
   ;;  (o checkout) (required: "NUMBERS")     "Git checkout .."
   ;;  (git-checkout (cdr (command-line-arguments))))

   ;; (args:make-option
   ;;  (x rm) (required: "NUMBERS")      "Delete (rm) files 1 2 3 .."
   ;;  (rm-files (cdr (command-line-arguments))))

   ;; (args:make-option
   ;;  (m commit-all) #:none "Adds all commit all files including untracked."
   ;;  (commit-all))

   ;; (args:make-option
   ;;  (l show-alias) #:none "Show all aliases."
   ;;  (show-alias))

   ;; (args:make-option
   ;;  (ignore) (required: "NUMBER") "Git Ignore"
   ;;  (git-ignore (cdr (command-line-arguments))))

   ;; (args:make-option
   ;;  (h help) #:none "Display this text"
   ;;  (usage))
   ))

;; (define (usage)
  ;; (display (current-error-port)
    ;; (lambda ()
      ;; (print "Usage: " (car (argv)) " [options...] [files...]")
      ;; (newline)
      ;; (print (args:usage cli-opts))))
  ;; (exit 1))


;;TODO 
;; Move this todo to markdown checklist todo.
;; Add files to gitignore through file ranges 1-4 
;; Ability to specify files status in range 1-4 2-3 4-6
;; Git checkout branch using gcob branch number aswell as gco 'branch-name'
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
;; git commit of a file in a range shows last n commits for a file in range n-m
;;i.e 'git log --graph -L 1,10:scmbag.scm' shows first 10 commits for scmbag.scm


