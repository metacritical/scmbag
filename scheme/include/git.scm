(define status-hash (make-hash-table))

(define sorted-status (make-hash-table))

(define staged (make-queue))

(define unstaged (make-queue))

(define untracked (make-queue))

(hash-table-set! sorted-status ':staged staged)
(hash-table-set! sorted-status ':unstaged unstaged)
(hash-table-set! sorted-status ':untracked untracked)

(define (exec-system command)
  (call-with-input-pipe command read-all))

(define (git-status)
  (exec-system
   "git status --short --untracked"))

(define (current-branch)
  (let  [[branch (exec-system "git rev-parse --abbrev-ref HEAD")]]
    (cond
     ((string-null? branch) "")
     (else (first (string-split branch "\n"))))))

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
       (let [[statcol (substring file-status 0 2)]
	     [file (substring file-status 3 (string-length file-status))]]
	(hash-table-set! status-hash step (cons statcol file))
	(set! step (+ step 1)))) statuses)))

(define (set-status-hash status)
  (process-statuses (string-split status "\n")))

(define (sort-status status-pair numb)
  (let [[status (car status-pair)] [file (cdr status-pair)] 
	[number (number->string numb)]]
    (let [[msg-list (find-alist status status-list)]]
      (cond
       ((list? msg-list) (status-seperator number msg-list file))
       (else (list status number file))))))

(define (status-seperator number msg-list file)
  (let [[stat-pair (list number file msg-list)]]
    (cond
     ((eq? (last msg-list) ':staged) (queue-add! staged stat-pair))
     ((eq? (last msg-list) ':unstaged) (queue-add! unstaged stat-pair))
     ((eq? (last msg-list) ':untracked) (queue-add! untracked stat-pair))
     ((eq? (last msg-list) ':mod-staged) (queue-add! staged stat-pair)))))

(define (process-queue queue sym)
  (let [[qlist (reverse (queue->list queue))]]
    (map
     (lambda [item]
       (let [[status (symbol->string (first (cdaddr item)))]
	     [number (car item)]
	     [file (color sym (cadr item))]
	     [lbrace (color ':line-sep " [")]
	     [rbrace (color ':line-sep "] ")]]
	 (let [[msg (mod-stat status)]
	       [stat (colorify status sym)]]
	   (string-append stat ": " lbrace number rbrace file msg)))) qlist)))


(define (show-status-files sym)
  (let [[queue (hash-table-ref sorted-status sym)]]
    (if (queue-empty? queue)
	""
	(begin
	  (print (color sym (get-header-msg sym)))
	  (print (color sym line-seperator))
	  (for-each
	   (lambda [file] 
	     (begin
	       (print (color sym line-seperator) file)))
	   (process-queue queue sym))
	  (print (color sym line-seperator))))))

(define (branch-status count)
  (print (string-append  
	  (color ':line-sep line-seperator) 
	  "On branch: " (current-branch) " | " count)))

(define (print-statuses) 
  (let [[count (hash-table-size status-hash)]]
    (branch-status (color ':mod-staged (format "[+~S]" count)))
    (print (color ':line-sep line-seperator))
    (show-status-files ':staged)
    (show-status-files ':unstaged)
    (show-status-files ':untracked)))

(define (show-status)
  (let [[status (git-status)]]
    (cond
     ((string-null? status) (branch-status "Working directory clean"))
     (else
      (set-status-hash status)
      (hash-table-walk status-hash (lambda [numb pair] (sort-status pair numb)))
      (print-statuses)))))

(define (add-file name)
  (system (format "git add ~S" name)))

(define (add-files file-numbers)
  (set-status-hash (git-status))
  (for-each 
   (lambda [number]
     (let [[file (get-file-name number)]]
      (add-file file))) file-numbers)
  (show-status))

(define (diff file-names)
  (system (format "git diff ~S" (string-join file-names " "))))

(define (git-diff file-numbers)
  (cond
   ((null? file-numbers) (diff file-numbers))
   (else
    (set-status-hash (git-status))
    (print (diff (map get-file-name file-numbers))))))

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
  (set-status-hash (git-status))
  (unstage (map get-file-name file-numbers)))

(define (checkout file)
  (system (format "git checkout ~S" file)))

(define (git-checkout numbers)
  (set-status-hash (git-status))
  (let [[file-list (map get-file-name numbers)]]
    (checkout (string-join file-list " "))))

(define (rm-files numbers)
  (display "Are you sure you want to delete files [Y/n] ? : ")
  (let [[reader (read-line)]]
    (cond
     ((string=? reader "Y")
      (set-status-hash (git-status))
      (let [[file-list (map get-file-name numbers)]]
	(map delete-file* file-list))))))

(define (commit-all)
  (add-files (hash-table-keys status-hash))
  (commit))
