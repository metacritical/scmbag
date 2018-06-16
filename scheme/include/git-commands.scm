(define status-hash (make-hash-table))

(define (exec-system command)
  (call-with-input-pipe command read-all))

(define (git-status)
  (exec-system
   "git status --short --untracked $(git rev-parse --show-toplevel)"))

(define (staged-files?)
  (not (string-null? (exec-system "git diff --cached --name-status"))))

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
      (string-append "#    Staged and Modified" " [" number "] " file))
     ((string=? status "M ")
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
  (exec-system "git rev-parse --abbrev-ref HEAD"))

(define (set-status-hash status)
  (process-statuses (string-split status "\n")))

(define (show-status)
  (let [[status (git-status)] [branch (current-branch)]]
    (cond
     ((string=? status "")
      (print "On branch: " current-branch "Working directory Clean"))
     (else
      (set-status-hash status)
      (do [[i 1 (+ i 1)]]
	  ((> i (hash-table-size status-hash)) "")
	 (print (get-status (hash-table-ref status-hash i) i)))))))

(define (add-file name)
  (system (format "git add ~S" name)))

(define (add-file-from number)
  (let [[file (last (hash-table-ref status-hash (string->number number)))]]
    (add-file file)))

(define (add-files file-numbers)
  (set-status-hash (git-status))
  (for-each 
   (lambda [number]
     (add-file-from number)) file-numbers))
