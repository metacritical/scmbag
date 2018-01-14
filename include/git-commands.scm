(define git-status
  (lambda ()
    (call-with-input-pipe "git status --short" read-all)))

(define (process-statuses statuses) 
  (for-each 
   (lambda [file-status] 
     (split-and-number (string-split file-status " "))) 
   statuses))

(define (split-and-number status-pair)
  (let [[status (first status-pair)] [file (last status-pair)]]
    (cond 
     ((string=? status "??")
      (print "Untracked File"))
     ((string=? status "A")
      (print "New Added" " [X] " file))
     ((string=? status "M")
      (print "File Modified"))
     ((string=? status "AM")
      (print "File Added and Modified"))
     ((string=? status "D")
      (print "File Deleted"))
     ((string=? status "C")
      (print "File Copied"))
     ((string=? status "U")
      (print "Updated or Unmerged")))))
