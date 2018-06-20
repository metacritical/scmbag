(define status-hash (make-hash-table))

(define (exec-system command)
  (call-with-input-pipe command read-all))

(define (git-status)
  (exec-system
   "git status --short --untracked"))

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

(define (get-status status-pair numb)
  (let [[number (number->string numb)]]
    (get-status-msg status-pair number)))

(define (set-status-hash status)
  (process-statuses (string-split status "\n")))

(define (show-status)
  (let [[status (git-status)] [branch (current-branch)]]
    (cond
     ((string-null? status)
      (print (string-append "On branch: " branch " | Working directory clean")))
     (else
      (set-status-hash status)
      (do [[i 1 (+ i 1)]]
	  ((> i (hash-table-size status-hash)) "")
	(print (get-status (hash-table-ref status-hash i) i)))))))

(define (add-file name)
  (system (format "git add ~S" name)))

(define (add-file-from number)
  (let [[file (get-file-name number)]]
    (add-file file)))

(define (add-files file-numbers)
  (set-status-hash (git-status))
  (for-each 
   (lambda [number]
     (add-file-from number)) file-numbers))

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

(define (current-branch)
  (let  [[branch (exec-system "git rev-parse --abbrev-ref HEAD")]]
    (cond
     ((string-null? branch) "")
     (else (first (string-split branch "\n"))))))

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
