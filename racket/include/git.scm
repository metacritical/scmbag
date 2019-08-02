(define (exec-system command)
  (with-output-to-string (lambda () (system command))))

(define (git-status)
  (exec-system "git status --short --untracked"))
(define status-hash (make-hash))
(define sorted-status (make-hash))
(define staged (make-hash))
(define unstaged (make-hash))
(define untracked (make-hash))

(hash-set! sorted-status "staged" staged)
(hash-set! sorted-status "unstaged" unstaged)
(hash-set! sorted-status "untracked" untracked)

(define (find-alist sym alist)
  (filter (lambda (id) (member sym id)) alist))

(define line-seperator "\n#    ")

(define color-defs
  '(("esc" "\x1b[0")
   ("sep" ";")
   ("tail" "m")
   ("head" "37m")
   ("staged" "33m")
   ("deleted" "31m")
   ("changes" "\x1b[38;5;93m")
   ("unstaged" "32m")
   ("untracked" "36m")
   ("mod-staged" "35m")))

(define (get-color sym)
  (last (last (find-alist sym color-defs))))

(define (color name msg)
  (string-append (get-color "esc")(get-color "sep")(get-color name) msg
   (get-color "esc")(get-color "tail")))

(define status-list
  '(("??" \ untracked "untracked")
    (" M" \ \ modified "unstaged")
    ("A " \ new\ file "staged")
    ("M " \ modified "staged")
    (" D" \ \ \ deleted "unstaged")
    ("D " \ \ deleted "staged")
    ("R " \ \ renamed "staged")
    ("MM" mod-staged "mod-staged")))

(define header-msg
  '(("staged" "➤ Changes to be committed")
    ("unstaged" "➤ Changes not staged for commit")
    ("untracked" "➤ Untracked files")))

(define (get-header-msg sym)
  (let [[header (find-alist sym header-msg)]]
    (last header)))

(define (mod-stat status)
  (cond
   [(string=? "mod-staged" status) " <= Re-stage or commit this file"]
   [""]))

(define (colorify stat sym)
  (cond
   [(string=? "   deleted" stat) (color "deleted" stat)]
   [(color sym stat)]))

(define (current-branch)
  (let ([branch (exec-system "git rev-parse --abbrev-ref HEAD")])
    (cond
     [(non-empty-string? branch) (first (string-split branch "\n"))]
     [""])))

(define (staged-files?)
  (non-empty-string? (exec-system "git diff --cached --name-status")))

(define (get-file-status-and-name number)
  (hash-ref status-hash (string->number number)))

(define (get-file-status number)
  (car (get-file-status-and-name number)))

(define (get-file-name number)
  (cdr (get-file-status-and-name number)))

(define (process-statuses statuses) 
  (let [[step 1]] 
    (for-each 
     (lambda [file-status]
       (let ([statcol (substring file-status 0 2)]
	     [file (substring file-status 3 (string-length file-status))])
	 (hash-set! status-hash step (cons statcol file))
	 (set! step (+ step 1)))) statuses)))

(define (set-status-hash)
  (process-statuses (string-split (git-status) "\n")))

(define (reset-status-hash)
  (hash-clear! status-hash)
  (set-status-hash))

(define (set-sorted-status key numb stat-pair)
  (let ([stage-hash (hash-ref sorted-status key)])
     (hash-set! stage-hash numb stat-pair)))

(define (status-seperator number msg file)
  (let [[stat-pair (list file msg)]
	[numb (string->number number)]]
    (set-sorted-status (last msg) numb stat-pair)))

(define (segregate-status status-pair numb)
  (let ([status (car status-pair)]
	[file (cdr status-pair)]
	[number (number->string numb)])
    (let ([msg-list (find-alist status status-list)])
      (cond
       [(list? msg-list) (status-seperator number (last msg-list) file)]
       [(list status number file)]))))

(define (sort-status-hash)
  (hash-for-each
   status-hash (lambda [numb pair] (segregate-status pair numb))))

(define (process-sort-table sort-list sym)
  (let [[keys (sort (hash-keys sort-list) <)]]
    (map
     (lambda [key]
       (let [[stat-pair (hash-ref sort-list key)]]
	 (let [[status (symbol->string (cadadr stat-pair))]
	       [number (number->string key)]
	       [file (color sym (car stat-pair))]
	       [lbrace (color "head" " [")]
	       [rbrace (color "head" "] ")]]
	   (let [[msg (mod-stat status)]
		 [stat (colorify status sym)]]
	     (display (color sym line-seperator))
	     (display (string-append stat ": " lbrace number rbrace file msg)))))) keys)))

