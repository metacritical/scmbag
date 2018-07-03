(define (git-status) (exec-system "git status --short --untracked"))

(define status (git-status))

(define status-hash (make-hash-table))

(define sorted-status (make-hash-table))

(define staged (make-hash-table))

(define unstaged (make-hash-table))

(define untracked (make-hash-table))

(hash-table-set! sorted-status ':staged staged)
(hash-table-set! sorted-status ':unstaged unstaged)
(hash-table-set! sorted-status ':untracked untracked)

(define (exec-system command)
  (call-with-input-pipe command read-all))

(define (current-branch)
  (let ([branch (exec-system "git rev-parse --abbrev-ref HEAD")])
    (cond
     [(string-null? branch) ""]
     [else (first (string-split branch "\n"))])))

(define (staged-files?)
  (not (string-null? (exec-system "git diff --cached --name-status"))))

(define (get-file-status-and-name number)
  (hash-table-ref status-hash (string->number number)))

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
	(hash-table-set! status-hash step (cons statcol file))
	(set! step (+ step 1)))) statuses)))

(define (set-status-hash)
  (process-statuses (string-split (git-status) "\n")))

(define (reset-status-hash)
  (hash-table-clear! status-hash)
  (set-status-hash))

(define (segregate-status status-pair numb)
  (let ([status (car status-pair)] [file (cdr status-pair)] [number (number->string numb)])
    (let ([msg-list (find-alist status status-list)])
      (cond
       [(list? msg-list) (status-seperator number msg-list file)]
       [else (list status number file)]))))

(define (set-sorted-status key numb stat-pair)
  (let ([stage-hash (hash-table-ref sorted-status key)])
     (hash-table-set! stage-hash numb stat-pair)))

(define (status-seperator number msg file)
  (let [[stat-pair (list file msg)]
	[numb (string->number number)]]
    (set-sorted-status (last msg) numb stat-pair)))

(define (sort-status-hash)
  (hash-table-walk
   status-hash (lambda [numb pair] (segregate-status pair numb))))

(define (process-sort-table sort-list sym)
  (let [[keys (sort (hash-table-keys sort-list) <)]]
    (map
     (lambda [key]
       (let [[stat-pair (hash-table-ref sort-list key)]]
	 (let [[status (symbol->string (cadadr stat-pair))]
	       [number (number->string key)]
	       [file (color sym (car stat-pair))]
	       [lbrace (color ':head " [")]
	       [rbrace (color ':head "] ")]]
	   (let [[msg (mod-stat status)]
		 [stat (colorify status sym)]]
	     (display (color sym line-seperator))
	     (print (string-append stat ": " lbrace number rbrace file msg)))))) keys)))

(define (show-status-files sym)
  (let [[sort-table (hash-table-ref sorted-status sym)]]
    (if (null? (hash-table-keys sort-table))
	""
	(begin
	  (print (color sym (get-header-msg sym)))
	  (print (color sym line-seperator))
	  (process-sort-table sort-table sym)
	  (print (color sym line-seperator))))))

(define (branch-status count)
  (print 
   (string-append
    (color ':head "# ") "On branch: " (current-branch) " | " count)))

(define (print-statuses) 
  (let [[count (hash-table-size status-hash)]]
    (branch-status (color ':changes (format "[+~S]" count)))
    (print (color ':head line-seperator))
    (show-status-files ':staged)
    (show-status-files ':unstaged)
    (show-status-files ':untracked)))

(define (show-status)
  (cond
     ((string-null? status) (branch-status "Working directory clean"))
     (else
      (set-status-hash)
      (sort-status-hash)
      (print-statuses))))

(define (add-file name)
  (system (format "git add ~S" name)))

(define (range->number-list str)
  (map (lambda (n) (string->number n))
	(string-split-fields "\\d+" (car str))))

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
  (if (string-search "-" (car status-range))
      (let [[file-range (range->list status-range)]]
	(add-file-from-list file-range))
      (add-file-from-list status-range))
  (reset-status-hash)
  (show-status))

(define (diff file-names)
  (system (format "git diff ~S" file-names)))

(define (git-diff file-numbers)
  (cond
   ((null? file-numbers) (diff "."))
   (else
    (set-status-hash)
    (diff (string-join (map get-file-name file-numbers) " ")))))

(define (commit)
  (display "Commit Message: ")
  (let [[message (read-line)]]
   (system (format "git commit -m ~S" message))))

(define (unstage file-names)
  (let [[files (string-join file-names " ")]]
    (cond
     ((string-null? files) (system "git reset ."))
     (else
      (system (string-append "git reset " files))))))

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
	(map delete-file* file-list))))))

(define (commit-all)
  (add-files (hash-table-keys status-hash))
  (commit))

(define (get-untracked-file file-number)
  (car (hash-table-ref untracked (string->number file-number))))

(define (ignored-files file-number)
  (let [[file-name (get-untracked-file file-number)]]
   file-name))

(define (append-file-to-ignore-list file-number)
  (let [[file-name (ignored-files file-number)]]
    (system (format "echo ~S >> .gitignore" file-name))
    (display (format "~S added to .gitignore\n" file-name))))

(define (append-to status-range)
  (let loop [(stat-range status-range)]
    (if (not (null? stat-range))
	(begin
	  (append-file-to-ignore-list (car stat-range))
	  (loop (cdr stat-range))))))

(define (git-ignore status-range)
  (set-status-hash)
  (sort-status-hash)
  (if (string-search "-" (car status-range))
      ;;check if any numbers in range exist in untracked list.
      (let [[file-range (range->list status-range)]]
	(append-to file-range))
      (append-to status-range)))
