(define git-status
  (lambda ()
    (call-with-input-pipe "git status --short" read-all)))

(define (process-statuses statuses) 
  (let [[step 1]] 
    (for-each 
     (lambda [file-status] 
       (split-and-number (string-split file-status " ") step)
       (set! step (+ step 1))) statuses)))

(define (split-and-number status-pair step)
  (let [[status (first status-pair)] [file (last status-pair)]]
    (cond 
     ((string=? status "??")
      (print "#    Untracked File" " [" step "] " file))
     ((string=? status "A")
      (print "#    New File added" " [" step "] " file))
     ((string=? status "M")
      (print "#    Modified" " [" step "] " file))
     ((string=? status "M ")
      (print "#    Added and Modified" " [" step "] " file))
     ((string=? status "MM")
      (print "#    Modified not Staged" " [" step "] " file))
     ((string=? status "D")
      (print "#    Deleted" " [" step "] " file))
     ((string=? status "C")
      (print "#    File Copied" " [" step "] " file))
     ((string=? status "U")
      (print "#    Updated or Unmerged")))))