(define (show-status-files sym)
  (let [[sort-table (hash-ref sorted-status sym)]]
    ;; (displayln sym)
    ;; (displayln (hash-ref sorted-status sym))
    (cond 
     [(not (hash-values sort-table))
      (begin
	(display (color sym (last (get-header-msg sym))))
	(display (color sym line-seperator))
	(process-sort-table sort-table sym)
	(displayln (color sym line-seperator)))])))

(define (branch-status count)
  (display
   (string-append
    (color "head" "# ") "On branch: " (current-branch) " | " count)))

(define (print-statuses) 
  (let [[count (hash-count status-hash)]]
    (branch-status (color "changes" (format "[+~S]" count)))
    (display (string-append (color "head" line-seperator) "\n"))
    (show-status-files "staged")
    (show-status-files "unstaged")
    (show-status-files "untracked")
    ))

(define (show-status)
  (cond
     [(non-empty-string? (git-status))
      (set-status-hash)
      (sort-status-hash)
      (print-statuses)]
     (branch-status "Working directory clean")))

(define (add-file name)
  (system (format "git add ~S" name)))

(define (range->number-list str)
  (map (lambda (n) (string->number n))
	(string-split "\\d+" (car str))))

(define (range->list str)
  (let [[file-numb (range->number-list str)]]
    (map (lambda (n) (number->string n)) 
	 (range (first file-numb) (last file-numb)))))

(define (add-file-from-list file-numbers) 
  (for-each 
   (lambda [number]
     (let [[file (get-file-name number)]]
       (add-file file))) file-numbers))

(define (add-files status-range)
  (set-status-hash)
  (if (string-contains? "-" (car status-range))
      (let [[file-range (range->list status-range)]]
	(add-file-from-list file-range))
      (add-file-from-list status-range))
  (reset-status-hash)
  (show-status))

(define (diff file-names)
  (system (format "git diff ~S" file-names)))

(define (git-diff file-numbers)
  (cond
   [(null? file-numbers) (diff ".")]
   [(set-status-hash)
    (diff (string-join (map get-file-name file-numbers) " "))]))

(define (commit)
  (display "Commit Message: ")
  (let [[message (read-line)]]
   (system (format "git commit -m ~S" message))))

(define (unstage file-names)
  (let [[files (string-join file-names " ")]]
    (cond
     [(non-empty-string? files) (system (string-append "git reset " files))]
     [(system "git reset .")])))

(define (git-reset file-numbers)
  (set-status-hash)
  (unstage (map get-file-name file-numbers)))

(define (checkout file)
  (system (format "git checkout ~S" file)))

(define (git-checkout numbers)
  (set-status-hash)
  (let [[file-list (map get-file-name numbers)]]
    (checkout (string-join file-list " "))))

(define (rm-files numbers)
  (display "Are you sure you want to delete files [Y/n] ? : ")
  (let [[reader (read-line)]]
    (cond
     ((string=? reader "Y")
      (set-status-hash)
      (let [[file-list (map get-file-name numbers)]]
	(map delete-file file-list))))))

(define (commit-all)
  (add-files (hash-keys status-hash))
  (commit))

(define (get-untracked-file file-number)
  (car (hash-ref untracked (string->number file-number))))

(define (ignored-files file-number)
  (let [[file-name (get-untracked-file file-number)]]
   file-name))

(define (append-file-to-ignore-list file-number)
  (let [[file-name (ignored-files file-number)]]
    (system (format "echo ~S >> .gitignore" file-name))
    (display (format "~S added to .gitignore\n" file-name))))

(define (append-to status-range)
  (let loop [(stat-range status-range)]
    (cond (not (null? stat-range))
	[(begin
	  (append-file-to-ignore-list (car stat-range))
	  (loop (cdr stat-range)))])))

(define (git-ignore status-range)
  (set-status-hash)
  (sort-status-hash)
  (if (string-contains? "-" (car status-range))
      ;;check if any numbers in range exist in untracked list.
      (let [[file-range (range->list status-range)]]
	(append-to file-range))
      (append-to status-range)))
