(define cli-opts
  (let* [[args (current-command-line-arguments)]]
         (unless (vector-empty? args)
                 (let* [[flag (vector-ref args 0)]
                        [flag-args (vector-drop args 1)]]

                   
       (case flag
         [(or "-s" "--status") (show-status)]
         [(or "-a" "--add") (add-files flag-args)]
         [(or "-d" "--diff") (git-diff flag-args)]
         [(or "-o" "--checkout") (git-checkout flag-args)]
         [(or "-c" "--commit-msg") (commit)]
         [(or "-m" "--commit-all") (commit-all)]
         [(or "-r" "--reset") (git-reset flag-args)])
       
       ;; (args:make-option ;;DONE
       ;;  (i install) #:none "Create aliases and source into ~/.bash_profile"
       ;;  (init-aliases))

       ;; (args:make-option ;;DONE
       ;;  (d diff) #:none "Git diff 1 3 4 .."
       ;;  (git-diff (cdr (command-line-arguments))))

       ;; (args:make-option ;;Done
       ;;  (c commit-msg) #:none "Commit with message."
       ;;  (commit))

       ;; (args:make-option ;;Done
       ;;  (r reset) #:none "Git reset 1 3 4 .."
       ;;  (git-reset (cdr (command-line-arguments))))

       ;; (args:make-option ;;Done
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
       ))))

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


