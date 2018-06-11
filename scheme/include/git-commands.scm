(define status-hash (make-hash-table))

(define git-status
  (lambda ()
    (call-with-input-pipe "git status --short --untracked ./" read-all)))

;;For staged but not committed
;;git diff --cached --name-status  
;; (print (hash-table->alist status-hash))

(define (process-statuses statuses) 
  (let [[step 1]] 
    (for-each 
     (lambda [file-status]
       (let [[status-pair (string-split file-status " ")]]
	(hash-table-set! status-hash step status-pair)
	(set! step (+ step 1)))) statuses)))

(define (print-status status-pair number)
    (let [[status (first status-pair)] [file (last status-pair)]]
     (cond 
      ((string=? status "??")
       (print "#    Untracked File" " [" number "] " file))
      ((string=? status "A")
       (print "#    New File added" " [" number "] " file))
      ((string=? status "M")
       (print "#    Modified" " [" number "] " file))
      ((string=? status "AM")
       (print "#    Added and Modified" " [" number "] " file))
      ((string=? status "MM")
       (print "#    Modified not Staged" " [" number "] " file))
      ((string=? status "D")
       (print "#    Deleted" " [" number "] " file))
      ((string=? status "C")
       (print "#    File Copied" " [" number "] " file))
      ((string=? status "R")
       (print "#    File Renamed" " [" number "] " file))
      ((string=? status "U")
       (print "#    Updated or Unmerged"))
      (else (print "#    File Renamed" " [" number "] " file)))))

(define (set-status-hash status)
  (process-statuses (string-split status "\n")))

(define (show-status)
  (set-status-hash (git-status))
  (do [[i 1 (+ i 1)]]
      ((> i (hash-table-size status-hash)) "")
    (print-status (hash-table-ref status-hash i) i)))

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
