(define status-hash (make-hash-table))

(define (exec-system command)
  (call-with-input-pipe command read-all))

(define (git-status)
  (exec-system
   "git status --short --untracked $(git rev-parse --show-toplevel)"))

(define (staged-files?)
  (not (string-null? (exec-system "git diff --cached --name-status"))))

(define (get-file-status-and-name number)
  (hash-table-ref status-hash (string->number number)))

(define (get-file-status number)
  (first (get-file-status-and-name number)))

(define (get-file-name number)
  (last (get-file-status-and-name number)))

(define (process-statuses statuses) 
  (let [[step 1]] 
    (for-each 
     (lambda [file-status]
       (let [[status-pair (string-split file-status " ")]]
	(hash-table-set! status-hash step status-pair)
	(set! step (+ step 1)))) statuses)))

(define (get-status status-pair numb)
  (let [[status (first status-pair)] [file (last status-pair)] 
	[number (number->string numb)]]
    (cond 
     ((string=? status "??")
      (string-append "#    Untracked File" " [" number "] " file))
     ((string=? status "A")
      (string-append "#    New File added" " [" number "] " file))
     ((string=? status "M")
      (string-append "#    Modified" " [" number "] " file))
     ((string=? status "AM")
      (string-append "#    Added and Modified" " [" number "] " file))
     ((string=? status "MM")
      (string-append "#    Modified not Staged" " [" number "] " file))
     ((string=? status "D")
      (string-append "#    Deleted" " [" number "] " file))
     ((string=? status "C")
      (string-append "#    File Copied" " [" number "] " file))
     ((string=? status "R")
      (string-append "#    File Renamed" " [" number "] " file))
     ((string=? status "U")
      (string-append "#    Updated or Unmerged"))
     (else (print "#    File Renamed" " [" number "] " file)))))

(define (current-branch)
  (let  [[branch (exec-system "git rev-parse --abbrev-ref HEAD")]]
    (cond
     ((string-null? branch) "")
     (else (first (string-split branch "\n"))))))

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
  (set-status-hash (git-status))
  (print (diff (map get-file-name file-numbers))))

(define (commit)
  (display "Commit Message: ")
  (let [[message (read-line)]]
   (system (format "git commit -m \"~S\"" message))))
